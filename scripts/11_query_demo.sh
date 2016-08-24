#!/bin/bash

  EXIT() {
     parent_script=`ps -ocommand= -p $PPID | awk -F/ '{print $NF}' | awk '{print $1}'`
     if [ $parent_script = "bash" ] ; then
         echo; echo -e " \e[90m exited by : $0 \e[39m " ; echo
         exit 2
     else
         echo ; echo -e " \e[90m exited by : $0 \e[39m " ; echo
         kill -9 `ps --pid $$ -oppid=`;
         exit 2
     fi
  }
  
  CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  NANO_END_POINT_FILE="$CURRENT_PATH/conf/nanoEndpoint"
    
  if [ -f $NANO_END_POINT_FILE ] ; then
    
    FIRST_END_POINT=$(head -n 1 $NANO_END_POINT_FILE )

    IFS=’:’ read -ra INFO_NANO <<< "$FIRST_END_POINT" 
    NANO_END_POINT_IP=${INFO_NANO[1]}
    NANO_END_POINT_PORT=${INFO_NANO[2]}
    NANO_END_POINT_NAMESPACE=${INFO_NANO[3]}

    ENDPOINT="http://$NANO_END_POINT_IP:$NANO_END_POINT_PORT/bigdata/namespace/$NANO_END_POINT_NAMESPACE/sparql"
    
    RES=`curl -s -I $ENDPOINT | grep HTTP/1.1 | awk {'print $2'}`
    COUNT=0
    echo
    
    while [ -z $RES ] || [ $RES -ne 200 ] ;do
       sleep 1
       RES=`curl -s -I $ENDPOINT | grep HTTP/1.1 | awk {'print $2'}`
       let "COUNT++" 
           
       if  [ -z $RES ] || [ $RES != 200 ] ; then 
          if [ `expr $COUNT % 3` -eq 0 ] ; then
              echo -e " \e[90m -> attempt to join cluster on namespace $NAMESPACE .. \e[39m"
          fi
          if [ $COUNT -eq 20 ] ; then
              echo -e " \e[31m ENDPOINT $ENDPOINT Not reachable !! \e[39m"
              echo
              EXIT
          fi
       fi
           
    done
    
    tput setaf 2
    echo -e "-------------------------------------------------------- "
    echo -e "## Query Demo usning Curl ##                             "
    echo -e "-----------------------------                            "
    echo -e "\e[90m$0       \e[32m                                    "
    echo
    echo -e " ## EndPoint : $ENDPOINT                                 "
    echo
    echo -e "-------------------------------------------------------- "
    echo 
    sleep 1
    tput setaf 7
  	
    curl -X POST $ENDPOINT --data-urlencode \
    'query=PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
           PREFIX oboe-core: <http://ecoinformatics.org/oboe/oboe.1.0/oboe-core.owl#>
           SELECT ?uri ?unite {
     	        ?uri a oboe-core:Measurement .
   	          ?uri oboe-core:hasValue ?unite
           }
           LIMIT 3
    ' \
    -H 'Accept:application/json'
   
    echo ; echo 
    echo -e " \e[47m\e[30m Powered by EcoInfo-Orleans & Ontop Corese BlazeGraph © 2016 \e[49m\e[39m "
    echo
   
  else 
        
    echo -e "\e[91m Oupss, config missed !!\e[39m "
 
  fi
    
    
    
