#!/bin/bash

# Note :
# Docker version min : 1.10 
# $1 blazegraph nameSpace 
# $2 NameSpace
# $3 PORT Number
# $4 RW Mode

if [ $# -eq 4 ] ; then

	# Get Image Docker Name
	BLZ_IMAGE=$1
	# Get NameSpace
	NAMESPACE=$2
	# Get Port Number
	PORT=$3
	# Get Default Mode : 'rw' for read-write Mode. 'ro' for readOnly Mode. 
	DEFAULT_MODE=$4
	
	# Default interface
	SUBNET="mynet123"
	
	# Cluster 
	HOST_0="HOST_0"
	HOST_1="HOST_1"
	HOST_2="HOST_2"
	
	SUBNET_CHECK=`docker network ls | grep $SUBNET`
	
	if docker history -q $BLZ_IMAGE >/dev/null 2>&1; then
		    
	    if [[ "${SUBNET_CHECK}" == *$SUBNET* ]]; then
	      echo "subnet - $SUBNET - already existing ";
	    else
	      echo " create subnet $SUBNET "
	      docker network create --subnet=192.168.56.250/24 $SUBNET # docker network rm $SUBNET
	    fi
	
            EXIST=`docker inspect --format='{{.Name}}' $(sudo docker ps -aq --no-trunc) | grep $HOST_0`
	    if [ ! -z $EXIST ]; then 
	      echo "Container $HOST_0 already exists, remove..."
	      docker rm -f $HOST_0
	      echo "Container $HOST_0 removed !!"
	    fi
	    
            EXIST=`docker inspect --format='{{.Name}}' $(sudo docker ps -aq --no-trunc) | grep $HOST_1`
	    if [ ! -z $EXIST ]; then 
	      echo "Container $HOST_1 already exists, remove..."	    
	      docker rm -f $HOST_1
	      echo "Container $HOST_1 removed !!"	      
	    fi
	    
            EXIST=`docker inspect --format='{{.Name}}' $(sudo docker ps -aq --no-trunc) | grep $HOST_2`
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
	
	    echo "waiting for blazegraph Clutser... "
	    sleep 10 
	
	    # Run bigdata cluster using host_2 as EndPoint
	    docker exec $HOST_2 ./nanoSparqlServer.sh $PORT $NAMESPACE $DEFAULT_MODE &
	    
	else
	echo " Image '$BLZ_IMAGE' not found !! "
	fi

else 

  echo " Invalid argument : please pass exactly Four arguments  "
  echo " arg_1 : Image_docker_name                              "
  echo " arg_2 : Blazegraph_namespace                           "
  echo " arg_3 : Ports  number                                  "
  echo " arg_4 : Mode : rw ( read-wrire) ;  ro ( readOnly )     "
  
fi
