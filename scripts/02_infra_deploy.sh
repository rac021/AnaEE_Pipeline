#!/bin/bash

# Note :
# Docker version min : 1.10 
# $1 blazegraph nameSpace 
# $2 NameSpace
# $3 PORT Number
# $4 RW Mode

if [ $# -eq 7 ] ; then

	# Get Image Docker Name
	BLZ_IMAGE=$1
	# Get NameSpace
	NAMESPACE=$2
	# Get Port Number
	PORT=$3
	# Cluster 
	HOST_0=$4
	HOST_1=$5
	HOST_2=$6
	# Get Default Mode : 
	# 'rw' for read-write Mode
	# 'ro' for readOnly Mode. 
	DEFAULT_MODE=$7
	
	if [ "$DEFAULT_MODE" != "ro" ] && [ "$DEFAULT_MODE" != "rw" ] ; then 
	echo "DEFAULT_MODE can only have 'rw' OR 'ro' values !!"
	exit 2
	fi 
	
	# Default interface
	SUBNET="mynet123"
	
	tput setaf 2
	echo 
	echo "################################ "
	echo "######### Deploy Info ########## "
	echo "-------------------------------- "
	echo
	echo "##  SUBNET    : $SUBNET          "
	echo
	echo "##  BLZ_IMAGE : $BLZ_IMAGE       "
	echo "##  NAMESPACE : $NAMESPACE       "
	echo "##  PORT      : $PORT            "
	echo "##  HOST_0    : $HOST_0          "
	echo "##  HOST_1    : $HOST_1          "
	echo "##  HOST_2    : $HOST_2          "
	echo "##  MODE      : $DEFAULT_MODE    "
	echo
	echo "################################ "
	echo 
	sleep 2
	tput setaf 7


	SUBNET_CHECK=`docker network ls | grep $SUBNET`
	
	if docker history -q $BLZ_IMAGE >/dev/null 2>&1; then
		    
	    if [[ "${SUBNET_CHECK}" == *$SUBNET* ]]; then
	      echo "subnet - $SUBNET - already exists "
	    else
	      echo " create subnet $SUBNET "
	      docker network create --subnet=192.168.56.250/24 $SUBNET # docker network rm $SUBNET
	    fi
	
            EXIST=`docker inspect --format='{{.Name}}' $( docker ps -aq --no-trunc) | grep $HOST_0`
	    if [ ! -z $EXIST ]; then 
	      echo "Container $HOST_0 already exists, remove..."
	      docker rm -f $HOST_0
	      echo "Container $HOST_0 removed !!"
	    fi
	    
            EXIST=`docker inspect --format='{{.Name}}' $( docker ps -aq --no-trunc) | grep $HOST_1`
	    if [ ! -z $EXIST ]; then 
	      echo "Container $HOST_1 already exists, remove..."	    
	      docker rm -f $HOST_1
	      echo "Container $HOST_1 removed !!"	      
	    fi
	    
            EXIST=`docker inspect --format='{{.Name}}' $( docker ps -aq --no-trunc) | grep $HOST_2`
	    if [ ! -z $EXIST ]; then 
	      echo "Container $HOST_2 already exists, remove..."
	      docker rm -f $HOST_2
	      echo "Container $HOST_2 removed !!"
	    fi
	
	    docker run -d --net mynet123 --name $HOST_2 \
	           --add-host host_0:192.168.56.100     \
	           --add-host host_1:192.168.56.101     \
	           --add-host host_2:192.168.56.102     \
	           --ip 192.168.56.102 -p 7777:9999     \
	           --expose 9999                        \
	           -it --entrypoint /bin/bash $BLZ_IMAGE -c "./bigdata start ; while true; do sleep 1000; done "
	
	    sleep 4
	
	    docker run -d --net mynet123 --name $HOST_1 \
	           --add-host host_0:192.168.56.100     \
	           --add-host host_1:192.168.56.101     \
	           --add-host host_2:192.168.56.102     \
	           --ip 192.168.56.101 -p 8888:9999     \
	           -it --entrypoint /bin/bash $BLZ_IMAGE -c "./bigdata start; while true; do sleep 1000; done "
	
	    sleep 4 
	
	    docker run -d --net mynet123 --name $HOST_0 \
	           --add-host host_0:192.168.56.100     \
	           --add-host host_1:192.168.56.101     \
	           --add-host host_2:192.168.56.102     \
	           --ip 192.168.56.100 -p 9999:9999     \
	           -it --entrypoint /bin/bash $BLZ_IMAGE -c "./bigdata start; while true; do sleep 1000; done "
	
	    echo "waiting for blazegraph Cluster... "
	    
	    sleep 10 
	
	    # Run bigdata cluster using host_2 as EndPoint
	    docker exec $HOST_2 ./nanoSparqlServer.sh $PORT $NAMESPACE $DEFAULT_MODE &
	    
	else
	echo " Image '$BLZ_IMAGE' not found !! "
	fi

else 

  echo " Invalid arguments : please pass exactly Four arguments         "
  echo " arg_1             : Image_docker_name                          "
  echo " arg_2             : Blazegraph_namespace                       "
  echo " arg_3             : Ports  number                              "
  echo " arg_4             : Container Name One                         "
  echo " arg_5             : Container Name Two                         "
  echo " arg_6             : Container Name Three                       "
  echo " arg_7             : Mode : rw ( read-wrire) ;  ro ( readOnly ) "
    
fi

