#!/bin/bash

# Note :
# To be able to set environment variables, 
# this script mut be launched using :  . ./01_infra_build.sh

CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Default name of docker image
DEFAULT_BLZ_IMAGE="BLZ"

DOCKER_FILE_PATH="$CURRENT_PATH/Docker"

if [ ! -e $DOCKER_FILE_PATH ]

then
    echo "$CURRENT_PATH Not found !! Haa Project cloned from Git ? "
else
       	if test ! -z "$1" ; then
	   DEFAULT_BLZ_IMAGE=$1
	fi
       
	if docker history -q $DEFAULT_BLZ_IMAGE >/dev/null 2>&1; then

	    CONTAINER_ID=`docker images -q $DEFAULT_BLZ_IMAGE `
	    echo "$DEFAULT_BLZ_IMAGE already exist, remove it..."
	    echo "Conainer ID : $CONTAINER_ID "
	    docker rmi -f $CONTAINER_ID
	fi

	export BLZ_IMAGE=$DEFAULT_BLZ_IMAGE

	tput setaf 2
	echo ""
	echo "############################################"
	echo "### Building Image : $DEFAULT_BLZ_IMAGE  ###"
	echo "############################################"
	echo ""
	sleep 2
	tput setaf 7
	
	docker build -t $DEFAULT_BLZ_IMAGE $DOCKER_FILE_PATH
fi

