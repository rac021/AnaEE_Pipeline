#!/bin/bash

if [ $# -eq 2 ] 
then
    
. ./scripts/01_infra_build.sh  $1

. ./scripts/02_infra_deploy.sh $2

else
    echo "invalid argument please pass only two arguments "
fi

