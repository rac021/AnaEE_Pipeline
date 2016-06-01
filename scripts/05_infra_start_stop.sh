#!/bin/bash
   
    checkIfContainersAreRunning() {
     
     for LINE in `cat $1`; do
     
       IFS=’:’ read -ra INFO_NANO <<< "$LINE" 
       CONTAINER=${INFO_NANO[0]}
       RUNNING=$(docker inspect --format="{{ .State.Running }}" $CONTAINER 2> /dev/null)
            
       if [ $? -eq 1 ]; then        
         echo -e "\e[91m UNKNOWN - Container $CONTAINER does not exist. \e[37m "
         echo
         exit 3
       fi

       if [ "$RUNNING" == "false" ]; then
         echo -e "\e[91m CRITICAL - Container $CONTAINER is not running. \e[37m "
         echo
         exit 2
       fi
     done
    } 
      
    CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    HOSTS_FILE="$CURRENT_PATH/conf/hosts"
    STATUS_FILE="$CURRENT_PATH/conf/status"
    NANO_END_POINT_FILE="$CURRENT_PATH/conf/nanoEndpoint"
    
    if [ "$1" = "start" ] ; then 
       
        STATUS=`cat $STATUS_FILE `
        
        if [ $STATUS = "1" ] ; then
          tput setaf 6
          echo
          echo " Cluster should be running ... ? "
          echo " if you are sure that the Cluster is DOWN, you can turn STATUS in the "
          echo " file $STATUS_FILE "
          echo " to 0 to and then try to retstart it "
          echo " or just STOP and START Cluster "
          echo
          tput setaf 7
          exit 3
        fi
        
        tput setaf 2
        echo 
        echo " ##################################### "
        echo " ######## Starting Cluster ########### "
        echo " ------------------------------------- "
        echo -e " \e[90m$0                   \e[32m  "
        tput setaf 7
        sleep 2
        echo
        echo -e " \e[37m** Cluster List "
        echo -e "   \e[90m $HOSTS_FILE "
        echo -e " \e[37m** NanoEndpoint List  "
        echo -e "   \e[90m $NANO_END_POINT_FILE "
        echo

        checkIfContainersAreRunning $HOSTS_FILE  
        checkIfContainersAreRunning $NANO_END_POINT_FILE 
        
        for node in $(cat $HOSTS_FILE)  
        do
          tput setaf 6
          echo " -> Starting Bigdata on Node $node "
          sleep 1
          tput setaf 7
          docker exec -d $node ./bigdata start
          echo
          sleep 3
        done 
            
        tput setaf 2
        echo 
        echo " => wait for Cluster ~ 10 s   "
        tput setaf 7

        echo    
        tput setaf 7
        sleep 10

        for LINE in `cat $NANO_END_POINT_FILE`; do
            
          IFS=’:’ read -ra INFO_NANO <<< "$LINE" 
          NANO_END_POINT_HOST=${INFO_NANO[0]}
          NANO_END_POINT_IP=${INFO_NANO[1]}
          NANO_END_POINT_PORT=${INFO_NANO[2]}
          NAME_SPACE=${INFO_NANO[3]}
          RW_MODE=${INFO_NANO[4]}
            
          docker exec -dit $NANO_END_POINT_HOST ./nanoSparqlServer.sh $NANO_END_POINT_PORT $NAME_SPACE $RW_MODE
          echo -e "\e[37m serviceURL: \e[93mhttp://$NANO_END_POINT_IP:$NANO_END_POINT_PORT"
          sleep 1
          #IP=`docker inspect --format '{{ .NetworkSettings.Networks.mynet123.IPAddress }}' blz_host_2`
          # docker logs -f $NANO_END_POINT_HOST
         
        done
        sleep 2
        echo "1" > $STATUS_FILE
        echo  -e " \e[97m "
            
    elif [ "$1" = "stop" ] ; then 

      tput setaf 2
      echo 
      echo "##################################### "
      echo "######## Stopping Cluster ########### "
      echo "------------------------------------- "
      echo -e " \e[90m$0                  \e[32m  "
      tput setaf 7
      sleep 2
        
      echo -e " \e[90m Cluster List ** "
      echo -e " \e[90m $HOSTS_FILE "
        
      for CONTAINER in $(cat $HOSTS_FILE)  
      do
        tput setaf 6
        echo 
        echo " -> Stopping Node $CONTAINER "
        tput setaf 7
       
        RUNNING=$(docker inspect --format="{{ .State.Running }}" $CONTAINER 2> /dev/null)
                    
        if [ $? -eq 1 ]; then        
           echo -e "\e[91m UNKNOWN - Container $CONTAINER does not exist. \e[37m "
               
        elif [ "$RUNNING" == "false" ]; then
           echo -e "\e[91m CRITICAL - Container $CONTAINER is not running. \e[37m "
                 
        elif [ "$RUNNING" == "true" ]; then
           docker exec -dit $CONTAINER  /bin/sh -c "./bigdata stop "
            
        fi            
            
        sleep 3
        
      done
        
      for CONTAINER in $(cat $NANO_END_POINT_FILE ) ; do
        
         IFS=’:’ read -ra INFO_NANO <<< "$CONTAINER" 
       	 H_CONTAINER=${INFO_NANO[0]}
       	    
         tput setaf 6
         echo 
         echo " -> Stopping Node $H_CONTAINER "
         tput setaf 7
       
         RUNNING=$(docker inspect --format="{{ .State.Running }}" $H_CONTAINER 2> /dev/null)
                   
         if [ $? -eq 1 ]; then        
            echo -e "\e[91m UNKNOWN - Container $H_CONTAINER does not exist. \e[37m "
                
         elif [ "$RUNNING" == "false" ]; then
            echo -e "\e[91m CRITICAL - Container $H_CONTAINER is not running. \e[37m "
                 
         elif [ "$RUNNING" == "true" ]; then
            docker exec -dit $H_CONTAINER  /bin/sh -c "./bigdata stop "
         fi            
            
         sleep 3
      done
        
      echo "0" > $STATUS_FILE
      echo  -e " \e[97m "
        
    else
        echo " Invalid arguments :  Please pass One or One argument  "
        echo " arg_1             :  start - stop                     "
   
    fi
    

  
