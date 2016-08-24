#!/bin/bash
   
  OWL=${1:-"../mapping/ontology.owl"}
  TTL=${2:-"../data/ontop/ontopMaterializedTriples.ttl"}
  QUERY=${3:-" SELECT ?S ?P ?O { ?S ?P ?O } "}
  OUTPUT=${4:-"../data/corese"}
  f=${5:-"100000"}
  F=${6:-"ttl"}
  XMS=${7:-"-Xms2048M"}
  XMX=${8:-"-Xmx2048M"}

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
  
  tput setaf 2
  echo 
  echo -e " ######################################################### "
  echo -e " ######## Info Generation ################################ "
  echo -e " --------------------------------------------------------- "
  echo -e "\e[90m$0        \e[32m                                     "
  echo
  echo -e " ##  OWL      : $OWL                                       "  
  echo -e " ##  TTL      : $TTL                                       "
  echo -e " ##  QUERY    : $QUERY                                     "
  echo -e " ##  OUTPUT   : $OUTPUT                                    "
  echo -e " ##  FORMAT   : $F                                         "
  echo -e " ##  FRAGMENT : $f                                         "
  echo
  echo -e " ######################################################### "
  echo 
  sleep 1
  tput setaf 7

  cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
 
  if [ ! -f $OWL ]  || [ ! -f $TTL ]  ; then
     echo -e "\e[91m Missing OWL or TTL Files ! \e[39m "
     EXIT
  fi
  
  echo -e "\e[90m Strating Generation... \e[39m "
  echo

  java  $XMS $XMX  -cp  ../libs/CoreseInfer.jar  corese.Main       \
  -owl "$OWL"                                                      \
  -ttl  "$TTL"                                                     \
  -q   "$QUERY"                                                    \
  -out "$OUTPUT"                                                   \
  -f   "$f"                                                        \
  -F   "$F"                                                        \
  -e
  
  echo 
  echo -e "\e[36m Triples Generated in : $OUTPUT \e[39m "
  echo
        
