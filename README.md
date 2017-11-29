# omni-vagrant

The instructions below will help you do the following three things to setup a local development environment for OmniBuilds

1. Create a vagrant virtual machine to host the django development environment
2. Install and run the server (Django API) project in the vagrant vm
3. Install and run the app (Vue SPA) on your machine (but in the shared vagrant folder)

When complete you should be able run the server on localhost:8000 and the app on port:8080 and they should talk to each other out of the box

## 12 steps to dev ready!
**Start here if you need to install vagrant and virutal box on your machine**

* Install virtual box **(> 1.9)**, vagrant **(below 5.2)**, and vagrant manager (optional)
  - [vagrant download here](https://www.vagrantup.com/downloads.html)
  - [virtualbox download here](https://www.virtualbox.org/wiki/Download_Old_Builds_5_1)
  - [vagrant manager download here](http://vagrantmanager.com/downloads/)

**If you already have them installed do the following**

```shell
# 1. Download the repo via ssh or https
    git clone git@github.com:jwagstaff/omni-vagrant.git
    git clone https://github.com/jwagstaff/omni-vagrant.git

# 2. Navigate to the cloned omni-vagrant folder
    cd ./omni-vagrant

# 3. Open up env_setup.sh and enter your github credentials (**To pull down omnibuild's private repo**)
    line 14: github_credential='TOKEN_or_username:password'
    for 2 factor auth use the token gathered from github
    for regular username and password auth format string with ':' between username and password

# 4. Run installation for vagrant
    vagrant up

# 5. Once installation finishes you can ssh into the vagrant box
    vagrant ssh

# 6. Start backend server(**within the vagrant box**)
    cd ~/omnibuilds.com/server/src
    python manage.py runserver 0.0.0.0:8000

# 7. Navigate to localhost:8000 in the browser to see landing page

# 8. To start the frontend app navigate to the app folder(**within your local computer**)
    cd ./app

# 9. Install all node dependencies
    npm Install

# 10. Start frontend app (Vue SPA running on port 8080)
    npm run dev

# 11. Navigate to localhost:8080 in the browser to see frontend app

# 12. CHEERS! 🍺🍻🥂
```

**NOTE:**
> There are some preset fixtures that are loaded into the initial setup and a super user is created with *username: admin password: admin123*
