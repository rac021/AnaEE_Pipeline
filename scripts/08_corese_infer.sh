#!/bin/bash
    
  OWL="../mapping/ontology.owl"
  TTL="../data/ontop/ontopMaterializedTriples.ttl"
  QUERY=" SELECT ?S ?P ?O { ?S ?P ?O } "
  OUTPUT="../data/corese"
  f="100000"
  F="ttl"

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
     exit 3
  fi
  
  echo -e "\e[90m Strating Generation... \e[39m "
  echo

  java -Xms1024M -Xmx2048M -cp ../libs/CoreseInfer.jar corese.Main \
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
        
