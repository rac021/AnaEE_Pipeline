#!/bin/bash

if [ $# -eq 1 ] ; then

	# Docker Image
	DOCKER_BLZ_IMAGE=$1

	CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

	DOCKER_FILE_PATH="$CURRENT_PATH/Docker"
	
	if [ ! -e $DOCKER_FILE_PATH ]; then
	
	    echo "$CURRENT_PATH Not found !! Has Project cloned from Git ? "
	
	else
		if docker history -q $DOCKER_BLZ_IMAGE >/dev/null 2>&1 ; then
	
		    CONTAINER_ID=`docker images -q $DOCKER_BLZ_IMAGE `
		    echo "$DOCKER_BLZ_IMAGE already exist, remove it..."
		    echo "Conainer ID : $CONTAINER_ID "
		    docker rmi -f $CONTAINER_ID
		fi
		
		tput setaf 2
		echo ""
		echo "############################################"
		echo "### Building Image : $DOCKER_BLZ_IMAGE   ###"
		echo "############################################"
		echo ""
		sleep 2
		tput setaf 7
		
		docker build -t $DOCKER_BLZ_IMAGE $DOCKER_FILE_PATH
	fi

else
    echo " Invalid argument : please pass exactly One argument "
    echo " arg_1 : Image_Docker_Name                           "
fi

