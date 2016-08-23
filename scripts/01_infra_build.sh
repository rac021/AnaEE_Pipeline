#!/bin/bash

if [ $# -eq 1 ] ; then

    EXIT() {
    parent_script=`ps -ocommand= -p $PPID | awk -F/ '{print $NF}' | awk '{print $1}'`
        if [ $parent_script = "bash" ] ; then
          exit 2
        else
          kill -9 `ps --pid $$ -oppid=`;
          exit 2
        fi
    }
  
    removeAllContainerBasedOnImage() {
        IMAGE=$1
        echo
        echo -e " Remove all containers based on images  $IMAGE "
        docker ps -a | awk '{ print $1,$2 }' | grep $IMAGE | awk '{print $1 }' | xargs -I {} docker rm -f {}
        echo -e " All containers removed !! "
        echo
    } 
    
    # Docker Image
    DOCKER_BLZ_IMAGE=$1

    tput setaf 2
    echo 
    echo -e " ################################# "
    echo -e " ######### Build Infra ########### "
    echo -e " --------------------------------- "
    echo -e " \e[90m$0        \e[32m            "
    echo
    echo -e " ##  BLZ_IMAGE : $DOCKER_BLZ_IMAGE "
    echo
    echo -e " ################################# "
    echo 
    sleep 2
    tput setaf 7
	
    CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    DOCKER_FILE_PATH="$CURRENT_PATH/Docker"
	
    if [ ! -e $DOCKER_FILE_PATH ]; then
        echo " $CURRENT_PATH Not found !! Has Project cloned from Git ? "
        EXIT
    fi
	
    if docker history -q $DOCKER_BLZ_IMAGE >/dev/null 2>&1 ; then
	
	HOSTS_FILE="$CURRENT_PATH/conf/hosts"
        NANO_END_POINT_FILE="$CURRENT_PATH/conf/nanoEndpoint"
        
	removeAllContainerBasedOnImage $DOCKER_BLZ_IMAGE
                    
        > $NANO_END_POINT_FILE
        > $HOSTS_FILE
	
        # Remove Image $DOCKER_BLZ_IMAGE if exists 
        echo " Remove Image  $DOCKER_BLZ_IMAGE ... "
        docker rmi -f $DOCKER_BLZ_IMAGE
        echo " Images removed !! "
        echo
    else 
       echo " No image found.. "
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

