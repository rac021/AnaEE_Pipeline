#!/bin/bash

if [ $# -eq 4 ] ; then

	# Docker Image
	DOCKER_BLZ_IMAGE=$1

	# Hosts Names 
	HOST_0=$2
	HOST_1=$3
	HOST_2=$4
	
	CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

	DOCKER_FILE_PATH="$CURRENT_PATH/Docker"
	
	if [ ! -e $DOCKER_FILE_PATH ]; then
	
	    echo "$CURRENT_PATH Not found !! Has Project cloned from Git ? "
	
	else
		if docker history -q $DOCKER_BLZ_IMAGE >/dev/null 2>&1 ; then
	
	            EXIST=`docker inspect --format='{{.Name}}' $(sudo docker ps -aq --no-trunc) | grep $HOST_0`
	            # Remove $HOST_0 if exists 
		    if [ ! -z $EXIST ]; then 
		      echo "Container $HOST_0 already exists, remove..."
		      docker rm -f $HOST_0
		      echo "Container $HOST_0 removed !!"
		    fi
		    
	            EXIST=`docker inspect --format='{{.Name}}' $(sudo docker ps -aq --no-trunc) | grep $HOST_1`
	            # Remove $HOST_1 if exists 	            
		    if [ ! -z $EXIST ]; then 
		      echo "Container $HOST_1 already exists, remove..."	    
		      docker rm -f $HOST_1
		      echo "Container $HOST_1 removed !!"	      
		    fi
		    
	            EXIST=`docker inspect --format='{{.Name}}' $(sudo docker ps -aq --no-trunc) | grep $HOST_2`
	            # Remove $HOST_2 if exists 	            
		    if [ ! -z $EXIST ]; then 
		      echo "Container $HOST_2 already exists, remove..."
		      docker rm -f $HOST_2
		      echo "Container $HOST_2 removed !!"
	
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
    echo " Invalid arguments :  please pass exactly Four arguments "
    echo " arg_1             :  Image_Docker_Name                  "
    echo " arg_2             :  Container Name One                 "
    echo " arg_3             :  Container Name Two                 "
    echo " arg_4             :  Container Name Three               "
    
fi

