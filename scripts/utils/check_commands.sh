#!/bin/bash

  tput setaf 2
  echo 
  echo -e " ################################# "
  echo -e " ######### Check Commands ######## "
  echo -e " --------------------------------- "
  echo -e " \e[90m$0        \e[32m            "
  echo
  sleep 2
  tput setaf 7
    
  command -v java >/dev/null 2>&1 || { 
     echo
     echo >&2 " Require JAVA but it's not installed.  Aborting. " ; 
     echo
     exit 1 ;
  }
  echo " java installed.. "
  
  command -v curl >/dev/null 2>&1 || { 
     echo
     echo >&2 " Require CURL but it's not installed.  Aborting. " ; 
     echo
     exit 1 ;
  }
  echo " curl installed.. "
   
  command -v psql >/dev/null 2>&1 || { 
     echo
     echo >&2 " Require POSTGRES but it's not installed.  Aborting. " ; 
     echo
     exit 1 ;
  }
  echo " postgres installed.. "
   
  command -v mvn >/dev/null 2>&1 || { 
     echo
     echo >&2 " Require MAVEN but it's not installed.  Aborting. " ; 
     echo
     exit 1 ;
  }
  echo " maven installed.. "
   
  command -v docker >/dev/null 2>&1 || { 
     echo
     echo >&2 " Require DOCKER but it's not installed.  Aborting. " ; 
     echo
     exit 1 ;
  }
  echo " docker installed.. "
  
  
  
