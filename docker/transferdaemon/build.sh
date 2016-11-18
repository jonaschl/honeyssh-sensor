#!/bin/bash

. /usr/lib/docker-shell-scripts-lib/tag.sh
. /usr/lib/docker-shell-scripts-lib/get-id.sh
. /usr/lib/docker-shell-scripts-lib/preparation.sh
. /usr/lib/docker-shell-scripts-lib/logging.sh
. /usr/lib/docker-shell-scripts-lib/install.sh

###
### Build the Transferdaemon Dockerimage
###

# cd into script dir
(cd $(dirname -- "$(readlink -e -- "$BASH_SOURCE")") || exit

### preparation ###
# check for all necessary files

CheckForFile "root-pub.pem"
CheckForFile "setup-org.sh"
CheckForFile "Dockerfile"
CheckForFile "systemd/honeyssh-transfer.docker.service"


#create a work copy of setup.sh
cp setup-org.sh setup.sh
### paramater for transferadaemon build
repo="honeyssh-transferdaemon"
dockertag="new"
username="jonatanschlag"
tag="${username}/${repo}:${dockertag}"
### Build the docker image
docker build --no-cache=true -t "$tag" .
### Tag the docker image
back=$(tag-image "${username}/${repo}")
rm -f setup.sh

### Install systemd files

InstallSystemdUnitFile systemd/honeyssh-transfer.docker.service

)
