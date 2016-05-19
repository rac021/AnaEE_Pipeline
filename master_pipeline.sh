#!/bin/bash

if [ $# -eq 2 ] 
then

  ./scripts/00_install_libs.sh 

. ./scripts/01_infra_build.sh  $1

. ./scripts/02_infra_deploy.sh $2

else
    echo "invalid argument : please pass exactly two arguments "
    echo " arg_1 : Image_docker_name                           "
    echo " arg_2 : Blazegraph_namespace                        "
    
fi

