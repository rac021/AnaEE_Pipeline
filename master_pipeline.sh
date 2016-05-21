#!/bin/bash

if [ $# -eq 3 ] 
then

  ./scripts/00_install_libs.sh 

. ./scripts/01_infra_build.sh  $1

. ./scripts/02_infra_deploy.sh $1 $2 $3 

else
    echo " Invalid argument : please pass exactly three arguments "
    echo " arg_1 : Image_docker_name                              "
    echo " arg_2 : Blazegraph_namespace                           "
    echo " arg_3 : Ports  number                                  "
    
fi

