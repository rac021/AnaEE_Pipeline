#!/bin/bash

# Default Traefik port : 8000


 CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
 cd $CURRENT_PATH
 
 cd ../libs/traefik

if [ "$1" = "start" ] ; then
  ./traefik --configFile=traefik.toml &
  sleep 1
  echo
  echo -e "\e[90m Blazegraph Load Balancer default frentend-route : http://client.blz.localhost:8000 \e[39m "
  echo
  echo -e " Dashboard \e[93m http://localhost:8081/dashboard \e[39m "
  echo

elif [ "$1" = "stop" ] ; then 
   pkill traefik
   
else
  echo
  echo " Invalid arguments :  Please pass One or One argument  "
  echo " arg_1             :  start - stop                     "
  echo

fi

