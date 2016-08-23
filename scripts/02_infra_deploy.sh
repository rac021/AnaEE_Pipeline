#!/bin/bash

# Note :
# Do not touch HOST_NAME
# Docker version min : 1.10 
# $1 BLZ_IMAGE 
# $2 IP_HOST_0
# $3 IP_HOST_1
# $4 IP_HOST_2
# $5 NAMESPACE
# $6 SUBNET_NAME [ Optionnal ]
# $7 SUBNET_RANGE [ Optionnal ]

if [ $# -ge 5 ] ; then

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

   # Get NameSpace
   NAMESPACE=$5
  
   # Default interface mynet123
   SUBNET=${6:-"mynet123"}
   SUBNET_RANGE=${7:-"192.168.56.250/24"} 
   
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
     # --privileged=true -i -v /data1/Downloads:/Downloads 
     echo -e "\e[36m Run Container [ $HOST ] \e[39m "
     sleep 1
     RUNNING=$( docker run -d --net mynet123 --name $HOST     \
       	                   --memory-swappiness=0	      \
	                   --add-host $HOST_0:$IP_HOST_0      \
	                   --add-host $HOST_1:$IP_HOST_1      \
	                   --add-host $HOST_2:$IP_HOST_2      \
	                   --ip $IP                           \
	                   -it --entrypoint /bin/bash $BLZ_IMAGE -c "./bigdata start; $LOOP "  2>&1 )

     if [[ "$RUNNING" =~ "Error" ]]; then
        echo
        echo "$RUNNING"
        EXIT
     fi	
     echo "$HOST" >> $HOST_FILE
     sleep 5
   }

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
         docker network create --subnet=$SUBNET_RANGE $SUBNET 
         # docker network rm $SUBNET
     fi

    
     removeAllContainerBasedOnImage $BLZ_IMAGE
 
     > $HOST_FILE
     > $STATUS_FILE
     > $NANO_END_POINT_FILE
    
     runContainer  $HOST_2  $IP_HOST_2
     runContainer  $HOST_1  $IP_HOST_1
     runContainer  $HOST_0  $IP_HOST_0
	
     echo
     echo -e "\e[94m waiting for blazegraph Cluster.. ~ 10s  \e[39m "
     sleep 8 
     echo -e " .. "
     echo
	    
     echo "1" > $STATUS_FILE	    
	
   else
      echo " Image '$BLZ_IMAGE' not found !! "
      echo " Run script 01_infra_build.sh before "
      EXIT
   fi
     
else
    echo
    echo " Invalid arguments :  Please pass at least Five arguments        "
    echo " arg_1             :  Image_docker_name                          "
    echo " arg_2             :  IP Container HOST_1                        "
    echo " arg_3             :  IP Container HOST_2                        "
    echo " arg_4             :  IP Container HOST_3                        "
    echo " arg_5             :  Blazegraph_namespace                       "
    echo " Optionnal         :                                             "
    echo " SUBNET            :  SUBNET_NAME ( Default : mynet123           "
    echo " SUBNET_RANGE      :  SUBNET_RANGE ( Default : 192.168.56.250/24 "
    echo
fi

