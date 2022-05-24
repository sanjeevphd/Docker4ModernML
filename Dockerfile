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

ARG LINUX_CONTAINER=moninav/pyenv:3.9-ubuntu:20.04

FROM $LINUX_CONTAINER as base

LABEL maintainer="Goopy Flux <goopy.flux@gmail.com>"

ARG python_version=3.9.13
ARG NB_USER="earthling"

USER root

ENV DEBIAN_FRONTEND=noninteractive

# Install OS dependencies and update OS libraries and packages
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y \
        bash \
        bash-completion \
        build-essential \
        curl \
        git \
        locales \
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
        apt-get clean && rm -rf /var/lib/apt/lists/* && \
        echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
        locale-gen

ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

SHELL ["/bin/bash", "-c"]

# Pyenv and Python
RUN git clone https://github.com/pyenv/pyenv.git ${HOME}/.pyenv && \ 
    # bash specific entries
    cd ${HOME}/.pyenv && src/configure && make -C src && \
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ${HOME}/.bashrc && \
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ${HOME}/.bashrc && \
    echo 'eval "$(pyenv init -)"' >> ${HOME}/.bashrc && \
    # .profile entries
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile && \
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile && \
    echo 'eval "$(pyenv init -)"' >> ~/.profile

ENV PYENV_ROOT "${HOME}/.pyenv"
ENV PATH "$PYENV_ROOT/bin:$PATH"

RUN eval "$(pyenv init -)" && \
    eval "$(pyenv init --path)" && \
    . /etc/profile

RUN pyenv install $python_version && \
    pyenv global $python_version

