#!/bin/bash

    CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    DATA_DIR="../data/corese"
    
    cd $CURRENT_PATH
    
    IP='172.17.0.1'
    PORT='9999'
    NAMESPACE='kb'
   
    ENDPOINT="http://$IP:$PORT/blazegraph/namespace/$NAMESPACE/sparql"
    #ENDPOINT="http://147.99.222.28:8080/blazegraph/namespace/kb/sparql"
        
    # test connexion ola 
    check="cat < /dev/null > /dev/tcp/http://$IP/$PORT"
      
    echo ; echo -e " Try connection : $ENDPOINT "
        
    TRYING=50
    COUNT=0
        
    timeout 1 bash -c "cat < /dev/null > /dev/tcp/$IP/$PORT" 2> /dev/null
        
      OK=$?
        
      while [ $OK -ne 0 -a $COUNT -lt $TRYING  ] ;do
        
         timeout 1 bash -c "cat < /dev/null > /dev/tcp/$IP/$PORT" 2> /dev/null
           
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
        
         while  [ -z $RES ] || [ $RES -ne 200 ] ;do
        
          sleep 1
          RES=`curl -s -I $ENDPOINT | grep HTTP/1.1 | awk {'print $2'}`
          let "COUNT++" 
           
          if  [ -z $RES ] || [ $RES -ne 200 ] ; then 
              if [ `expr $COUNT % 3` -eq 0 ] ; then
                 echo -e " attempt to join $ENDPOINT .. "
              fi
          fi
           
        done
       
        echo " Yeah Connected !! "
        
        if [ ! -d $DATA_DIR ] ; then
           echo -e "\e[91m $DATA_DIR is not valid Directory ! \e[39m "
           exit 3
        fi
            
        # Remove the sparql file automatically created by blazegraph
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
        
   
    
