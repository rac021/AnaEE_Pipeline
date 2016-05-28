#!/bin/bash

if [ $# -eq 1 ] ; then

	# Docker Image
	DOCKER_BLZ_IMAGE=$1

	# Hosts Names 
	HOST_0="blz_host_0"
	HOST_1="blz_host_1"
	HOST_2="blz_host_2"

	tput setaf 2
	echo 
	echo "################################# "
	echo "######### Build Infra ########### "
	echo "--------------------------------- "
	echo
	echo "##  Script    : $0                "
	echo
	echo "##  BLZ_IMAGE : $DOCKER_BLZ_IMAGE "
	echo "##  HOST_0    : $HOST_0           "
	echo "##  HOST_1    : $HOST_1           "
	echo "##  HOST_2    : $HOST_2           "
	echo
	echo "################################# "
	echo 
	sleep 2
	tput setaf 7
	
	CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

	DOCKER_FILE_PATH="$CURRENT_PATH/Docker"
	
	if [ ! -e $DOCKER_FILE_PATH ]; then
	
	    echo "$CURRENT_PATH Not found !! Has Project cloned from Git ? "
	
	else
		if docker history -q $DOCKER_BLZ_IMAGE >/dev/null 2>&1 ; then
	
	            EXIST=`docker inspect --format='{{.Name}}' $( docker ps -aq --no-trunc) | grep $HOST_0`
	            # Remove $HOST_0 if exists 
		    if [ ! -z $EXIST ]; then 
		      echo "Container $HOST_0 already exists, remove..."
		      docker rm -f $HOST_0
		      echo "Container $HOST_0 removed !!"
		    fi
		    
	            EXIST=`docker inspect --format='{{.Name}}' $( docker ps -aq --no-trunc) | grep $HOST_1`
	            # Remove $HOST_1 if exists 	            
		    if [ ! -z $EXIST ]; then 
		      echo "Container $HOST_1 already exists, remove..."	    
		      docker rm -f $HOST_1
		      echo "Container $HOST_1 removed !!"	      
		    fi
		    
	            EXIST=`docker inspect --format='{{.Name}}' $( docker ps -aq --no-trunc) | grep $HOST_2`
	            # Remove $HOST_2 if exists 	            
		    if [ ! -z $EXIST ]; then 
		      echo "Container $HOST_2 already exists, remove..."
		      docker rm -f $HOST_2
		      echo "Container $HOST_2 removed !!"
		    fi
		    
		    # Remove Image $DOCKER_BLZ_IMAGE if exists 
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
    echo " Invalid arguments :  please pass exactly One argument "
    echo " arg_1             :  Image_Docker_Name                "
    
fi

