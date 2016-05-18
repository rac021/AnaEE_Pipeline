#!/bin/bash

# Note :
# To be able to get environment variables, 
# this script mut be launched using :  . ./02_infra_deploy.sh
# Docker version min : 1.10 

# get image docker name from environment
BLZ_IMAGE=$DEFAULT_BLZ_IMAGE

# Default NameSpace
NAMESPACE="ola"

if test ! -z "$1" ; then
   NAMESPACE=$1
fi

HOST_0="HOST_0"
HOST_1="HOST_1"
HOST_2="HOST_2"

SUBNET="mynet123"

SUBNET_CHECK=`docker network ls | grep $SUBNET`

if docker history -q $BLZ_IMAGE >/dev/null 2>&1; then
	    
    if [[ "${SUBNET_CHECK}" == *$SUBNET* ]]; then
      echo "subnet already existing ";
    else
      echo " create subnet $SUBNET "
      docker network create --subnet=192.168.56.250/24 $SUBNET # docker network rm mynet123
    fi

    $(docker inspect --format="{{ .State.Running }}" $HOST_0 2> /dev/null)
    if [ $? != 1 ]; then
      echo "Container $HOST_0 exists, remove it..."
      docker rm -f $HOST_0
    fi
    $(docker inspect --format="{{ .State.Running }}" $HOST_1 2> /dev/null)
    if [ $? != 1 ]; then
      echo "Container $HOST_1 exists, remove it..."
      docker rm -f $HOST_1
    fi
    $(docker inspect --format="{{ .State.Running }}" $HOST_2 2> /dev/null)
    if [ $? != 1 ]; then
      echo "Container $HOST_2 exists, remove it..."
      docker rm -f $HOST_2
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
    docker exec $HOST_2 ./nanoSparqlServer.sh 9999 $NAMESPACE &
    
else
echo " Image '$BLZ_IMAGE' not found !! "
fi
