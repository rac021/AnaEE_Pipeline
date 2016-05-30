#!/bin/bash

# Note :
# Do not touch HOST_NAME
# Docker version min : 1.10 
# $1 blazegraph nameSpace 
# $2 NameSpace
# $3 PORT Number
# $4 RW Mode

if [ $# -eq 7 ] ; then

   # Cluster Host Name. Do not TOUCH 
   HOST_0="blz_host_0"
   HOST_1="blz_host_1"
   HOST_2="blz_host_2"
   # IP per Host # Configurable
   IP_HOST_0=$4
   IP_HOST_1=$5
   IP_HOST_2=$6
	
   HOSTS=( $HOST_0 $HOST_1 $HOST_2 )
	
   # Get Image Docker Name
   BLZ_IMAGE=$1
   # Get NameSpace
   NAMESPACE=$2
   # Get Port Number
   PORT=$3
   # Get Default Mode : 
   # 'rw' for read-write Mode
   # 'ro' for readOnly Mode. 
   DEFAULT_MODE=$7
	
   LOOP=" while true; do sleep 1000; done "
	
   removeContainerIfExists() {
     CONTAINER=$1
     EXIST=$(docker inspect --format="{{ .Name }}" $CONTAINER 2> /dev/null)
     if [ ! -z $EXIST ]; then 
        echo
        echo " Container $CONTAINER  already exists, remove... "
        docker  rm  -f   $CONTAINER > /dev/null
        echo " Container $CONTAINER  removed !! "
        CLEANED=true
     fi
   }
        
   runContainer() {
     HOST=$1
     IP=$2
     PORT=$3
     FORWARD_PORT=$4
     # --privileged=true -i -v /data1/Downloads:/Downloads 
     echo -e "\e[36m Run Container $HOST \e[39m "
     docker run -d --net mynet123 --name $HOST        \
       	           --memory-swappiness=0	      \
	           --add-host $HOST_0:$IP_HOST_0      \
	           --add-host $HOST_1:$IP_HOST_1      \
	           --add-host $HOST_2:$IP_HOST_2      \
	           --ip $IP  -p  $FORWARD_PORT:$PORT  \
	           --expose $PORT                     \
	           -it --entrypoint /bin/bash $BLZ_IMAGE -c "./bigdata start; $LOOP " > /dev/null
	
     echo "$HOST_2" >> $HOST_FILE
     sleep 4
   }

   if [ "$DEFAULT_MODE" != "ro" ] && [ "$DEFAULT_MODE" != "rw" ] ; then 
      echo
      echo " DEFAULT_MODE can only have 'rw' OR 'ro' values !!"
      echo
      exit 2
   fi 

   CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
   HOST_FILE="$CURRENT_PATH/conf/hosts"
   STATUS_FILE="$CURRENT_PATH/conf/status"
   NANO_END_POINT_FILE="$CURRENT_PATH/conf/nanoEndpoint"
        
   > $HOST_FILE
   > $STATUS_FILE
   > $NANO_END_POINT_FILE
    
   # Default interface
   SUBNET="mynet123"
	
   tput setaf 2
   echo 
   echo -e " ##################################### "
   echo -e " ######### Deploy Info ############### "
   echo -e " ------------------------------------- "
   echo -e " \e[90m$0     \e[32m                   "
   echo
   echo -e " ##  SUBNET    : $SUBNET               "
   echo
   echo -e " ##  BLZ_IMAGE : $BLZ_IMAGE            "
   echo -e " ##  NAMESPACE : $NAMESPACE            "
   echo -e " ##  PORT      : $PORT                 "
   echo -e " ##  HOST_0    : $HOST_0 : $IP_HOST_0  "
   echo -e " ##  HOST_1    : $HOST_1 : $IP_HOST_1  "
   echo -e " ##  HOST_2    : $HOST_2 : $IP_HOST_2  "
   echo -e " ##  MODE      : $DEFAULT_MODE         "
   echo
   echo -e " ##################################### "
   echo 
   sleep 2
   tput setaf 7

   SUBNET_CHECK=`docker network ls | grep $SUBNET`
	
   if docker history -q $BLZ_IMAGE >/dev/null 2>&1; then
		    
     if [[ "${SUBNET_CHECK}" == *$SUBNET* ]]; then
         echo " subnet - $SUBNET - already exists "
     else
         echo " create subnet $SUBNET "
         docker network create --subnet=192.168.56.250/24 $SUBNET 
         # docker network rm $SUBNET
     fi
	
     echo 
            
     for HOST in ${HOSTS[@]}
     do
        removeContainerIfExists $HOST
     done 
	 	
     echo
	    
     runContainer  $HOST_2  $IP_HOST_2 $PORT 7777
     runContainer  $HOST_1  $IP_HOST_1 $PORT 8888
     runContainer  $HOST_0  $IP_HOST_0 $PORT 9999
	
     echo
     echo -e "\e[94m waiting for blazegraph Cluster.. ~ 8s  \e[39m "
     sleep 8 
     echo -e " .. "
     echo
	    
     echo "1" > $STATUS_FILE	    
	
   else
     
      echo " Image '$BLZ_IMAGE' not found !! "
      echo 
   fi
     
else
    echo
    echo " Invalid arguments :  Please pass exactly Seven arguments "
    echo " arg_1             :  Image_docker_name                   "
    echo " arg_2             :  Blazegraph_namespace                "
    echo " arg_3             :  Ports  number                       "
    echo " arg_4             :  IP Container HOST_1                 "
    echo " arg_5             :  IP Container HOST_2                 "
    echo " arg_6             :  IP Container HOST_3                 "
    echo " arg_7             :  READ-WRITE MODE ( ro : rw   )       "   
    echo
fi

