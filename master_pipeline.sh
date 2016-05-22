#!/bin/bash

# Note 
# Do not touch the containers name : 
# blz_host_0 - blz_host_1 - blz_host_2 rw

if [ $# -eq 6 ] ; then

   chmod +x scripts/*
     
  ./scripts/00_install_libs.sh 

  ./scripts/01_infra_build.sh  $1 $4 $5 $6

  ./scripts/02_infra_deploy.sh $1 $2 $3 blz_host_0 blz_host_1 blz_host_2 rw

else

    echo " Invalid arguments :  please pass exactly Six arguments   "
    echo " arg_1             :  Image_docker_name                   "
    echo " arg_2             :  Blazegraph_namespace                "
    echo " arg_3             :  Ports  number                       "

fi

