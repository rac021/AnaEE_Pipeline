#!/bin/bash

    CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    HOSTS_FILE="$CURRENT_PATH/conf/hosts"
    STATUS_FILE="$CURRENT_PATH/conf/status"
    NANO_END_POINT_FILE="$CURRENT_PATH/conf/nanoEndpoint"
    
    IFS=':' read -a INFO_NANO <<< `cat $NANO_END_POINT_FILE`
    NANO_END_POINT_HOST=${INFO_NANO[0]}
    NANO_END_POINT_IP=${INFO_NANO[1]}
    NANO_END_POINT_PORT=${INFO_NANO[2]}
    NAME_SPACE=${INFO_NANO[3]}
    
    if [ "$1" = "start" ] ; then 
  
     if [ "$2" != "ro" ] && [ "$2" != "rw" ] ; then 
       echo
	   echo -e " \e[90m Must specify the starting Read-Write Mode : ro - rw "
	   echo
	   exit 2
	 fi 
        
     RW_MODE=$2
     
     STATUS=`cat $STATUS_FILE `
    
     if [ $STATUS = "1" ] ; then
        tput setaf 6
        echo
        echo " Cluster should be running ... ? "
        echo " if you are sure that the Cluster is DOWN, you can turn STATUS in the "
        echo " file $STATUS_FILE "
        echo " to 0 to and then try to retstart it "
        echo " or just STOP and START Cluster "
        echo
        tput setaf 7
        exit 3
     fi
        tput setaf 2
        echo 
        echo "##################################### "
        echo "######## Starting Cluster ########### "
        echo "------------------------------------- "
        tput setaf 7
        sleep 2
      
        echo -e " \e[90m Cluster List ** "
        echo -e " \e[90m $HOSTS_FILE "
        echo
        
        for node in $(cat $HOSTS_FILE)  
        do
            tput setaf 6
            echo " -> Starting Bigdata on Node $node "
            sleep 2
            tput setaf 7
            docker exec -d $node ./bigdata start
            echo
            sleep 4
        done 
        
        tput setaf 2
        echo 
        echo " => Running nanoSparqlServer  ~ 10 s   "
        tput setaf 7

        echo -e "  \e[90m nanoEndpoint List ** "
        echo -e "  \e[90m $NANO_END_POINT_FILE "
        echo    
        tput setaf 7
        sleep 10
        
        docker exec -dit $NANO_END_POINT_HOST ./nanoSparqlServer.sh $NANO_END_POINT_PORT $NAME_SPACE $RW_MODE
        
        echo "serviceURL: http://$IP:$NANO_END_POINT_PORT"
	echo "1" > $STATUS_FILE
        echo  
        #IP=`docker inspect --format '{{ .NetworkSettings.Networks.mynet123.IPAddress }}' blz_host_2`
        # docker logs -f $NANO_END_POINT_HOST
        
    elif [ "$1" = "stop" ] ; then 

        tput setaf 2
        echo 
        echo "##################################### "
        echo "######## Stopping Cluster ########### "
        echo "------------------------------------- "
        tput setaf 7
        sleep 2
        
        echo -e " \e[90m Cluster List ** "
        echo -e " \e[90m $HOSTS_FILE "
        
        for node in $(cat $HOSTS_FILE)  
        do
            tput setaf 6
            echo 
            echo " -> Stopping Node $node "
            tput setaf 7

            STOP=`docker exec -dit $node  /bin/sh -c "./bigdata stop "`
            
            sleep 3
        done
        
        echo "0" > $STATUS_FILE
        echo
        
    else
        echo " Invalid arguments :  Please pass One or Two arguments      "
        echo " arg_1             :  start - stop                          "
        echo " arg_2             :  Only if arg_1 = start, then : ro - rw "
    fi
