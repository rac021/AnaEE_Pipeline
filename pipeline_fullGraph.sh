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

   BLZ_MAGE="$1"
   IP_HOST_1="$2"
   IP_HOST_2="$3"
   IP_HOST_3="$4"
   NAME_SPACE="$5"
   PORT="$6"
   RW_MODE="$7"
   
   DATABASE=${8:-psql}
  
   TYPE_INSTALL="fullGraph"
   
   chmod -R +x scripts/*
   
  ./scripts/utils/check_commands.sh java curl psql-mysql mvn docker
   
  ./scripts/00_install_libs.sh $DATABASE $TYPE_INSTALL

  ./scripts/01_infra_build.sh  $BLZ_MAGE

  ./scripts/02_infra_deploy.sh $BLZ_MAGE $IP_HOST_1 $IP_HOST_2 $IP_HOST_3 $NAME_SPACE $PORT

  ./scripts/03_infra_deploy_services.sh $BLZ_MAGE blz_client 192.168.56.200 1 $NAME_SPACE $PORT $RW_MODE
  
   # ./scripts/04_infra_attach_service.sh $BLZ_MAGE client_01_blz 192.168.56.221 $NAME_SPACE $PORT $RW_MODE
  
  ./scripts/07_gen_mapping.sh
  
  ./scripts/08_ontop_gen_triples.sh
  
  ./scripts/09_corese_infer.sh
  
  ./scripts/10_load_data.sh
  
  ./scripts/13_portal_query.sh ../data/portail/ola_portal_synthesis.ttl
  
  
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
