#!/bin/bash
  
  INPUT=${1:-"../data/yedGen"} 
  OUTPUT=${2:-"../mapping/mapping.obda"}
  EXTENSION=${3:-".graphml"}
  
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
  echo -e " ######################################### "
  echo -e " ######## Info Generation ################ "
  echo -e " ----------------------------------------- "
  echo -e "\e[90m$0         \e[32m                    "
  echo
  echo -e " ##  INPUT     : $INPUT                    "
  echo -e " ##  EXTENTION : $EXTENSION                "
  echo
  echo -e " ##  OUTPUT    : $OUTPUT                   "
  echo
  echo -e " ######################################### "
  echo 
  sleep 1
  tput setaf 7

  cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

  if [ ! -d $INPUT ] ; then
     echo -e "\e[91m $INPUT is not a valid Directory ! \e[39m "
     EXIT
  fi

  echo -e "\e[90m Strating Generation... \e[39m "
  
  java -cp ../libs/yedGen.jar Main -d $INPUT -out $OUTPUT -ext $EXTENSION

  echo -e "\e[36m Mapping generated in : $OUTPUT \e[39m "
  echo
  
