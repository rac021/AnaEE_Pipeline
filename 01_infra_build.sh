#!/bin/bash

DEFAULT_BLZ_IMAGE="blazegraph"

  if test ! -z "$1" ; then
   DEFAULT_BLZ_IMAGE=$1
  fi
       
if docker history -q $DEFAULT_BLZ_IMAGE >/dev/null 2>&1; then
    echo "$DEFAULT_BLZ_IMAGE already exist, remove it..."
    docker rmi -f $DEFAULT_BLZ_IMAGE
fi

export BLZ_IMAGE=$DEFAULT_BLZ_IMAGE

echo "building image : $DEFAULT_BLZ_IMAGE "

docker build -t $BLZ_IMAGE Docker
