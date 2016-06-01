#!/bin/bash

    CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    NANO_END_POINT_FILE="$CURRENT_PATH/conf/nanoEndpoint"
    DATA_DIR="../data/corese"
    
    cd $CURRENT_PATH
    
    if [ -f $NANO_END_POINT_FILE ] ; then
    
        RW_PATTERN=":rw$"
        FIRST_END_POINT=`grep -m1 $RW_PATTERN $NANO_END_POINT_FILE`

        if [ -z $FIRST_END_POINT ] ; then 
           echo
           echo -e "\e[91m No EndPoint Read-Write mode found \e[39m "
           echo -e " \e[93m   -> $NANO_END_POINT_FILE \e[39m "
           echo
           exit 3
        fi
        
        IFS=’:’ read -ra INFO_NANO <<< "$FIRST_END_POINT" 
        NANO_END_POINT_IP=${INFO_NANO[1]}
        NANO_END_POINT_PORT=${INFO_NANO[2]}
         NANO_END_POINT_NAMESPACE=${INFO_NANO[3]}
         
        ENDPOINT="http://$NANO_END_POINT_IP:$NANO_END_POINT_PORT/bigdata/namespace/$NANO_END_POINT_NAMESPACE/sparql"
        
        echo ; echo -e " Try connection : $ENDPOINT "
        
        TRYING=50
        COUNT=0
        
        timeout 1 bash -c "cat < /dev/null > /dev/tcp/$NANO_END_POINT_IP/$NANO_END_POINT_PORT" 2> /dev/null
        
        OK=$?
        
        while [ $OK -ne 0 -a $COUNT -lt $TRYING  ] ;do
        
           timeout 1 bash -c "cat < /dev/null > /dev/tcp/$NANO_END_POINT_IP/$NANO_END_POINT_PORT" 2> /dev/null
           
           OK=$?
           
           if [ $COUNT == 0 ] ; then echo ; fi 
           
           if [ $OK == 1 ] ; then 
              echo " .. "
              sleep 0.4 
           elif [ $OK != 0 ] ; then 
              echo " attempt ( $COUNT ) : Try again.. "
              sleep 0.8
           fi
           
           let "COUNT++"
            
           if [ $COUNT == $TRYING ] ; then
              echo
              echo -e "\e[31m ENDPOINT $ENDPOINT Not reachable !! \e[39m"
              echo
              exit 3
           fi
           
        done
        
        RES=`curl -s -I $ENDPOINT | grep HTTP/1.1 | awk {'print $2'}`
        COUNT=0
        
         while [ $RES -ne 200 ] ;do
        
          sleep 1
          RES=`curl -s -I $ENDPOINT | grep HTTP/1.1 | awk {'print $2'}`
          let "COUNT++" 
           
          if [ $RES != 200 ] ; then 
             if [ `expr $COUNT % 3` -eq 0 ] ; then
                echo -e " attempt to join cluster on namespace $NANO_END_POINT_NAMESPACE .. "
             fi
          fi
           
        done
        
        echo " Yeah Connected !! "
        
        if [ ! -d $DATA_DIR ] ; then
           echo -e "\e[91m $DATA_DIR is not valid Directory ! \e[39m "
           exit 3
        fi
            
        # Remove a sparql file automatically created by blazegraph
        if [ -f "$DATA_DIR/sparql" ] ; then
          rm -f "$DATA_DIR/sparql"
        fi

        sleep 0.5  # Waits 0.5 second.

        cd $DATA_DIR
        
        tput setaf 2
        echo 
        echo -e " ######################################################## "
        echo -e " ######## Info Load Data ################################ "
        echo -e " -------------------------------------------------------- "
        echo -e " \e[90m$0       \e[32m                                    "
        echo
        echo -e " # ENDPOINT : $ENDPOINT                                   "
        echo
        echo -e " ######################################################## "
        echo 
        sleep 1
        tput setaf 7
        
        for FILE in `ls -a *.*`
          do
            echo " ---------------------                                                   "
            echo -e " \e[39m Upload file :\e[92m $DATA_DIR/$FILE \e[39m                    " 
            echo " ----------------------------------------------------------------------- "
            echo
            curl -D- -H 'Content-Type: text/turtle' --upload-file $FILE -X POST $ENDPOINT -O
            echo
            echo " ----------------------------------------------------------------------- "
        done
        
    else 
        
       echo " Oupss, config missed !! "
 
    fi
    
