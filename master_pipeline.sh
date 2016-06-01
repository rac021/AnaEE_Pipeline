#!/bin/bash

# Note 
# Do not touch the containers name : 
# blz_host_0 - blz_host_1 - blz_host_2 rw

if [ $# -eq 7 ] ; then

   chmod -R +x scripts/*
   
  ./scripts/utils/script_postgres_db.sh
   
  ./scripts/00_install_libs.sh 

  ./scripts/01_infra_build.sh  $1

  ./scripts/02_infra_deploy.sh $1 $2 $3 $4 $5 $6 $7

  ./scripts/03_infra_attach_services.sh $1 blz_client 192.168.56.200 1 $2 $3 $7
  
  ./scripts/06_gen_mapping.sh
  
  ./scripts/07_ontop_gen_triples.sh
  
  ./scripts/08_corese_infer.sh
  
  ./scripts/09_load_data.sh
  
  ./scripts/10_query_example.sh
  
else

    echo " Invalid arguments :  please pass exactly Seven arguments "
    echo " arg_1             :  Image_docker_name                   "
    echo " arg_2             :  Blazegraph_namespace                "
    echo " arg_3             :  Ports  number                       "
    echo " arg_4             :  IP HOST_1                           "
    echo " arg_5             :  IP HOST_2                           "
    echo " arg_6             :  IP HOST_2                           "
    echo " arg_7             :  READ-WRITE MODE ( ro : rw   )       "        
fi

