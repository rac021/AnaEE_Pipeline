#!/bin/bash
      
    CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    HOSTS_FILE="$CURRENT_PATH/conf/hosts"
    STATUS_FILE="$CURRENT_PATH/conf/status"
    NANO_END_POINT_FILE="$CURRENT_PATH/conf/nanoEndpoint"
       
    STATUS=`cat $STATUS_FILE `
    
    if [ $STATUS == 1 ]; then 
     STAT_SHOW="ON"
    else
     STAT_SHOW="OFF"
    fi
    
    tput setaf 2
    echo 
    echo " ######################################## "
    echo " ########## List Config ################# "
    echo " ---------------------------------------- "
    echo -e " \e[90m$0 \e[32m                       "
    tput setaf 7
    sleep 1
    echo
    echo -e " CLUSTER STATUS :  \e[42m \e[30m $STAT_SHOW \e[39m \e[49m  "
    echo
    echo " ************************ "
    echo " -- CLuster Hosts Name  "
    echo " -----------------------------------------"
    for node in $(cat $HOSTS_FILE)  
    do
      tput setaf 6
      sleep 0.4
      echo
      echo " Node : $node "
      echo
      tput setaf 7
    done 
    echo
    echo " ************************ "
    echo " -- CLuster Clients Name "
    echo " -----------------------------------------"
    
    tput setaf 6
    
    for LINE in `cat $NANO_END_POINT_FILE`; do
            
      IFS=’:’ read -ra INFO_NANO <<< "$LINE" 
      NANO_END_POINT_HOST=${INFO_NANO[0]}
      NANO_END_POINT_IP=${INFO_NANO[1]}
      NANO_END_POINT_PORT=${INFO_NANO[2]}
      NAME_SPACE=${INFO_NANO[3]}
      RW_MODE=${INFO_NANO[4]}
      echo
      echo " $NANO_END_POINT_HOST ** $NANO_END_POINT_IP ** $NANO_END_POINT_PORT ** $NAME_SPACE ** $RW_MODE"     
      sleep 0.4
      echo
    done
    
    tput setaf 7       
    
