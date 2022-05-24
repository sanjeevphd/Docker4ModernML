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
        wget \
        xz-utils \
        zlib1g-dev && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*

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

CMD ["/bin/bash"]
