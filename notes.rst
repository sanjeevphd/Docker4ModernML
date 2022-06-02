To Do
=====

**General**

  - Create readme. [done]
  - Add .dockerignore file [done]
  - Push to GitHub. [done]
  - Support CI/CD with GitHub Actions (ex. On git push, build docker image, test and push to docker hub).
  - Write about it all

**User and Groups**
  
  - Everything is run as root at present, which is not a good practice.
  - Change this to a local user and setup group and permissions accordingly.

**Git**

  - Change the default branch from ``master`` to ``main``.::
    
      git config --global init.defaultBranch main

  - Add git user name and email.::
    
      git config --global user.name "user name"
      git config --global user.email "user.name@email.com"

**Jupyter Lab**

  - Fix issue where connecting to Jupyter Lab Server from VS Code causes the messags below to appear, repeatedly.

    .. code:: sh

       [W 2022-06-01 14:25:04.100 ServerApp] Forbidden
       [W 2022-06-01 14:25:04.102 ServerApp] 403 GET /api/kernels?1654093499976 (172.17.0.1) 167.87ms referer=None
