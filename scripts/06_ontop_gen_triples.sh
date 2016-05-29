#!/bin/bash
    
  OWL="../mapping/ontology.owl"
  OBDA="../mapping/mapping.obda"
  OUTPUT="../data/ontop/ontopMaterializedTriples.ttl"
  QUERY="SELECT ?S ?P ?O { ?S ?P ?O } "
  TTL="-ttl"
    
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
     exit 3
  fi
  
  echo -e "\e[90m Strating Generation... \e[39m "
  echo
  
  java  -Xms1024M -Xmx2048M -cp ../libs/Ontop-Materializer.jar ontop.Main_1_18 \
  -owl  "$OWL"                                                                 \
  -obda "$OBDA"                                                                \
  -out  "$OUTPUT"                                                              \
  -q    "$QUERY"                                                               \
  $TTL
   
  echo
  echo -e "\e[36m Triples Generated in : $OUTPUT \e[39m "
  echo
        
  
