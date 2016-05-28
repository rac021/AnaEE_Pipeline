#!/bin/bash
    
  OWL="../mapping/ontology.owl"
  TTL="../data/ontop/ontopMaterializedTriples.ttl"
  QUERY=" SELECT ?S ?P ?O { ?S ?P ?O } "
  OUTPUT="../data/corese"
  f="100000"
  F="n3"
  ilt="t"
  
  tput setaf 2
  echo 
  echo " ######################################### "
  echo " ######## Info Generation ################ "
  echo " ----------------------------------------- "
  echo
  echo " ##  Script   : $0                         " 
  echo
  echo " ##  OWL      : $OWL                       "
  echo " ##  TTL      : $TTL                       "
  echo " ##  QUERY    : $QUERY                     "
  echo " ##  OUTPUT   : $OUTPUT                    "
  echo " ##  FORMAT   : $F                         "
  echo " ##  FRAGMENT : $f                         "
  
  echo
  echo " ######################################### "
  echo 
  sleep 1
  tput setaf 7
	
  echo -e "\e[90m Strating Generation... \e[39m "
  echo

  java -Xms1024M -Xmx2048M -cp ../libs/CoreseInfer.jar corese.Main \
  -owl "$OWL"                                                      \
  -nt  "$TTL"                                                      \
  -q   "$QUERY"                                                    \
  -out "$OUTPUT"                                                   \
  -f   "$f"                                                        \
  -ilv "$ilt"                                                      \
  -F   "$F" 
   
  echo -e "\e[36m Triples Generated in : $OUTPUT \e[39m "
  echo
        
