#!/bin/bash

if [ $# -eq 6 ] 
then

   chmod +x scripts/*
     
  ./scripts/00_install_libs.sh 

  ./scripts/01_infra_build.sh  $1 $4 $5 $6

  ./scripts/02_infra_deploy.sh $1 $2 $3 $4 $5 $6 rw

else
    echo " Invalid argument : please pass exactly Six arguments   "
    echo " arg_1            : Image_docker_name                   "
    echo " arg_2            : Blazegraph_namespace                "
    echo " arg_3            : Ports  number                       "
    echo " arg_4            : Container Name One                  "
    echo " arg_5            : Container Name Two                  "
    echo " arg_6            : Container Name Three                "
    
fi

