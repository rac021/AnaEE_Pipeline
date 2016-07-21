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

   # Cluster Host Name. Do not TOUCH 
   HOST_0="blz_host_0"
   HOST_1="blz_host_1"
   HOST_2="blz_host_2"
   # IP per Host # Configurable
   IP_HOST_0=$2
   IP_HOST_1=$3
   IP_HOST_2=$4

   FORWARD_PORT_0="6981"
   FORWARD_PORT_1="6982"
   FORWARD_PORT_2="6983"
   
   # Get NameSpace
   NAMESPACE=$5
   # Get Port Number
   PORT=$6
   # Get Default Mode : 
   # 'rw' for read-write Mode
   # 'ro' for readOnly Mode. 
   DEFAULT_MODE=$7
	
   LOOP=" while true; do sleep 1000; done "

   CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
   HOST_FILE="$CURRENT_PATH/conf/hosts"
   STATUS_FILE="$CURRENT_PATH/conf/status"
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
    
   removeAllContainerBasedOnImage() {
      IMAGE=$1
      echo
      echo -e " Remove all containers based on images  $IMAGE "
      echo
      docker ps -a | awk '{ print $1,$2 }' | grep $IMAGE | awk '{print $1 }' | xargs -I {} docker rm -f {}
      echo
      echo -e " All containers removed !! "
      echo
   } 
     
   runContainer() {
     HOST=$1
     IP=$2
     PORT=$3
     FORWARD_PORT=$4
     # --privileged=true -i -v /data1/Downloads:/Downloads 
     echo -e "\e[36m Run Container $HOST \e[39m "
     RUNNING=$( docker run -d --net mynet123 --name $HOST     \
       	                   --memory-swappiness=0	      \
	                   --add-host $HOST_0:$IP_HOST_0      \
	                   --add-host $HOST_1:$IP_HOST_1      \
	                   --add-host $HOST_2:$IP_HOST_2      \
	                   --ip $IP  -p  $FORWARD_PORT:$PORT  \
	                   --expose $PORT                     \
	                   -it --entrypoint /bin/bash $BLZ_IMAGE -c "./bigdata start; $LOOP "  2>&1 )

     if [[ "$RUNNING" =~ "Error" ]]; then
        echo
        echo "$RUNNING"
        EXIT
     fi	
     echo "$HOST" >> $HOST_FILE
     sleep 5
   }

   if [ "$DEFAULT_MODE" != "ro" ] && [ "$DEFAULT_MODE" != "rw" ] ; then 
      echo
      echo " DEFAULT_MODE can only have 'rw' OR 'ro' values !!"
      EXIT
   fi 
    
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
   echo -e " ##  HOST_0    : $HOST_0 : $IP_HOST_0  "
   echo -e " ##  HOST_1    : $HOST_1 : $IP_HOST_1  "
   echo -e " ##  HOST_2    : $HOST_2 : $IP_HOST_2  "
   echo -e " ##  NAMESPACE : $NAMESPACE            "
   echo -e " ##  PORT      : $PORT                 "
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

     fuser -k $FORWARD_PORT_0/tcp
     isFreePort $FORWARD_PORT_0
     fuser -k $FORWARD_PORT_1/tcp
     isFreePort $FORWARD_PORT_1
     fuser -k $FORWARD_PORT_2/tcp
     isFreePort $FORWARD_PORT_2
     
     removeAllContainerBasedOnImage $BLZ_IMAGE
 
     > $HOST_FILE
     > $STATUS_FILE
     > $NANO_END_POINT_FILE
    
     runContainer  $HOST_2  $IP_HOST_2 $PORT $FORWARD_PORT_2
     runContainer  $HOST_1  $IP_HOST_1 $PORT $FORWARD_PORT_1
     runContainer  $HOST_0  $IP_HOST_0 $PORT $FORWARD_PORT_0
	
     echo
     echo -e "\e[94m waiting for blazegraph Cluster.. ~ 10s  \e[39m "
     sleep 8 
     echo -e " .. "
     echo
	    
     echo "1" > $STATUS_FILE	    
	
   else
      echo " Image '$BLZ_IMAGE' not found !! "
      echo " Run script 01_infra_build.sh before "
      echo 
   fi
     
else
    echo
    echo " Invalid arguments :  Please pass exactly Seven arguments "
    echo " arg_1             :  Image_docker_name                   "
    echo " arg_2             :  IP Container HOST_1                 "
    echo " arg_3             :  IP Container HOST_2                 "
    echo " arg_4             :  IP Container HOST_3                 "
    echo " arg_5             :  Blazegraph_namespace                "
    echo " arg_6             :  Ports  number                       "
    echo " arg_7             :  READ-WRITE MODE ( ro : rw   )       "   
    echo
fi

