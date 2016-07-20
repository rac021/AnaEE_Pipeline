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
  
  checkIfContainersAreRunning() {
     
     for LINE in `cat $1`; do
     
       IFS=’:’ read -ra INFO_NANO <<< "$LINE" 
       CONTAINER=${INFO_NANO[0]}
       RUNNING=$(docker inspect --format="{{ .State.Running }}" $CONTAINER 2> /dev/null)
            
       if [ $? -eq 1 ]; then   
         echo
         echo -e "\e[91m UNKNOWN - Container $CONTAINER does not exist. \e[37m "
         echo
         EXIT
       fi

       if [ "$RUNNING" == "false" ]; then
         echo
         echo -e "\e[91m CRITICAL - Container $CONTAINER is not running. \e[37m "
         echo
         EXIT
       fi
     done
  } 
      
  CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  HOSTS_FILE="$CURRENT_PATH/conf/hosts"
    
  checkIfContainersAreRunning $HOSTS_FILE 
  
  FIRST_HOST=$(head -n 1 $HOSTS_FILE )
   
  docker exec -it $FIRST_HOST ./listServices.sh 
  
  
