#!/bin/bash

  OWL=${1:-"../mapping/ontology.owl"}
  OBDA=${2:-"../mapping/mapping.obda"}
  OUTPUT=${3:-"../data/ontop/ontopMaterializedTriples.ttl"}
  QUERY=${4:-"SELECT ?S ?P ?O { ?S ?P ?O } "}
  TTL=${5:-"-ttl"}
  
  XMS=${6:-"-Xms1024M"}
  XMX=${7:-"-Xmx2048M"}

  EXIT() {
    parent_script=`ps -ocommand= -p $PPID | awk -F/ '{print $NF}' | awk '{print $1}'`
    if [ $parent_script = "bash" ] ; then
        exit 2
    else
        kill -9 `ps --pid $$ -oppid=`;
        exit 2
    fi
  }
  
  tput setaf 2
  echo 
  echo -e " ######################################### "
  echo -e " ######## Info Generation ################ "
  echo -e " ----------------------------------------- "
  echo -e "\e[90m$0      \e[32m                       "
  echo
  echo -e " ##  OWL    : $OWL                         "
  echo -e " ##  OBDA   : $OBDA                        "
  echo -e " ##  OUTPUT : $OUTPUT                      "
  echo -e " ##  QUERY  : $QUERY                       "
  echo -e " ##  TTL    : $TTL                         "
  echo
  echo -e " ######################################### "
  echo 
  sleep 1
  tput setaf 7

  cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
 
  if [ ! -f $OWL ]  || [ ! -f $OBDA ]  ; then
     echo -e "\e[91m Missing OWL or OBDA Files ! \e[39m "
     EXIT
  fi
  
  echo -e "\e[90m Starting Generation... \e[39m "
  echo
  
  java   $XMS  $XMX -cp ../libs/Ontop-Materializer.jar ontop.Main_1_18         \
  -owl  "$OWL"                                                                 \
  -obda "$OBDA"                                                                \
  -out  "$OUTPUT"                                                              \
  -q    "$QUERY"                                                               \
  $TTL
   
  echo
  echo -e "\e[36m Triples Generated in : $OUTPUT \e[39m "
  echo
        
  
