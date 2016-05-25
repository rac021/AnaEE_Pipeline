#!/bin/bash
    
  OWL="../Mapping/ontology.owl"
  TTL="../data/ontop/ontopMaterializedTriples.ttl"
  QUERY="select ?S ?P ?O { ?S ?P ?O } "
  OUTPUT="../data/corese"
    
  tput setaf 2
  echo 
  echo " ######################################### "
  echo " ######## Info Generation ################ "
  echo " ----------------------------------------- "
  echo
  echo " ##  Script : $0                           " 
  echo
  echo " ##  OWL    : $OWL                         "
  echo " ##  TTL    : $TTL                         "
  echo " ##  QUERY  : $QUERY                       "
  echo " ##  OUTPUT : $OUTPUT                      "
  echo
  echo " ######################################### "
  echo 
  sleep 1
  tput setaf 7
	
  echo -e "\e[90m Strating Generation... \e[39m "
  echo

  java -Xms1024M -Xmx2048M -cp ../libs/CoreseInfer.jar corese.Main \
  -owl $OWL                                                        \
  -nt  $TTL                                                        \
  -q   $QUERY                                                      \
  -out $OUTPUT                                                     \
  -f   100000                                                      \
  -ilv t                                                           \
  -F   n3 
      
    
  echo -e "\e[36m Triples Generated in : $OUTPUT \e[39m "
  echo
        
