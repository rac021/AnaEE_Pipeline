#!/bin/bash

# Note :
# Do not touch HOST_NAME
# Docker version min : 1.10 
# $1  Image_docker_name  / or / clearAll
# $2  Base name Container 
# $3  PStart IP
# $4  Number Instances
# $5  NameSpace
# $6  Port
# $7  READ-WRITE MODE : ro - rw
# $8  Interface ( Default : mynet123 )
# $9  TRAEFIK_BACKEND ( Default : client_blz_backend ) 
# $10 TRAEFIK_FRONTEND_RULE ( Default : Host:client.blz.localhost )

   CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
   
   HOSTS_FILE="$CURRENT_PATH/conf/hosts"
   NANO_END_POINT_FILE="$CURRENT_PATH/conf/nanoEndpoint"
   
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
   
   DISPLAY_MESSAGE() {
      echo
      echo " Invalid arguments :  Please pass exactly One or at least Seven arguments           "
      echo " arg_1             :  Image_docker_name  / or / clearAll                            "
      echo " arg_2             :  Base name Container                                           "
      echo " arg_3             :  Start IP                                                      "
      echo " arg_4             :  Number Instances                                              "
      echo " arg_5             :  NameSpace                                                     "
      echo " arg_6             :  Port                                                          "
      echo " arg_7             :  READ-WRITE MODE ( ro : rw   )                                 " 
      echo " Optionnal         :                                                                "
      echo " arg_8             :  Interface ( Default : mynet123 )                              " 
      echo " arg_9             :  TRAEFIK_BACKEND ( Default : client_blz_backend )              " 
      echo " arg_10            :  TRAEFIK_FRONTEND_RULE ( Default : Host:client.blz.localhost ) " 
      echo 
   }   
   
   
   if [ $# -ge 7 ] ; then

        # Get Image Docker Name
        BLZ_IMAGE=$1
        BNAME_CONTAINER=$2
        START_IP=$3
        NUMBER_INSTANCE=$4
        # Get NameSpace
        NAMESPACE=$5
        # Get Port Number
        PORT=$6
        # Get Default Mode : 
        # 'rw' for read-write Mode
        # 'ro' for readOnly Mode. 
        DEFAULT_MODE=$7

        # Default interface mynet123
        SUBNET=${8:-"mynet123"} 
       
        TRAEFIK_BACKEND=${9:-"client_blz_backend"} 
        TRAEFIK_FRONTEND_RULE=${10:-"Host:client.blz.localhost"}
        
        LOOP=" while true; do sleep 1000; done "
       
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
            echo -e " ############ Attach Service ############# "
            echo -e " ----------------------------------------- "
            echo -e " \e[90m$0              \e[32m              "
            echo 
            echo -e " ##  SUBNET          : $SUBNET             "
            echo
            echo -e " ##  BLZ_IMAGE       : $BLZ_IMAGE          "
            echo -e " ##  BN_CONTAINER    : $BNAME_CONTAINER    "
            echo -e " ##  START_IP        : $START_IP           "
            echo -e " ##  PORT            : $PORT               "
            echo -e " ##  NBR_INSTANCE    : $NUMBER_INSTANCE    "
            echo -e " ##  NAMESPACE       : $NAMESPACE          "
            echo -e " ##                  : $DEFAULT_MODE       "
            echo
            echo -e " ######################################### "
            echo 
            sleep 1
            tput setaf 7

            # PROCESS IP  
            IFS=’.’ read -ra S_IP <<< "$START_IP" 
            i1=${S_IP[0]} ; i2=${S_IP[1]} ; i3=${S_IP[2]}; i4=${S_IP[3]}
            
            HOST_PORT=$PORT
            
            let END=$i4+$NUMBER_INSTANCE
            
            for (( n=$i4; n<$END ; n++ )) ; do
                
                IP=$i1"."$i2"."$i3"."$i4
            
                NAME_INSTANCE=$BNAME_CONTAINER"_"$IP"_blz"
                
                EXIST=$(docker inspect --format="{{ .Name }}" $NAME_INSTANCE 2> /dev/null)
                if [ ! -z $EXIST ]; then 
                  echo " Container  $NAME_INSTANCE already exists, remove..."
                  docker  rm  -f  $NAME_INSTANCE > /dev/null
                  echo " Container  $NAME_INSTANCE removed !!"
                fi

                fuser -k $HOST_PORT/tcp 
                isFreePort $HOST_PORT
                
                RUNNING=$( docker run  -d                                                      \
                           -l traefik.backend=$TRAEFIK_BACKEND                                 \
                           -l traefik.frontend.rule=$TRAEFIK_FRONTEND_RULE                     \
                           --net  $SUBNET                                                      \
                           --name $NAME_INSTANCE                                               \
                           --ip   $IP                                                          \
                           -p     $HOST_PORT:$PORT                                             \
                           --memory-swappiness=0                                               \
                           --entrypoint /bin/bash -it $BLZ_IMAGE                               \
                           -c " ./nanoSparqlServer.sh $PORT $NAMESPACE $DEFAULT_MODE ; $LOOP "  2>&1 )
               
                if [[ "$RUNNING" =~ "Error" ]]; then
                   echo
                   echo "$RUNNING"
                   EXIT
                fi
                
                echo "$NAME_INSTANCE:$IP:$PORT:$NAMESPACE:$DEFAULT_MODE" >> $NANO_END_POINT_FILE
                echo -e "\e[39m serviceURL: \e[93mhttp://$IP:$PORT  -  Published port : $HOST_PORT \e[39m"
                
                let "HOST_PORT++"
                let "i4++"
                
                if [ $i4 -eq "255" ] ; then
                i4=0
                let "i3++"
                fi
                
                echo " ---------------------------------------------------------------- "
                
            done
            echo
            echo -e "\e[94m Joining cluster... ~ 10 s \e[39m "
            sleep 8
            echo -e "\e[33m Cluster joined \e[39m "
            echo
            
        else
           echo " Image '$BLZ_IMAGE' not found !! "
           echo 
        fi
   
   elif [ $# -eq 1 ] ; then 

      if [ "$1" != "clearAll" ] ; then 
      
           DISPLAY_MESSAGE
           EXIT
      fi 

      # CLEAN NANO ENDPOINT FILE
      CLEANED=false
      echo      
      echo -e "\e[90m Cleaning existing Clients in :\e[39m "
      echo -e "\e[90m $NANO_END_POINT_FILE \e[39m "
             
      for LINE in `cat $NANO_END_POINT_FILE`; do
                        
          IFS=’:’ read -ra INFO_NANO <<< "$LINE" 
          NANO_END_POINT_HOST=${INFO_NANO[0]}
          NANO_END_POINT_IP=${INFO_NANO[1]}
          NANO_END_POINT_PORT=${INFO_NANO[2]}
          NAME_SPACE=${INFO_NANO[3]}
                
          EXIST=$(docker inspect --format="{{ .Name }}" $NANO_END_POINT_HOST 2> /dev/null)
          if [ ! -z $EXIST ]; then 
            echo
            echo " Container $NANO_END_POINT_HOST  already exists, remove... "
            docker  rm  -f   $NANO_END_POINT_HOST > /dev/null
            echo " Container $NANO_END_POINT_HOST  removed !! "
            CLEANED=true
          fi
      done
            
      > $NANO_END_POINT_FILE
            
      if [ "$CLEANED" = true ] ; then
         echo
         echo -e " Cleanded ! "
         echo
      else
        echo
        echo -e " No existing EndPoint "
        echo
      fi
      echo
 
   else
   
       DISPLAY_MESSAGE
       EXIT
   fi

