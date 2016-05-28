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
	
	# Get Image Docker Name
	BLZ_IMAGE=$1
	# Get NameSpace
	NAMESPACE=$2
	# Get Port Number
	PORT=$3
	# IP per Host # Configurable
	IP_HOST_0=$4
	IP_HOST_1=$5
	IP_HOST_2=$6
	# Get Default Mode : 
	# 'rw' for read-write Mode
	# 'ro' for readOnly Mode. 
	DEFAULT_MODE=$7
	
	LOOP=" while true; do sleep 1000; done "
	
	if [ "$DEFAULT_MODE" != "ro" ] && [ "$DEFAULT_MODE" != "rw" ] ; then 
	echo "DEFAULT_MODE can only have 'rw' OR 'ro' values !!"
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
	echo -e "##################################### "
	echo -e "######### Deploy Info ############### "
	echo -e "------------------------------------- "
        echo -e "\e[90m$0     \e[32m                   "
	echo
	echo -e "##  SUBNET    : $SUBNET               "
	echo
	echo -e "##  BLZ_IMAGE : $BLZ_IMAGE            "
	echo -e "##  NAMESPACE : $NAMESPACE            "
	echo -e "##  PORT      : $PORT                 "
	echo -e "##  HOST_0    : $HOST_0 : $IP_HOST_0  "
	echo -e "##  HOST_1    : $HOST_1 : $IP_HOST_1  "
	echo -e "##  HOST_2    : $HOST_2 : $IP_HOST_2  "
	echo -e "##  MODE      : $DEFAULT_MODE         "
	echo
	echo -e "##################################### "
	echo 
	sleep 2
	tput setaf 7

	SUBNET_CHECK=`docker network ls | grep $SUBNET`
	
	if docker history -q $BLZ_IMAGE >/dev/null 2>&1; then
		    
	    if [[ "${SUBNET_CHECK}" == *$SUBNET* ]]; then
	      echo "subnet - $SUBNET - already exists "
	    else
	      echo " create subnet $SUBNET "
	      docker network create --subnet=192.168.56.250/24 $SUBNET 
	      # docker network rm $SUBNET
	    fi
	
            echo 
            EXIST=$(docker inspect --format="{{ .Name }}" $HOST_0 2> /dev/null)
            if [ ! -z $EXIST ]; then 
	      echo "Container $HOST_0 already exists, remove..."
	      docker  rm  -f  $HOST_0
	      echo "Container $HOST_0 removed !!"
	      echo
	    fi
	    
            EXIST=$(docker inspect --format="{{ .Name }}" $HOST_1 2> /dev/null)
            if [ ! -z $EXIST ]; then 
	      echo "Container $HOST_1 already exists, remove..."	    
	      docker  rm  -f  $HOST_1
	      echo "Container $HOST_1 removed !!"
	      echo
	    fi
	    
            EXIST=$(docker inspect --format="{{ .Name }}" $HOST_2 2> /dev/null)
            if [ ! -z $EXIST ]; then 
	      echo "Container $HOST_2 already exists, remove..."
	      docker  rm  -f  $HOST_2
	      echo "Container $HOST_2 removed !!"
	      echo
	    fi
	
	    # --privileged=true -i -v /data1/Downloads:/Downloads 
	    echo -e "\e[36m Run Container $HOST_2 \e[39m "
	    docker run -d --net mynet123 --name $HOST_2 \
	    	   --memory-swappiness=0		\
	           --add-host $HOST_0:$IP_HOST_0        \
	           --add-host $HOST_1:$IP_HOST_1        \
	           --add-host $HOST_2:$IP_HOST_2        \
	           --ip $IP_HOST_2   -p   7777:$PORT    \
	           --expose $PORT                       \
	           -it --entrypoint /bin/bash $BLZ_IMAGE -c "./bigdata start; $LOOP " > /dev/null
	
            echo "$HOST_2" >> $HOST_FILE
	    sleep 4
	
	    echo -e "\e[36m Run Container $HOST_1 \e[39m "
	    docker run -d --net mynet123 --name $HOST_1 \
	    	   --memory-swappiness=0		\
	           --add-host $HOST_0:$IP_HOST_0        \
	           --add-host $HOST_1:$IP_HOST_1        \
	           --add-host $HOST_2:$IP_HOST_2        \
	           --ip $IP_HOST_1  -p   8888:$PORT     \
	           -it --entrypoint /bin/bash $BLZ_IMAGE -c "./bigdata start; $LOOP " > /dev/null
	
           echo "$HOST_1" >> $HOST_FILE
	   sleep 4 
	
	   echo -e "\e[36m Run Container $HOST_0 \e[39m "
	    docker run -d --net mynet123 --name $HOST_0 \
	    	   --memory-swappiness=0		\
  	           --add-host $HOST_0:$IP_HOST_0        \
	           --add-host $HOST_1:$IP_HOST_1        \
	           --add-host $HOST_2:$IP_HOST_2        \
	           --ip $IP_HOST_0  -p   9999:$PORT     \
	           -it --entrypoint /bin/bash $BLZ_IMAGE -c "./bigdata start; $LOOP " > /dev/null
	
	    echo "$HOST_0" >> $HOST_FILE
            echo
            echo -e "\e[94m waiting for blazegraph Cluster.. ~ 8s  \e[39m "
	    sleep 8 
	    echo
	    
	    # Start EndPoint blz_host_0
	    #docker exec -dit $HOST_0 ./nanoSparqlServer.sh $PORT $NAMESPACE $DEFAULT_MODE 
	    #echo "$HOST_0:$IP_HOST_0:$PORT:$NAMESPACE" >> $NANO_END_POINT_FILE
	    #echo -e "\e[39m serviceURL: \e[93mhttp://$IP_HOST_0:$PORT"
	    #echo
	    # Start EndPoint blz_host_1
	    #docker exec -dit $HOST_1 ./nanoSparqlServer.sh $PORT $NAMESPACE $DEFAULT_MODE 
	    #echo "$HOST_1:$IP_HOST_1:$PORT:$NAMESPACE" >> $NANO_END_POINT_FILE
	    #echo -e "\e[39m serviceURL: \e[93mhttp://$IP_HOST_1:$PORT"
	    #echo	    
	    # Start EndPoint blz_host_2
	    #docker exec -dit $HOST_2 ./nanoSparqlServer.sh $PORT $NAMESPACE $DEFAULT_MODE 
	    #echo "$HOST_2:$IP_HOST_2:$PORT:$NAMESPACE" >> $NANO_END_POINT_FILE
	    #echo -e "\e[39m serviceURL: \e[93mhttp://$IP_HOST_2:$PORT"
	    
	    echo "1" > $STATUS_FILE	    
	    echo -e " \e[97m "
    
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

