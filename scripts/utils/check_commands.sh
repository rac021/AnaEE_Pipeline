#!/bin/bash

  tput setaf 2
  echo 
  echo -e " ################################# "
  echo -e " ######### Check Commands ######## "
  echo -e " --------------------------------- "
  echo -e " \e[90m$0        \e[32m            "
  echo
  sleep 1
  tput setaf 7
    
  command -v java >/dev/null 2>&1 || { 
     echo
     echo >&2 " Require JAVA but it's not installed.  Aborting. " ; 
     echo
     kill -9 `ps --pid $$ -oppid=` ; 
     exit
  }
  echo " java installed.. "
  sleep 0.4
   
  command -v curl >/dev/null 2>&1 || { 
     echo
     echo >&2 " Require CURL but it's not installed.  Aborting. " ; 
     echo
     kill -9 `ps --pid $$ -oppid=` ; 
     exit
  }
  echo " curl installed.. "
  sleep 0.4
  
  command -v psql >/dev/null 2>&1 || { 
     echo
     echo >&2 " Require POSTGRES but it's not installed.  Aborting. " ; 
     echo
     kill -9 `ps --pid $$ -oppid=` ; 
     exit
  }
  echo " postgres installed.. "
  sleep 0.4
  
  command -v mvn >/dev/null 2>&1 || { 
     echo
     echo >&2 " Require MAVEN but it's not installed.  Aborting. " ; 
     echo
     kill -9 `ps --pid $$ -oppid=` ; 
     exit
  }
  echo " maven installed.. "
  sleep 0.4
  
  command -v docker >/dev/null 2>&1 || { 
     echo
     echo >&2 " Require DOCKER but it's not installed.  Aborting. " ; 
     echo
     kill -9 `ps --pid $$ -oppid=` ; 
     exit
  }
  echo " docker installed.. "
  sleep 0.4
  
  echo
  
  
  
