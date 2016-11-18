#!/bin/bash

. /usr/lib/docker-shell-scripts-lib/tag.sh
. /usr/lib/docker-shell-scripts-lib/get-id.sh
. /usr/lib/docker-shell-scripts-lib/preparation.sh
. /usr/lib/docker-shell-scripts-lib/logging.sh
. /usr/lib/docker-shell-scripts-lib/install.sh

###
### Build the MariaDB Dockerimage
###

# checkout script directory
(cd $(dirname -- "$(readlink -e -- "$BASH_SOURCE")") || exit
### preparation ###

# check for all necessary files

CheckForFile "my.cnf"
CheckForFile "setup-org.sh"
CheckForFile  "Dockerfile"


#create a work copy of setup.sh
cp setup-org.sh setup.sh
### paramter for mariadb build
repo="honeyssh-mariadb"
dockertag="new"
username="jonatanschlag"
tag="${username}/${repo}:${dockertag}"
### Build the docker image
docker build --no-cache=true -t "$tag" .
### Tag the docker image
back=$(tag-image "${username}/${repo}")

if [ "error" = "$back" ]; then
        echo "Tagging was not successful"
fi
rm -f setup.sh

### Install systemd files

InstallSystemdUnitFile systemd/honeyssh-mariadb.docker.service
)
