#!/bin/bash

    CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    CONFIG_FILE_PATH="$CURRENT_PATH/conf/hosts"
      
    STATUS_FILE_PATH="$CURRENT_PATH/conf/status"
     
    NANO_END_POINT_FILE="$CURRENT_PATH/conf/nanoEndpoint"
    
    NANO_END_POINT_HOST=`cat $NANO_END_POINT_FILE `
    
    
    if [ "$1" = "start" ] ; then 
       
        tput setaf 2
        echo 
        echo "##################################### "
        echo "######## Starting Cluster ########### "
        echo "------------------------------------- "
        tput setaf 7
        sleep 2
      
        echo -e " \e[90m Cluster List ** "
        echo -e " \e[90m $CONFIG_FILE_PATH "
        echo
        
        for node in $(cat $CONFIG_FILE_PATH)  
        
        do  
            
            tput setaf 6
            echo " -> Starting Bigdata on Node $node "
            sleep 2
            tput setaf 7
            docker exec -d $node ./bigdata start
            echo
            sleep 4
        
        done 
        
        tput setaf 2
        echo 
        echo " => Running nanoSparqlServer  ~ 10 s   "
        tput setaf 7

        echo -e "  \e[90m nanoEndpoint List ** "
        echo -e "  \e[90m $NANO_END_POINT_FILE "
        echo    
        tput setaf 7
        sleep 10
        docker exec $NANO_END_POINT_HOST ./nanoSparqlServer.sh 9999 ola rw &
        
        echo "1" > $STATUS_FILE_PATH
        
    fi


    if [ "$1" = "stop" ] ; then 

        tput setaf 2
        echo 
        echo "##################################### "
        echo "######## Stopping Cluster ########### "
        echo "------------------------------------- "
        tput setaf 7
        sleep 2
        
        echo -e " \e[90m Cluster List ** "
        echo -e " \e[90m $CONFIG_FILE_PATH "
        
        for node in $(cat $CONFIG_FILE_PATH)  
        do  
        
            tput setaf 6
            echo 
            echo " -> Stopping Node $node "
            tput setaf 7
            
            docker exec -d $node  /bin/sh -c "./bigdata stop "
            sleep 3
        
        done
        
        echo "0" > $STATUS_FILE_PATH
        
        echo
    fi
