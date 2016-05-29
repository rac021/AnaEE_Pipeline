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
            
        ENDPOINT="http://$NANO_END_POINT_IP:$NANO_END_POINT_PORT/bigdata/sparql"
        
        echo ;echo -e " Try connection : $ENDPOINT "
        
        TRYING=5
        
        for (( COUNT=1; COUNT<=$TRYING; COUNT++ )) ; do
        
            timeout 1 bash -c "cat < /dev/null > /dev/tcp/$NANO_END_POINT_IP/$NANO_END_POINT_PORT" 2> /dev/null
           
            if [ $? != 0 ] ; then 
               
              if [ $COUNT == 1 ] ; then echo ; fi 
               
              echo " attempt $COUNT : Try again .. "
              if [ $COUNT == $TRYING ] ; then
                echo
                echo -e "\e[31m ENDPOINT $ENDPOINT Not reachable !! \e[39m"
                echo
                exit 3
              fi
            else 
              break
            fi 
        
        done
        
        if [ ! -d $DATA_DIR ] ; then
             echo -e "\e[91m $DATA_DIR is not valid Directory ! \e[39m "
             exit 3
        fi
            
        # Remove a sparql file automatically created by blazegraph
        if [ -f "$DATA_DIR/sparql" ] ; then
          rm -f "$DATA_DIR/sparql"
        fi

        sleep 1  # Waits 1 second.

        cd $DATA_DIR
        
        tput setaf 2
        echo 
        echo -e " ######################################################## "
        echo -e " ######## Info Load Data ################################ "
        echo -e " -------------------------------------------------------- "
        echo -e " \e[90m$0       \e[32m                    "
        echo
        echo -e " # ENDPOINT : $ENDPOINT                   "
        echo
        echo -e " ######################################################## "
        echo 
        sleep 1
        tput setaf 7
        
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
    
