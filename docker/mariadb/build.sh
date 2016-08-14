#!/bin/bash
#
# Some Variables
#

. ../lib/getid.sh

###
### Build the MariaDB Dockerimage
###

#create a work copy of setup.sh
cp setup-org.sh setup.sh
### paramter for mariadb build
repo="honeyssh-mariadb"
dockertag="new"
username=jonatanschlag
tag="${username}/${repo}:${dockertag}"
### Build the docker image
docker build --no-cache=true -t "$tag" .
### tag the new mariadb image
date=$(date +%Y-%m-%d)
patternrep="$username/${repo}"
patterntag="$date"
### get id of the image from today
back=$(getid $patternrep $patterntag)
set $back
id=$1
backerrorlevel=$2
### check if the getid script finish with errorlevel 0
if [ "$backerrorlevel" = "0" ] ; then
  # the id is empty
      if [ "$id" = "empty" ] ; then
      # get the id from the new image
      patternrep="$username/${repo}"
      patterntag="new"
      back=$(getid $patternrep $patterntag)
      set $back
      id=$1
      backerrorlevel=$2
      # check if the getid script finish with errorlevel 0
        if [ "$backerrorlevel" = "0" ] ; then
          # rmi the tag latest
          docker rmi "$username/$repo:latest"
          # tag the new immage with the date from today and latest
          docker tag "$id" "$username/$repo:latest"
          docker tag "$id" "$username/$repo:$date"
          # rmi the tag new
          docker rmi "$username/$repo:new"
        else
          #set errorlevel to 1, because the call of the get id function in line 23 do not finish with errorlevel=0
          echo "tagging was not successful"
        fi
      else
      # the id is != empty
      patternrep="$username/${repo}"
      patterntag="new"
      back=$(getid $patternrep $patterntag)
      set $back
      id=$1
      backerrorlevel=$2
      # check if the getid script finish with errorlevel 0
        if [ "$backerrorlevel" = "0" ] ; then
          # rmi the image with the tag latest and $date
          docker rmi "$username/$repo:latest"
          docker rmi "$username/$repo:$date"
          #tag the new image with latest and date
          docker tag "$id" "$username/$repo:latest"
          docker tag "$id" "$username/$repo:$date"
          # rmi the tag new
          docker rmi "$username/$repo:new"
        else
          #set errorlevel to 1, because the call of the get id script in line 43 do not finish with errorlevel=0
          echo "tagging was not successful"
        fi
      fi
else
  echo "tagging was not successful"
fi
rm -f setup.sh


