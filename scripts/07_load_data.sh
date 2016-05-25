#!/bin/bash

    CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    
    NANO_END_POINT_FILE="$CURRENT_PATH/conf/nanoEndpoint"

    
    if [ -f $NANO_END_POINT_FILE ] ; then
    
        FIRST_END_POINT=$(head -n 1 $NANO_END_POINT_FILE )
        
        IFS=’:’ read -ra INFO_NANO <<< "$FIRST_END_POINT" 
        NANO_END_POINT_HOST=${INFO_NANO[0]}
        NANO_END_POINT_IP=${INFO_NANO[1]}
        NANO_END_POINT_PORT=${INFO_NANO[2]}
        NAME_SPACE=${INFO_NANO[3]}
        
        
        else 
        
        echo " Oupss, config missed ! "
    fi
    

    
