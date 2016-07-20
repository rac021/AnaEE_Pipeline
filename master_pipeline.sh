#!/bin/bash

# Note 
# Do not touch the containers name : 
# blz_host_0 - blz_host_1 - blz_host_2 rw

# $1 BLZ_MAGE  
# $2 IP_HOST_1  
# $3 IP_HOST_2  
# $4 IP_HOST_3   
# $5 NAME_SPACE  
# $6 PORT 
# $7 RW-MODE
# $8 DATAB_BASE { [postgresql] - mysql } 

if [ $# -eq 7 -o $# -eq 8 ] ; then

   chmod -R +x scripts/*
   
  ./scripts/utils/check_commands.sh java curl psql-mysql maven docker
  
  ./scripts/utils/create_database.sh
   
  ./scripts/00_install_libs.sh $8

  ./scripts/01_infra_build.sh  $1

  ./scripts/02_infra_deploy.sh $1 $2 $3 $4 $5 $6 $7

  ./scripts/03_infra_attach_services.sh $1 blz_client 192.168.56.200 1 $5 $6 $7
  
  ./scripts/06_gen_mapping.sh
  
  ./scripts/07_ontop_gen_triples.sh
  
  ./scripts/08_corese_infer.sh
  
  ./scripts/09_load_data.sh
  
  ./scripts/10_query_example.sh
  
else
    echo
    echo " Invalid arguments :  please pass Seven or Eight arguments "
    echo " arg_1             :  Image_docker_name                    "
    echo " arg_2             :  IP HOST_1                            "
    echo " arg_3             :  IP HOST_2                            "
    echo " arg_4             :  IP HOST_2                            "
    echo " arg_5             :  Blazegraph_namespace                 "
    echo " arg_6             :  Ports  number                        "
    echo " arg_7             :  READ-WRITE MODE ( ro : rw   )        "
    echo " arg_8             :  DATA_BASE { [postgresql] - mysql }   "
    echo
fi

