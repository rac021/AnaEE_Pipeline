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
	BASE_NAME_CONTAINER=$2
	NUMBER_INSTANCE=$3
	START_IP=$4
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
	HOST_FILE="$CURRENT_PATH/conf/hosts"
  STATUS_FILE="$CURRENT_PATH/conf/statusServices"
  NANO_END_POINT_FILE="$CURRENT_PATH/conf/nanoEndpoint"

	tput setaf 2
	echo 
	echo "######################################### "
	echo "############ Attach Info ################ "
	echo "----------------------------------------- "
	echo
	echo "##  SUBNET       : $SUBNET                "
	echo
	echo "##  BLZ_IMAGE    : $BLZ_IMAGE             "
	echo "##  NAMESPACE    : $NAMESPACE             "
	echo "##  PORT         : $PORT                  "
	echo "##  NBR_INSTANCE : $NUMBER_INSTANCE       "
	echo "##  MODE         : $DEFAULT_MODE          "
	echo
	echo "######################################### "
	echo 
	sleep 2
	tput setaf 7

  # CLEAN NANO ENDPOINT FILE
  for LINE in `cat $NANO_END_POINT_FILE`; do
            
    IFS=’:’ read -ra INFO_NANO <<< "$LINE" 
    NANO_END_POINT_HOST=${INFO_NANO[0]}
    NANO_END_POINT_IP=${INFO_NANO[1]}
    NANO_END_POINT_PORT=${INFO_NANO[2]}
    NAME_SPACE=${INFO_NANO[3]}
    echo
    
    EXIST=$(docker inspect --format="{{ .Name }}" $NANO_END_POINT_HOST 2> /dev/null)
    if [ ! -z $EXIST ]; then 
      echo "Container $NANO_END_POINT_HOST already exists, remove..."
      docker  rm  -f  $NANO_END_POINT_HOST
      echo "Container $NANO_END_POINT_HOST removed !!"
      echo
    fi
  done
  
  > $NANO_END_POINT_FILE
  
  # PROCESS IP  
  i1=192; i2=168; i3=56; i4=0
  eval printf -v ip "%s\ " $i1.$i2.$i3.{$i4..$NUMBER_INSTANCE}

  for IP in $ip ; do
    
    NAME_INSTANCE=$BASE_NAME_CONTAINER_$IP
    
    EXIST=$(docker inspect --format="{{ .Name }}" $NAME_INSTANCE 2> /dev/null)
    
    if [ ! -z $EXIST ]; then 
      echo "Container $NAME_INSTANCE already exists, remove..."
      docker  rm  -f  $NAME_INSTANCE
      echo "Container $NAME_INSTANCE removed !!"
      echo
    fi

    docker run -d --net mynet123 --name blz_host_69 \
	             --ip 192.168.56.50  -p   5555:6981    \
	             -it --entrypoint /bin/bash blz_final -c " ./nanoSparqlServer.sh $PORT $NAMESPACE $DEFAULT_MODE ; $LOOP  "
	  
	  echo "$HOST_0:$IP_HOST_0:$PORT:$NAMESPACE" >> $NANO_END_POINT_FILE
	  echo -e "\e[39m serviceURL: \e[93mhttp://$IP_HOST_0:$PORT"
     
  done
 
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

