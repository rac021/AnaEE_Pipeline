#!/bin/bash
    
  OWL="../mapping/ontology.owl"
  OBDA="../mapping/mapping.obda"
  OUTPUT="../data/ontop/ontopMaterializedTriples.ttl"
  QUERY="SELECT ?S ?P ?O { ?S ?P ?O } "
  TTL="-ttl"
    
  tput setaf 2
  echo 
  echo " ######################################### "
  echo " ######## Info Generation ################ "
  echo " ----------------------------------------- "
  echo
  echo " ##  Script : $0                           " 
  echo
  echo " ##  OWL    : $OWL                         "
  echo " ##  OBDA   : $OBDA                        "
  echo " ##  OUTPUT : $OUTPUT                      "
  echo " ##  QUERY  : $QUERY                       "
  echo " ##  TTL    : $TTL                         "
  echo
  echo " ######################################### "
  echo 
  sleep 1
  tput setaf 7
	
  echo -e "\e[90m Strating Generation... \e[39m "
  echo
  
  cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
  
  java  -Xms1024M -Xmx2048M -cp ../libs/Ontop-Materializer.jar ontop.Main_1_17 \
  -owl  "$OWL"                                                                 \
  -obda "$OBDA"                                                                \
  -out  "$OUTPUT"                                                              \
  -q    "$QUERY"                                                               \
  $TTL
   
  echo
  echo -e "\e[36m Triples Generated in : $OUTPUT \e[39m "
  echo
        
  
