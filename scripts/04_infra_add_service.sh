#!/bin/bash

# Note :
# Do not touch HOST_NAME
# Docker version min : 1.10 
# $1 blazegraph nameSpace 
# $2 NameSpace
# $3 PORT Number
# $4 RW Mode

   if [ $# -eq 6 ] ; then

        # Get Image Docker Name
        BLZ_IMAGE=$1
        CONTAINER_NAME=$2
        IP=$3
        # Get Port Number
        PORT=$4
        # Get NameSpace
        NAMESPACE=$5
        # Get Default Mode : 
        # 'rw' for read-write Mode
        # 'ro' for readOnly Mode. 
        DEFAULT_MODE=$6
        
        # Default interface
        SUBNET="mynet123"

        LOOP=" while true; do sleep 1000; done "
      
        isFreePort() {
          PORT=$1
          if ! lsof -i:$PORT > /dev/null
          then
            isFree="true"
          else
            echo
            echo -e " Port $PORT is in use, please release it to continue "
            echo
            exit 3
          fi
        }
        
        if [ "$DEFAULT_MODE" != "ro" ] && [ "$DEFAULT_MODE" != "rw" ] ; then 
        echo "DEFAULT_MODE can only have 'rw' OR 'ro' values !!"
        exit 2
        fi 

        if docker history -q $BLZ_IMAGE >/dev/null 2>&1; then

            CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
            
            STATUS_FILE="$CURRENT_PATH/conf/status"
            
            STATUS=`cat $STATUS_FILE `
            
            if [ $STATUS = "0" ] ; then
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
            echo -e " ######################################### "
            echo -e " ############ Attach Info ################ "
            echo -e " ----------------------------------------- "
            echo -e " \e[90m$0              \e[32m              "
            echo 
            echo -e " ##  SUBNET          : $SUBNET             "
            echo
            echo -e " ##  BLZ_IMAGE       : $BLZ_IMAGE          "
            echo -e " ##  BN_CONTAINERNBR : $CONTAINER_NAME     "
            echo -e " ##  START_IP        : $IP                 "
            echo -e " ##  PORT            : $PORT               "
            echo -e " ##  NAMESPACE       : $NAMESPACE          "
            echo -e " ##  MODE            : $DEFAULT_MODE       "
            echo
            echo -e " ######################################### "
            echo 
            sleep 1
            tput setaf 7

            # CLEAN NANO ENDPOINT FILE
            
            HOSTS_FILE="$CURRENT_PATH/conf/hosts"
            NANO_END_POINT_FILE="$CURRENT_PATH/conf/nanoEndpoint"
             
            EXIST=$(docker inspect --format="{{ .Name }}" $CONTAINER_NAME 2> /dev/null)
            if [ ! -z $EXIST ]; then 
              echo
              echo " Container  $CONTAINER_NAME  already exists, remove... "
              docker  rm  -f    $CONTAINER_NAME > /dev/null
              echo " Container  $CONTAINER_NAME  removed !! "
            fi
            
            echo 
           
            isFreePort $PORT
               
            docker run  -d                                                                  \
                        --net  $SUBNET                                                      \
                        --name $CONTAINER_NAME                                              \
                        --ip   $IP                                                          \
                        -p     $PORT:$PORT                                                  \
                        --memory-swappiness=0                                               \
                        --entrypoint /bin/bash -it $BLZ_IMAGE                               \
                        -c " ./nanoSparqlServer.sh $PORT $NAMESPACE $DEFAULT_MODE ; $LOOP " > /dev/null
                
            echo "$CONTAINER_NAME:$IP:$PORT:$NAMESPACE:$DEFAULT_MODE" >> $NANO_END_POINT_FILE
            echo -e "\e[39m serviceURL: \e[93mhttp://$IP:$PORT  -  Published port : $PORT \e[39m"
              
            echo " ---------------------------------------------------------------- "
            echo
            echo -e " Joining cluster... ~ 10 s "
            echo 
            
            ENDPOINT="http://$IP:$PORT/bigdata/namespace/$NAMESPACE/sparql"
            RES=`curl -s -I $ENDPOINT | grep HTTP/1.1 | awk {'print $2'}`
            
            COUNT=0
        
            while [ -z $RES ] || [ $RES -ne 200 ] ;do
        
               sleep 1
               RES=`curl -s -I $ENDPOINT | grep HTTP/1.1 | awk {'print $2'}`
               let "COUNT++" 
           
               if  [ -z $RES ] || [ $RES != 200 ] ; then 
                  if [ `expr $COUNT % 3` -eq 0 ] ; then
                     echo -e " \e[90m -> attempt to join cluster on namespace $NAMESPACE .. \e[39m"
                  fi
               fi
           
            done
            echo
            echo " Yeah Connected !! "
            echo
            
        else
           echo
           echo -e "\e[91m Image '$BLZ_IMAGE' not found !! \e[39m "
           echo 
        fi
    
   else
        echo
        echo " Invalid arguments :  Please pass exactly Six arguments   "
        echo " arg_1             :  Image_docker_name                   "
        echo " arg_2             :  Container Name                      "
        echo " arg_3             :  IP                                  "
        echo " arg_4             :  Port                                "
        echo " arg_5             :  NameSpace                           "
        echo " arg_6             :  READ-WRITE MODE ( ro : rw   )       "   
        echo
   fi
