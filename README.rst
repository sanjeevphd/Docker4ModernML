##############################################
Modern Machine Learning with Python and Docker
##############################################

A modern approach to data science and machine learning using Python & Docker.

Goals
=====

- Use a modern Python development stack geared towards automation and best practices.
- Harness Docker for a reproducible, portable development environment and ease transition to production.

Requirements
============

- Docker
- Bonus: GNU make to make full use of the ``Makefile``

Note: This has only been tested on macOS. Linux support is assumed. Windows support is untested.

Usage
=====

Basic usage
-----------

.. code:: sh

   make docker-run

Automatically pulls the latest image from Docker Hub the first time it is run. Subsequent runs will use local copy and will be faster. Copy the link to the Jupyter Lab server and paste it into a browser of your choice to access the Jupyter Lab.

By default, the current working directory ``$PWD`` will be used as the local directory that will be mapped to ``/root/work`` directory on the Docker container.

Specify Folder
--------------

.. code:: sh

   make docker-run host_volume=/full/path/to/local/folder

Use the ``host_volume`` option to specify the local folder to be used by the Docker container. The specified folder will be available under ``/root/work`` in the Docker container.

Build Docker Image
------------------

.. code:: sh

   make docker-build

Push Docker Image to Docker Hub
-------------------------------

This step requires creating an account and a repository on Docker Hub (free for public images). Update the `docker_hub_repo`` variable in ``Makefile`` to point to the correct repo on Docker Hub. 

.. code:: sh

   make docker-push

Features
========

- Uses ``pyenv`` for managing Python version
- Uses Python Development Master (``pdm``) for managing dependencies and packaging
- Uses Cookiecutter for project scaffolding
- Keeps the common packages and libraries related to Python development and DS/ML projects in a global space to avoid reinstalling for every project
- Keeps a local copy of the cookiecutter project template in the final image
- Aims for a small final image (work in progress).

Installed Packages
==================

**Python Development**

  - cookiecutter
  - nox
  - pre-commit
  - flake8
  - sphinx
  - sphinx-click
  - furo
  - black
  - pytest
  - coverage
  - typer
  - mypy

**Basic Python data science packages**

  - ipython
  - jupyterlab
  - numpy
  - scipy
  - matplotlib
  - pandas
  - seaborn
  - statsmodels

TODO
====

**User and Groups**
  
  - Everything is run as root at present, which is not a good practice.
  - Change this to a local user and setup group and permissions accordingly.

**Git**

  - git config --global init.defaultBranch main
  - git config --global user.name "user name"
  - git config --global user.email "user.name@email.com"

**Jupyter Lab**

  - Fix issue where connecting to Jupyter Lab Server from VS Code causes the messags below to appear, repeatedly.

    [W 2022-06-01 14:25:04.100 ServerApp] Forbidden
    
    [W 2022-06-01 14:25:04.102 ServerApp] 403 GET /api/kernels?1654093499976 (172.17.0.1) 167.87ms referer=None
