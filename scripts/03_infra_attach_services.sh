#!/bin/bash

# Note :
# Do not touch HOST_NAME
# Docker version min : 1.10 
# $1 blazegraph nameSpace 
# $2 NameSpace
# $3 PORT Number
# $4 RW Mode

   if [ $# -eq 7 ] ; then

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

        # Default interface
        SUBNET="mynet123"

        LOOP=" while true; do sleep 1000; done "
            
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
            echo "######################################### "
            echo "############ Attach Info ################ "
            echo "----------------------------------------- "
            echo
            echo "##  SUBNET          : $SUBNET             "
            echo
            echo "##  BLZ_IMAGE       : $BLZ_IMAGE          "
            echo "##  BN_CONTAINERNBR : $BNAME_CONTAINER    "
            echo "##  START_IP        : $START_IP           "
            echo "##  PORT            : $PORT               "
            echo "##  NBR_INSTANCE    : $NUMBER_INSTANCE    "
            echo "##  NAMESPACE       : $NAMESPACE          "
            echo
            echo "######################################### "
            echo 
            sleep 1
            tput setaf 7

            # CLEAN NANO ENDPOINT FILE
            
            HOSTS_FILE="$CURRENT_PATH/conf/hosts"
            NANO_END_POINT_FILE="$CURRENT_PATH/conf/nanoEndpoint"
            
            echo -e "\e[90m Cleaning existing Clients in :\e[39m $NANO_END_POINT_FILE "
            
            for LINE in `cat $NANO_END_POINT_FILE`; do
                        
                IFS=’:’ read -ra INFO_NANO <<< "$LINE" 
                NANO_END_POINT_HOST=${INFO_NANO[0]}
                NANO_END_POINT_IP=${INFO_NANO[1]}
                NANO_END_POINT_PORT=${INFO_NANO[2]}
                NAME_SPACE=${INFO_NANO[3]}
                
                EXIST=$(docker inspect --format="{{ .Name }}" $NANO_END_POINT_HOST 2> /dev/null)
                if [ ! -z $EXIST ]; then 
                echo
                echo " Container $NANO_END_POINT_HOST  already exists, remove..."
                docker  rm  -f  $NANO_END_POINT_HOST > /dev/null
                echo " Container $NANO_END_POINT_HOST  removed !!"
                fi
            done
            
            > $NANO_END_POINT_FILE
            echo
            echo -e " Done ! "
            echo 
            
            # PROCESS IP  
            IFS=’.’ read -ra S_IP <<< "$START_IP" 
            i1=${S_IP[0]} ; i2=${S_IP[1]} ; i3=${S_IP[2]}; i4=${S_IP[3]}
            
            HOST_PORT=$PORT
            
            let END=$i4+$NUMBER_INSTANCE
            
            for (( n=$i4; n<$END ; n++ )) ; do
                
                IP=$i1"."$i2"."$i3"."$i4
            
                NAME_INSTANCE=$BNAME_CONTAINER"_"$IP
                
                EXIST=$(docker inspect --format="{{ .Name }}" $NAME_INSTANCE 2> /dev/null)
                if [ ! -z $EXIST ]; then 
                echo " Container  $NAME_INSTANCE already exists, remove..."
                docker  rm  -f  $NAME_INSTANCE > /dev/null
                echo " Container  $NAME_INSTANCE removed !!"
                echo
                fi

                fuser -k $HOST_PORT/tcp 
                
                docker run -d --net $SUBNET                                                     \
                            --name  $NAME_INSTANCE                                              \
                            --ip    $IP                                                         \
                            -p      $HOST_PORT:$PORT                                            \
                            -it                                                                 \
                            --memory-swappiness=0		                                          \
                            --entrypoint /bin/bash $BLZ_IMAGE                                   \
                            -c " ./nanoSparqlServer.sh $PORT $NAMESPACE $DEFAULT_MODE ; $LOOP " > /dev/null
                
                echo "$NAME_INSTANCE:$IP:$PORT:$NAMESPACE" >> $NANO_END_POINT_FILE
                echo -e "\e[39m serviceURL: \e[93mhttp://$IP:$PORT  -  Published port : $HOST_PORT \e[39m"
                
                let "HOST_PORT++"
                let "i4++"
                
                if [ $i4 -eq "255" ]; then
                i4=0;
                let "i3++"
                fi
                
                echo " ---------------------------------------------------------------- "
            done
            
            echo
            
        else
           echo " Image '$BLZ_IMAGE' not found !! "
           echo 
        fi
    
   else
        echo
        echo " Invalid arguments :  Please pass exactly Seven arguments "
        echo " arg_1             :  Image_docker_name                   "
        echo " arg_2             :  Base name Container                 "
        echo " arg_3             :  Start IP                            "
        echo " arg_4             :  Number Instances                    "
        echo " arg_5             :  NameSpace                           "
        echo " arg_6             :  Port                                "
        echo " arg_7             :  READ-WRITE MODE ( ro : rw   )       "   
        echo
   fi

