#!/bin/bash

    EXIT() {
      parent_script=`ps -ocommand= -p $PPID | awk -F/ '{print $NF}' | awk '{print $1}'`
      if [ $parent_script = "bash" ] ; then
          exit 2
      else
          kill -9 `ps --pid $$ -oppid=`;
          exit 2
      fi
    }
  
    CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    cd $CURRENT_PATH
    HOSTS_FILE="$CURRENT_PATH/conf/hosts"
    STATUS_FILE="$CURRENT_PATH/conf/status"
    NANO_END_POINT_FILE="$CURRENT_PATH/conf/nanoEndpoint"
    
    if [ ! -f $STATUS_FILE ] ; then
      echo
      echo " File : $STATUS_FILE not found ! "
      echo
      EXIT
    fi
    
    if [ ! -f $HOSTS_FILE ] ; then
      echo
      echo " File : $HOSTS_FILE not found ! "
      echo
      EXIT
    fi
    
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
    echo
    echo " ----------------------- "
    echo " Cluster Hosts Name      "
    echo " ----------------------- "
    
    for node in $(cat $HOSTS_FILE)  
    do
      tput setaf 6
      sleep 0.4
      echo
      echo "  -> Node : $node "
      echo
      tput setaf 7
    done 
    
    echo
    echo " ----------------------- "
    echo " Cluster Clients Name    "
    echo " ----------------------- "
    
    tput setaf 6
    
    for LINE in `cat $NANO_END_POINT_FILE`; do
            
      IFS=’:’ read -ra INFO_NANO <<< "$LINE" 
      NANO_END_POINT_HOST=${INFO_NANO[0]}
      NANO_END_POINT_IP=${INFO_NANO[1]}
      NANO_END_POINT_PORT=${INFO_NANO[2]}
      NAME_SPACE=${INFO_NANO[3]}
      RW_MODE=${INFO_NANO[4]}
    
      echo
      echo "  -> $NANO_END_POINT_HOST ** $NANO_END_POINT_IP ** $NANO_END_POINT_PORT ** $NAME_SPACE ** $RW_MODE"     
      sleep 0.4
      echo
    
    done
    
    echo
    
    tput setaf 7       
    
