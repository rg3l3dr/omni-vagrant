#!/usr/bin/env bash

###############################################################################
###############################################################################
# VAR SETUP.

###############################################################################
#      NOTE:                                                                  #
#      1. Change the github_username to your username                         #
#      2. Change the github_password to your password                         #
###############################################################################
github_username='username'
github_password='password'

domain_name="omnibuilds.com"
project_slug="omnibuilds"
virtual_env=".virtualenv"
db_user='vagrant'
db_password='vagrant'


start_seconds="$(date +%s)"
echo "Setting up omnibuilds vagrant env"

ping_result="$(ping -c 2 8.8.4.4 2>&1)"
if [[ $ping_result != *bytes?from* ]]; then
	echo "Network connection unavailable. Try again later."
	exit 1
fi

apt_packages=(
	vim
	curl
	git-all
	nodejs
	tree

	# Extra stuff, in case you want to SSH to the machine and work interactively
	tmux
	byobu

	# These are the pyenv requirements, see
	# https://github.com/yyuu/pyenv/wiki/Common-build-problems#requirements
	make
	build-essential
	libssl-dev
	zlib1g-dev
	libbz2-dev
	libreadline-dev
	libsqlite3-dev
	llvm
    python-pip
	postgresql-9.5

	# Needed for Python deps
    python-dev
	libpq-dev  # psycopg2
	libjpeg-dev  # Pillow: https://github.com/python-pillow/Pillow/issues/1275#issuecomment-185775965
)

sudo add-apt-repository -y ppa:git-core/ppa
sudo add-apt-repository -y ppa:nginx/stable
sudo add-apt-repository -y ppa:pi-rho/dev
sudo add-apt-repository -y ppa:byobu/ppa
sudo add-apt-repository -y "deb https://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main"

echo "Installing packages..."

sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y ${apt_packages[@]} --force-yes
sudo apt-get clean


if [[ ! -d "/home/vagrant/$domain_name" ]]; then
	mkdir "/home/vagrant/$domain_name"
	mkdir "/home/vagrant/$domain_name/logs"
fi

echo "Pull Latest code off github and install requirements from project..."

cd "/home/vagrant/$domain_name/"
git clone -b stage https://$github_username:$github_password@github.com/jwagstaff/server.git

echo "Setting up virtual ENV and setup PATH..."

cd "/home/vagrant/$domain_name/server"
sudo pip install virtualenv
virtualenv $virtual_env

export VIRTUAL_ENV_ROOT="/home/vagrant/$domain_name/server/$virtual_env"
export PATH="$VIRTUAL_ENV_ROOT/bin:$PATH"
export PYTHONPATH="$VIRTUAL_ENV_ROOT"

source "$VIRTUAL_ENV_ROOT/bin/activate"
# Ensure virtualenv will be sourced when sshed in for easy access
sudo echo "source $VIRTUAL_ENV_ROOT/bin/activate" >> /home/vagrant/.profile

# Install the Django requirements for development
cd "/home/vagrant/$domain_name/server"
# For some reason without installing the urllib3[secure] packages things won't install correctly...
# so here it is..
sudo /home/vagrant/$domain_name/server/$virtual_env/bin/pip install urllib3[secure]
sudo /home/vagrant/$domain_name/server/$virtual_env/bin/pip install -r requirements.txt
# sudo pip install urllib3[secure]
# sudo pip install -r requirements.txt

echo "Setup postgres for Django to use..."

if sudo -u postgres psql -lqt | cut -d \| -f 1 | grep -qw $project_slug; then
	echo "PostgreSQL database exists. Skipping setup."
else
	sudo -u postgres psql -c "CREATE DATABASE $project_slug"
	sudo -u postgres psql -c "CREATE USER $db_user WITH PASSWORD '$db_password'"
	sudo -u postgres psql -c "ALTER ROLE $db_user SET client_encoding TO 'utf8'"
	sudo -u postgres psql -c "ALTER ROLE $db_user SET default_transaction_isolation TO 'read committed'"
	sudo -u postgres psql -c "ALTER ROLE $db_user SET timezone TO 'UTC'"
	sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $project_slug TO $db_user"
fi

sudo cp /home/vagrant/$domain_name/server/src/server/.env.example /home/vagrant/$domain_name/server/src/server/.env
cd "/home/vagrant/$domain_name/server/src"
python manage.py migrate
python manage.py loaddata initial_data

# Clone the frontend app
cd "/home/vagrant/$domain_name"
git clone -b dev https://$github_username:$github_password@github.com/jwagstaff/app.git

end_seconds="$(date +%s)"
echo "-----------------------------"
echo "Provisioning complete in "$(expr $end_seconds - $start_seconds)" seconds"
