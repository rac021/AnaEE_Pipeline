#!/bin/bash

if [ $# -eq 1 ] ; then

    removeContainerIfExists() {
       CONTAINER=$1
       EXIST=$(docker inspect --format="{{ .Name }}" $CONTAINER 2> /dev/null)
       if [ ! -z $EXIST ]; then 
          echo
          echo " Container $CONTAINER  already exists, remove... "
          docker  rm  -f   $CONTAINER > /dev/null
          echo " Container $CONTAINER  removed !! "
          CLEANED=true
       fi
    } 
    
    # Docker Image
    DOCKER_BLZ_IMAGE=$1

    # Hosts Names 
    HOST_0="blz_host_0"
    HOST_1="blz_host_1"
    HOST_2="blz_host_2"
 
    HOSTS=( $HOST_0 $HOST_1 $HOST_2 )
 	
    tput setaf 2
    echo 
    echo -e " ################################# "
    echo -e " ######### Build Infra ########### "
    echo -e " --------------------------------- "
    echo -e " \e[90m$0        \e[32m            "
    echo
    echo -e " ##  BLZ_IMAGE : $DOCKER_BLZ_IMAGE "
    echo -e " ##  HOST_0    : $HOST_0           "
    echo -e " ##  HOST_1    : $HOST_1           "
    echo -e " ##  HOST_2    : $HOST_2           "
    echo
    echo -e " ################################# "
    echo 
    sleep 2
    tput setaf 7
	
    CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    DOCKER_FILE_PATH="$CURRENT_PATH/Docker"
	
    if [ ! -e $DOCKER_FILE_PATH ]; then
        echo " $CURRENT_PATH Not found !! Has Project cloned from Git ? "
        exit 2 
    fi
	
    if docker history -q $DOCKER_BLZ_IMAGE >/dev/null 2>&1 ; then
	
        # CLEAN NANO ENDPOINT FILE
        HOSTS_FILE="$CURRENT_PATH/conf/hosts"
        NANO_END_POINT_FILE="$CURRENT_PATH/conf/nanoEndpoint"
        CLEANED=false
	            
        echo -e " \e[90m Cleaning existing Clients in :\e[39m "
        echo -e " \e[90m $NANO_END_POINT_FILE \e[39m "
        
        if [ -f $NANO_END_POINT_FILE ]; then
        
          for LINE in `cat $NANO_END_POINT_FILE`; do
                      
            IFS=’:’ read -ra INFO_NANO <<< "$LINE" 
            NANO_END_POINT_HOST=${INFO_NANO[0]}
            NANO_END_POINT_IP=${INFO_NANO[1]}
            NANO_END_POINT_PORT=${INFO_NANO[2]}
            NAME_SPACE=${INFO_NANO[3]}
	   
	    removeContainerIfExists $NANO_END_POINT_HOST
         
          done
          
	fi
	            
        > $NANO_END_POINT_FILE
            
        if [ "$CLEANED" = true ] ; then
            echo -e " Cleanded ! "
        else
            echo -e " No existing EndPoint "
        fi
        echo
	
	if [ -f $HOSTS_FILE ] ; then
          for HOST in ${HOSTS[@]}
	  do
	    removeContainerIfExists $HOST
	  done 
	fi
	
	> $HOSTS_FILE
	
        # Remove Image $DOCKER_BLZ_IMAGE if exists 
        echo " Image  $DOCKER_BLZ_IMAGE already exist, remove it... "
        # CONTAINER_ID=`docker images -q $DOCKER_BLZ_IMAGE `
        # echo " Conainer ID : $CONTAINER_ID "
        #docker rmi -f $CONTAINER_ID
        docker rmi -f $DOCKER_BLZ_IMAGE
        
    fi
		
    tput setaf 2
    echo "                                              "
    echo " ############################################ "
    echo " ### Building Image : $DOCKER_BLZ_IMAGE   ### "
    echo " ############################################ "
    echo "                                              "
    sleep 2
    tput setaf 7
	  
    docker build -t $DOCKER_BLZ_IMAGE $DOCKER_FILE_PATH
	
else
    echo " Invalid arguments :  please pass exactly One argument "
    echo " arg_1             :  Image_Docker_Name                "
    
fi

