#!/bin/bash

# Note :
# Do not touch HOST_NAME
# Docker version min : 1.10 
# $1 BLZ_IMAGE 
# $2 CONTAINER_NAME
# $3 IP
# $4 NAMESPACE
# $5 PORT Number
# $6 DEFAULT_MODE
# $7 SUBNET
# $8 TRAEFIK_BACKEND
# $9 TRAEFIK_FRONTEND_RULE

   if [ $# -ge 6 ] ; then

        # Get Image Docker Name
        BLZ_IMAGE=$1
         # Get Container Name
        CONTAINER_NAME=$2
        IP=$3
        # Get NameSpace
        NAMESPACE=$4
         # Get Port Number
        PORT=$5
        # Get Default Mode : 
        # 'rw' for read-write Mode
        # 'ro' for readOnly Mode. 
        DEFAULT_MODE=$6
        
        # Default interface mynet123
        SUBNET=${7:-"mynet123"} 

        TRAEFIK_BACKEND=${8:-"client_blz_backend"} 
        TRAEFIK_FRONTEND_RULE=${9:-"Host:client.blz.localhost"}
        
        LOOP=" while true; do sleep 1000; done "
      
        EXIT() {
         parent_script=`ps -ocommand= -p $PPID | awk -F/ '{print $NF}' | awk '{print $1}'`
         if [ $parent_script = "bash" ] ; then
             echo; echo -e " \e[90m exited by : $0 \e[39m " ; echo
             exit 2
         else
             echo ; echo -e " \e[90m exited by : $0 \e[39m " ; echo
             kill -9 `ps --pid $$ -oppid=`;
             exit 2
         fi
        }
  
        isFreePort() {
          PORT=$1
          if ! lsof -i:$PORT > /dev/null
          then
            isFree="true"
          else
            echo
            echo -e " Port $PORT is in use, please release it to continue "
            EXIT
          fi
        }
        
        if [ "$DEFAULT_MODE" != "ro" ] && [ "$DEFAULT_MODE" != "rw" ] ; then 
            echo "DEFAULT_MODE can only have 'rw' OR 'ro' values !!"
            EXIT
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
               EXIT
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
               
            RUNNING=$( docker run  -d                                                    \
                       -l traefik.backend=$TRAEFIK_BACKEND                               \
                       -l traefik.frontend.rule=$TRAEFIK_FRONTEND_RULE                   \
                       --net  $SUBNET                                                    \
                       --name $CONTAINER_NAME                                            \
                       --ip   $IP                                                        \
                       -p     $PORT:$PORT                                                \
                       --memory-swappiness=0                                             \
                       --entrypoint /bin/bash -it $BLZ_IMAGE                             \
                       -c " ./nanoSparqlServer.sh $PORT $NAMESPACE $DEFAULT_MODE ; $LOOP " 2>&1 )
            
            if [[ "$RUNNING" =~ "Error" ]] ; then
               echo
               echo "$RUNNING"
               EXIT
            fi    
                
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
        echo " Invalid arguments :  Please pass at least Six arguments                            "
        echo " arg_1             :  Image_docker_name                                             "
        echo " arg_2             :  Container Name                                                "
        echo " arg_3             :  IP                                                            "
        echo " arg_4             :  NameSpace                                                     "
        echo " arg_5             :  Port                                                          "
        echo " arg_6             :  READ-WRITE MODE ( ro : rw   )                                 "
        echo " Optionnal         :                                                                "
        echo " arg_7             :  Interface ( Default : mynet123 )                              "
        echo " arg_8             :  TRAEFIK_BACKEND ( Default : client_blz_backend )              "
        echo " arg_9             :  TRAEFIK_FRONTEND_RULE ( Default : Host:client.blz.localhost ) "
        echo
   fi
