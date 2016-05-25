#!/bin/bash

    CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    
    NANO_END_POINT_FILE="$CURRENT_PATH/conf/nanoEndpoint"

    
    if [ -f $NANO_END_POINT_FILE ] ; then
    
        FIRST_END_POINT=$(head -n 1 $NANO_END_POINT_FILE )
        echo "--> $FIRST_END_POINT "
        
        else 
        echo " Oupss, config missed ! "
    fi
    

    
