To Do
=====

**General**

  - Create readme. [done]
  - Add .dockerignore file [done]
  - Push to GitHub. [done]
  - Add a default editor - vim. Perhaps setup an editor option. [Done]
  - Are pre-commit hooks a bit much here?
  - Support CI/CD with GitHub Actions (ex. On git push, build docker image, test and push to docker hub).
  - Write about it all

**User and Groups**
  
  - Everything is run as root at present, which is not a good practice.
  - Change this to a local user and setup group and permissions accordingly.

**Git**

  - [Done] Change the default branch from ``master`` to ``main``.::
    
      git config --global init.defaultBranch main

**Jupyter Lab**

  - Fix issue where connecting to Jupyter Lab Server from VS Code causes the messags below to appear, repeatedly.

    .. code:: sh

       [W 2022-06-01 14:25:04.100 ServerApp] Forbidden
       [W 2022-06-01 14:25:04.102 ServerApp] 403 GET /api/kernels?1654093499976 (172.17.0.1) 167.87ms referer=None
