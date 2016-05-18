#!/bin/bash

# Note :
# To be able to set environment variables, 
# this script mut be launched using :  . ./01_infra_build.sh

docker_file_path="Docker/Dockerfile"

if [ ! -e "docker_file_path" ]

then
    echo "$docker_file_path not found. have you clone project from git ? "
else

	DEFAULT_BLZ_IMAGE="blazegraph"

	if test ! -z "$1" ; then
	   DEFAULT_BLZ_IMAGE=$1
	fi
       
	if docker history -q $DEFAULT_BLZ_IMAGE >/dev/null 2>&1; then
	    echo "$DEFAULT_BLZ_IMAGE already exist, remove it..."
	    docker rmi -f $DEFAULT_BLZ_IMAGE
	fi

	export BLZ_IMAGE=$DEFAULT_BLZ_IMAGE

	echo "building image : $DEFAULT_BLZ_IMAGE "

	docker build -t $BLZ_IMAGE Docker

fi

