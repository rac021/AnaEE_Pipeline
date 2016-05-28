#!/bin/bash
    
  INPUT="../data/yedGen"
  OUTPUT="../mapping/mapping.obda"
  EXTENSION=".graphml"
   
  tput setaf 2
  echo 
  echo " ######################################### "
  echo " ######## Info Generation ################ "
  echo " ----------------------------------------- "
  echo
  echo " ##  Script    : $0                        " 
  echo " ##  INPUT     : $INPUT                    "
  echo " ##  EXTENTION : $EXTENSION                "
  echo
  echo " ##  OUTPUT    : $OUTPUT                   "
  echo
  echo " ######################################### "
  echo 
  sleep 1
  tput setaf 7

  cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

  if [ ! -d $INPUT ] ; then
     echo -e "\e[91m $INPUT is not a valid Directory ! \e[39m "
     exit 3
  fi

  echo -e "\e[90m Strating Generation... \e[39m "
  
  java -cp ../libs/yedGen.jar Main -d $INPUT -out $OUTPUT -ext $EXTENSION

  echo -e "\e[36m Mapping generated in : $OUTPUT \e[39m "
  echo
  
