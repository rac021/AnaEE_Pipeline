#!/bin/bash

# Note :
# To be able to set environment variables, 
# this script mut be launched using :  . ./01_infra_build.sh

 # Default name of docker image
DEFAULT_BLZ_IMAGE="blazegraph"

docker_file_path="Docker/Dockerfile"

if [ ! -e $docker_file_path ]

then
    echo "$docker_file_path not found. have you clone project from git ? "
else
       	if test ! -z "$1" ; then
	   DEFAULT_BLZ_IMAGE=$1
	fi
       
	if docker history -q $DEFAULT_BLZ_IMAGE >/dev/null 2>&1; then
	    container_id=`docker images -q $DEFAULT_BLZ_IMAGE `
	    echo "$DEFAULT_BLZ_IMAGE already exist, remove it..."
	    echo "Conainer ID : $container_id "
	    docker rmi -f $container_id
	fi

	export BLZ_IMAGE=$DEFAULT_BLZ_IMAGE

	echo "building image : $DEFAULT_BLZ_IMAGE "

	docker build -t $BLZ_IMAGE Docker

fi
