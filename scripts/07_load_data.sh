#!/bin/bash

    CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    NANO_END_POINT_FILE="$CURRENT_PATH/conf/nanoEndpoint"
    DATA_DIR="../data/corese"
    
    if [ -f $NANO_END_POINT_FILE ] ; then
    
        FIRST_END_POINT=$(head -n 1 $NANO_END_POINT_FILE )

        IFS=’:’ read -ra INFO_NANO <<< "$FIRST_END_POINT" 
        NANO_END_POINT_IP=${INFO_NANO[1]}
        NANO_END_POINT_PORT=${INFO_NANO[2]}
            
        ENDPOINT="http://$NANO_END_POINT_IP:$NANO_END_POINT_PORT/bigdata/sparql"
    
        timeout 1 bash -c "cat < /dev/null > /dev/tcp/$NANO_END_POINT_IP/$NANO_END_POINT_PORT" 2> /dev/null
         
         if [ $? != 0 ] ; then 
          echo
          echo -e " \e[31m ENDPOINT $ENDPOINT Not reachable !! \e[39m"
          echo
          exit 3
         fi 

        # Remove a sparql file automaticly created by blazegraph
        if [ -f "$DATA_DIR/sparql" ] ; then
          rm -f "$DATA_DIR/sparql"
        fi

        sleep 1  # Waits 1 second.

        cd $DATA_DIR
        
        for FILE in `ls -a *.*`
          do
            echo "---------------------"
            echo -e "\e[39m Upload file :\e[92m $FILE \e[39m " 
            echo "---------------------"
            curl -D- -H 'Content-Type: text/turtle' --upload-file $FILE -X POST $ENDPOINT -O
            echo "---------------------"
        done
        
    else 
        
       echo " Oupss, config missed !! "
 
    fi
    
