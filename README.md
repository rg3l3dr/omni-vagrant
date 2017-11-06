# omni-vagrant


## 12 steps to dev ready!
**Read General requirements below if vagrant and virtualbox has not been setup in your computer**

```shell
# 1. Download the repo via ssh or https
    git clone git@github.com:jwagstaff/omni-vagrant.git
    git clone https://github.com/jwagstaff/omni-vagrant.git

# 2. Navigate to the cloned omni-vagrant folder
    cd ./omni-vagrant

# 3. Open up env_setup.sh and enter your github username, password (**To pull down omnibuild's private repo**)
    line 12: github_username='username'
    line 13: github_password='password'

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

# 10. Start frontend app
    npm run dev

# 11. Navigate to localhost:8080 in the browser to see frontend app

# 12. CHEERS! 🍺🍻
```

**NOTE:**
> There are some preset fixtures that are loaded into the initial setup and a super user is created with *username: admin password: admin123*

## General requirements (just check to make sure you have all of this)

### Make sure the vagrant file is cloning the dev branch
### Make sure the vagrant file is setting tthe django localhost port to 8000

* Install virtual box **(> 1.9)**, vagrant, vagrant manager **(below 5.2)**
  - [vagrant download here](https://www.vagrantup.com/downloads.html)
  - [virtualbox download here](https://www.virtualbox.org/wiki/Download_Old_Builds_5_1)
* Clone the vagrant repo
* Change the GitHub user/pass
* Provision the vagrant instance
* Edit the .env file designs_bucket var with the dev initials for namespacing
* SSH into vagrant instance
* Run the server

## General App setup steps

```bash

# clone the repo at dev branch
git clone -b dev https://github.com/jwagstaff/app.git

# install dependencies
npm install

# serve with hot reload at localhost:8080
npm run dev

```
