###############################################################################
# A modern approach to data science and machine learning using Python & Docker.
#
# Goals:
#   - Use a modern Python development stack geared towards automation and best
#     practices.
#   - Harness Docker for reproducible, portable development environment and
#     ease transition to production.
#
# Features:
#   - Uses pyenv for managing Python version
#   - Uses Python Development Master (PDM) for managing dependencies and 
#     packaging
#   - Uses Cookiecutter for project scaffolding
#   - Keeps the common packages and libraries related to Python development and 
#     DS/ML projects in a global space to avoid reinstalling for every project
#   - Keeps a local copy of the cookiecutter project template in the final image
#   - Aims for a small final image (work in progress).
#
#
# Installed Packages:
#   - Python Development
#     - cookiecutter
#     - nox
#     - pre-commit
#     - flake8
#     - sphinx
#     - sphinx-click
#     - furo
#     - black
#     - pytest
#     - coverage
#     - typer
#     - mypy
#
#   - Basic Python data science packages
#     - ipython
#     - jupyterlab
#     - numpy
#     - scipy
#     - matplotlib
#     - pandas
#     - seaborn
#     - statsmodels
#
# TODO:
#   - User and Groups
#     Everything is run as root at present, which is not a good practice.
#     Change this to a local user and setup group and permissions accordingly.
#
#   - Git
#     - git config --global init.defaultBranch main
#     - git config --global user.name "user name"
#     - git config --global user.email "user.name@email.com"
#
#  - Jupyter Lab
#    - Fix issue where connecting to Jupyter Lab Server from VS Code causes the messags below to appear, repeatedly.
#      >> [W 2022-06-01 14:25:04.100 ServerApp] Forbidden
#      >> [W 2022-06-01 14:25:04.102 ServerApp] 403 GET /api/kernels?1654093499976 (172.17.0.1) 167.87ms referer=None
#
###############################################################################

ARG LINUX_CONTAINER=ubuntu:20.04

FROM $LINUX_CONTAINER as base

LABEL maintainer="Goopy Flux <goopy.flux@gmail.com>"

ARG python_version=3.9.13

ENV DEBIAN_FRONTEND=noninteractive

# Install OS dependencies and update OS libraries and packages
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y \
        build-essential \
        curl \
        git \
        libbz2-dev \
        libffi-dev \
        liblzma-dev \
        libncurses5-dev \
        libncursesw5-dev \
        libreadline-dev \
        libssl-dev \
        libsqlite3-dev \
        llvm \
        make \
        python-openssl \
        tk-dev \
        vim \
        wget \
        xz-utils \
        zlib1g-dev && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*

# Git
RUN git config --global init.defalutBranch main

# Pyenv
ENV HOME "/root"
ENV PYENV_ROOT "${HOME}/.pyenv"
ENV PATH "${PYENV_ROOT}/bin:${PATH}"

RUN git clone https://github.com/pyenv/pyenv.git ${PYENV_ROOT}

# Python
RUN pyenv install $python_version && \
    pyenv global $python_version

RUN eval "$(pyenv init -)" && \
    eval "$(pyenv init --path)"

# Python Development Master (PDM)
ENV PATH "${HOME}/.pyenv/shims:${HOME}/.local/bin:${PATH}"

RUN curl -sSL https://raw.githubusercontent.com/pdm-project/pdm/main/install-pdm.py | python3 -

RUN eval "$(pdm --pep582)" && \
    pdm config global_project.fallback True

RUN echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && \
    pdm --pep582 bash >> ~/.bashrc && \
    pdm completion bash > /etc/bash_completion.d/pdm.bash-completion

# Common packages for modern Python development
RUN pdm add -g cookiecutter \
        nox \
        pre-commit \
        flake8 \
        sphinx \
        sphinx-click \
        furo \
        black \
        pytest \
        coverage \
        typer \
        mypy

# Basic Python data science packages
RUN pdm add -g ipython \
        jupyterlab \
        numpy \
        scipy \
        matplotlib \
        pandas \
        seaborn \
        statsmodels

# Jupyter Server
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y bash \
        bash-completion\
        locales && \
        apt-get clean && rm -rf /var/lib/apt/lists/* && \
        echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
        locale-gen

ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    SHELL=/bin/bash

EXPOSE 8888

# Configure container startup
VOLUME /root/work
WORKDIR /root/work
CMD ["start-notebook.sh", "--allow-root"]

# Copy local files as late as possible to avoid cache busting
COPY ./jupyter/start*.sh /usr/local/bin/
# Currently need to have both jupyter_notebook_config and jupyter_server_config to support classic and lab
COPY ./jupyter/jupyter_server_config.py /etc/jupyter/

# HEALTHCHECK documentation: https://docs.docker.com/engine/reference/builder/#healthcheck
# This healtcheck works well for `lab`, `notebook`, `nbclassic`, `server` and `retro` jupyter commands
# https://github.com/jupyter/docker-stacks/issues/915#issuecomment-1068528799
# HEALTHCHECK  --interval=15s --timeout=3s --start-period=5s --retries=3 \
    # CMD wget -O- --no-verbose --tries=1 --no-check-certificate \
        # http${GEN_CERT:+s}://localhost:8888${JUPYTERHUB_SERVICE_PREFIX:-/}api || exit 1
