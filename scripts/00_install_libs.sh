#!/bin/bash

# DATABSE       : spql - mysql 
# TYPE_INSTALL  : demo - fullGraph - graphChunks - patternGraphChunks

if [ $# == 0 ] ; then
    DATA_BASE="psql"
    TYPE_INSTALL="demo"
elif [[ $# == 1 && $1 != "demo" && $1 != "fullGraph" && $1 != "graphChunks" &&  $1 != "patternGraphChunks" ]] ; then
    DATA_BASE=$1
    TYPE_INSTALL=${2:-"graphChunks"}
elif [[ $# == 1 && ( $1 == "demo" || $1 == "fullGraph" || $1 == "graphChunks" ||  $1 == "patternGraphChunks" ) ]] ; then
    DATA_BASE="psql"
    TYPE_INSTALL=$1
elif [ $# -eq 2 ] ; then
    DATA_BASE=$1
    TYPE_INSTALL=$2
fi

tput setaf 2
echo 
echo -e " ##################################### "
echo -e " ######### Info Install ############## "
echo -e " ------------------------------------- "
echo -e " \e[90m$0     \e[32m                   "
echo
echo -e " ##################################### "
echo 
sleep 2

CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CURRENT_DIRECTORY="scripts"
ROOT_PATH="${CURRENT_PATH/'/'$CURRENT_DIRECTORY/''}"

TMP="tmp_install"
DOCS="Docs"
EXAMPLES="Exemple"
DIRECTORY_LIBS="libs"
DIRECTORY_MAPPING="mapping"
DIRECTORY_DATA="data"
DIRECTORY_DATA_ONTOP="ontop"
DIRECTORY_DATA_CORESE="corese"
DIRECTORY_DATA_YEDGEN="yedGen"
DIRECTORY_DATA_CONFIG="conf"

# Do not touch the YEDGEN_COMPILE_NAME
YEDGEN_COMPILE_NAME="yedGen-1.0-SNAPSHOT-jar-with-dependencies.jar"
YEDGEN_TARGET_NAME="yedGen.jar"
YEDGEN_EXP_LOCATION="src/main/resources/*"

# Do not touch the ONTOP_COMPILE_NAME
ONTOP_COMPILE_NAME="ontop-materializer-1.18.0-jar-with-dependencies.jar "
ONTOP_TARGET_NAME="Ontop-Materializer.jar"
ONTOP_EXP_LOCATION="src/main/resources/mapping/*"

# Do not touch the CORESE_COMPILE_NAME
CORESE_COMPILE_NAME="CoreseInferMaven-1.0.0-jar-with-dependencies.jar "
CORESE_TARGET_NAME="CoreseInfer.jar"
CORESE_EXP_LOCATION="src/main/resources/*"

# Do not touch the CORESE_COMPILE_NAME
BLAZEGRAPH_LOCATION="Blazegraph"
BLAZEGRAPH_TARGET_NAME="Blazegraph_2.1.jar"
BLAZEGRAPG_INFO_INSTALL="BLZ_INFO_INSTALL"

# Each program has its own documentation located in 
# $DIRECTORY_LIBS/$DOCS/$DIRECTORY_DATA_ [ YEDGEN | ONTOP | CORESE ]
DOCUMENTATION_FILE_NAME="README.md"

# Do not touch the Traefik_reverse_proxy
Traefik_LOCATION="traefik"

if [ ! -d "$ROOT_PATH/$DIRECTORY_LIBS" ]; then
mkdir -p $ROOT_PATH/$DIRECTORY_LIBS
echo -e " \e[90m created folder : $ROOT_PATH/$DIRECTORY_LIBS \e[32m "
fi
if [ ! -d "$ROOT_PATH/$DIRECTORY_MAPPING" ]; then
mkdir -p $ROOT_PATH/$DIRECTORY_MAPPING
echo -e " \e[90m created folder : $ROOT_PATH/$DIRECTORY_MAPPING \e[32m "
fi
if [ ! -d "$ROOT_PATH/$DIRECTORY_DATA" ]; then
mkdir -p $ROOT_PATH/$DIRECTORY_DATA
echo -e " \e[90m created folder : $ROOT_PATH/$DIRECTORY_DATA \e[32m  "
fi
if [ ! -d "$ROOT_PATH/$DIRECTORY_LIBS/$DOCS" ]; then
mkdir -p $ROOT_PATH/$DIRECTORY_LIBS/$DOCS
echo -e " \e[90m created folder : $ROOT_PATH/$DIRECTORY_LIBS/$DOCS \e[32m  "
fi
if [ ! -d "$ROOT_PATH/$DIRECTORY_DATA/$DIRECTORY_DATA_ONTOP" ]; then
mkdir $ROOT_PATH/$DIRECTORY_DATA/$DIRECTORY_DATA_ONTOP
echo -e " \e[90m created folder : $ROOT_PATH/$DIRECTORY_DATA/$DIRECTORY_DATA_ONTOP \e[32m  "
fi
if [ ! -d "$ROOT_PATH/$DIRECTORY_DATA/$DIRECTORY_DATA_CORESE" ]; then
mkdir -p $ROOT_PATH/$DIRECTORY_DATA/$DIRECTORY_DATA_CORESE
echo -e " \e[90m created folder : $ROOT_PATH/$DIRECTORY_DATA/$DIRECTORY_DATA_CORESE \e[32m  "
fi
if [ ! -d "$ROOT_PATH/$DIRECTORY_DATA/$DIRECTORY_DATA_YEDGEN" ]; then
mkdir -p $ROOT_PATH/$DIRECTORY_DATA/$DIRECTORY_DATA_YEDGEN
echo -e " \e[90m created folder : $ROOT_PATH/$DIRECTORY_DATA/$DIRECTORY_DATA_YEDGEN \e[32m  "
fi
if [ ! -d "$ROOT_PATH/$CURRENT_DIRECTORY/$DIRECTORY_DATA_CONFIG" ]; then
mkdir -p $ROOT_PATH/$CURRENT_DIRECTORY/$DIRECTORY_DATA_CONFIG
echo -e " \e[90m created folder : $ROOT_PATH/$CURRENT_DIRECTORY/$DIRECTORY_DATA_CONFIG \e[32m  "
fi
if [ ! -d "$ROOT_PATH/$DIRECTORY_LIBS/$DOCS/$DIRECTORY_DATA_ONTOP" ]; then
mkdir -p $ROOT_PATH/$DIRECTORY_LIBS/$DOCS/$DIRECTORY_DATA_ONTOP
echo -e " \e[90m created folder : $ROOT_PATH/$DIRECTORY_LIBS/$DOCS/$DIRECTORY_DATA_ONTOP \e[32m  "
fi
if [ ! -d "$ROOT_PATH/$DIRECTORY_LIBS/$DOCS/$DIRECTORY_DATA_ONTOP/$EXAMPLES" ]; then
mkdir -p $ROOT_PATH/$DIRECTORY_LIBS/$DOCS/$DIRECTORY_DATA_ONTOP/$EXAMPLES
echo -e " \e[90m created folder : $ROOT_PATH/$DIRECTORY_LIBS/$DOCS/$DIRECTORY_DATA_ONTOP/$EXAMPLES \e[32m  "
fi
if [ ! -d "$ROOT_PATH/$DIRECTORY_LIBS/$DOCS/$DIRECTORY_DATA_CORESE" ]; then
mkdir -p $ROOT_PATH/$DIRECTORY_LIBS/$DOCS/$DIRECTORY_DATA_CORESE
echo -e " \e[90m created folder : $ROOT_PATH/$DIRECTORY_LIBS/$DOCS/$DIRECTORY_DATA_CORESES \e[32m  "
fi
if [ ! -d "$ROOT_PATH/$DIRECTORY_LIBS/$DOCS/$DIRECTORY_DATA_CORESE/$EXAMPLES" ]; then
mkdir -p $ROOT_PATH/$DIRECTORY_LIBS/$DOCS/$DIRECTORY_DATA_CORESE/$EXAMPLES
echo -e " \e[90m created folder : $ROOT_PATH/$DIRECTORY_LIBS/$DOCS/$DIRECTORY_DATA_CORESE/$EXAMPLES \e[32m  "
fi
if [ ! -d "$ROOT_PATH/$DIRECTORY_LIBS/$DOCS/$DIRECTORY_DATA_YEDGEN" ]; then
mkdir -p $ROOT_PATH/$DIRECTORY_LIBS/$DOCS/$DIRECTORY_DATA_YEDGEN
echo -e " \e[90m created folder : $ROOT_PATH/$DIRECTORY_LIBS/$DOCS/$DIRECTORY_DATA_YEDGE \e[32m  "
fi
if [ ! -d "$ROOT_PATH/$DIRECTORY_LIBS/$DOCS/$DIRECTORY_DATA_YEDGEN/$EXAMPLES" ]; then
mkdir -p $ROOT_PATH/$DIRECTORY_LIBS/$DOCS/$DIRECTORY_DATA_YEDGEN/$EXAMPLES
echo -e " \e[90m created folder : $ROOT_PATH/$DIRECTORY_LIBS/$DOCS/$DIRECTORY_DATA_YEDGEN/$EXAMPLES \e[32m  "
fi
if [ ! -d "$ROOT_PATH/$DIRECTORY_LIBS/$BLAZEGRAPH_LOCATION" ]; then
mkdir -p $ROOT_PATH/$DIRECTORY_LIBS/$BLAZEGRAPH_LOCATION
echo -e " \e[90m created folder : $ROOT_PATH/$DIRECTORY_LIBS/$BLAZEGRAPH_LOCATION \e[32m  "
fi
if [ ! -d "$ROOT_PATH/$DIRECTORY_LIBS/$Traefik_LOCATION" ]; then
mkdir -p $ROOT_PATH/$DIRECTORY_LIBS/$Traefik_LOCATION
echo -e " \e[90m created folder : $ROOT_PATH/$DIRECTORY_LIBS/$Traefik_LOCATION \e[32m  "
fi

rm -rf $ROOT_PATH/$DIRECTORY_LIBS/$TMP

#######################
#### Install yedGen ###
#######################

tput setaf 2
echo 
echo " ###########################"
echo " ##### Install yedGen ######"
echo " ###########################"
echo 
sleep 2
tput setaf 7

git clone https://github.com/rac021/yedGen.git $ROOT_PATH/$DIRECTORY_LIBS/$TMP

cd $ROOT_PATH/$DIRECTORY_LIBS/$TMP

mvn clean install assembly:single 

echo 

mv -fv $ROOT_PATH/$DIRECTORY_LIBS/$TMP/target/$YEDGEN_COMPILE_NAME \
       $ROOT_PATH/$DIRECTORY_LIBS/$YEDGEN_TARGET_NAME

mv -fv $ROOT_PATH/$DIRECTORY_LIBS/$TMP/$YEDGEN_EXP_LOCATION \
       $ROOT_PATH/$DIRECTORY_LIBS/$DOCS/$DIRECTORY_DATA_YEDGEN/$EXAMPLES

mv -fv $ROOT_PATH/$DIRECTORY_LIBS/$TMP/$DOCUMENTATION_FILE_NAME \
       $ROOT_PATH/$DIRECTORY_LIBS/$DOCS/$DIRECTORY_DATA_YEDGEN

# cp -R $ROOT_PATH/$DIRECTORY_LIBS/$DOCS/$DIRECTORY_DATA_YEDGEN/$EXAMPLES/* \
#       $ROOT_PATH/$DIRECTORY_DATA/$DIRECTORY_DATA_YEDGEN

# demo - fullGraph - graphChunks - patternGraphChunks
 
if   [ $TYPE_INSTALL == "demo" ] ; then 

  cp -rf $ROOT_PATH/$DIRECTORY_LIBS/$DOCS/$DIRECTORY_DATA_YEDGEN/$EXAMPLES/demo/*.* \
         $ROOT_PATH/$DIRECTORY_DATA/$DIRECTORY_DATA_YEDGEN

elif [ $TYPE_INSTALL == "graphChunks" ] ; then 

  cp -rf $ROOT_PATH/$DIRECTORY_LIBS/$DOCS/$DIRECTORY_DATA_YEDGEN/$EXAMPLES/ola_mapping/graphChunks/* \
         $ROOT_PATH/$DIRECTORY_DATA/$DIRECTORY_DATA_YEDGEN

elif [ $TYPE_INSTALL == "patternGraphChunks" ] ; then 
              
  cp -rf $ROOT_PATH/$DIRECTORY_LIBS/$DOCS/$DIRECTORY_DATA_YEDGEN/$EXAMPLES/ola_mapping/patternGraphChunks/* \
         $ROOT_PATH/$DIRECTORY_DATA/$DIRECTORY_DATA_YEDGEN
         
elif [ $TYPE_INSTALL == "fullGraph" ] ; then 

  cp -rf $ROOT_PATH/$DIRECTORY_LIBS/$DOCS/$DIRECTORY_DATA_YEDGEN/$EXAMPLES/ola_mapping/fullGraph/byCategory/physicochimie/dissolvedAmmoniumNitrogenMassConcentration/*.* \
         $ROOT_PATH/$DIRECTORY_DATA/$DIRECTORY_DATA_YEDGEN
fi

rm -rf $ROOT_PATH/$DIRECTORY_LIBS/$TMP/* $ROOT_PATH/$DIRECTORY_LIBS/$TMP/.git

##################################
### Install Ontop-Materializer ###
##################################

tput setaf 2
echo "                                    "
echo " ################################## "
echo " ### Install Ontop-Materializer ### "
echo " ################################## "
echo "                                    "

if [ "$DATA_BASE" != "" ] ; then 
  echo -e "\e[90m Database : $DATA_BASE  \e[32m "
else
  echo -e "\e[90m Database : porstgreSQL \e[32m "
fi

echo
 
sleep 2
tput setaf 7

git clone https://github.com/rac021/ontop-matarializer.git $ROOT_PATH/$DIRECTORY_LIBS/$TMP

cd $ROOT_PATH/$DIRECTORY_LIBS/$TMP

 if [ "$DATA_BASE" != "" ] ; then 
     mvn -P $DATA_BASE clean install assembly:single
 else 
     # Postresql as default database
     mvn clean install assembly:single
 fi

echo

mv -fv $ROOT_PATH/$DIRECTORY_LIBS/$TMP/target/$ONTOP_COMPILE_NAME \
       $ROOT_PATH/$DIRECTORY_LIBS/$ONTOP_TARGET_NAME
      
mv -fv $ROOT_PATH/$DIRECTORY_LIBS/$TMP/$ONTOP_EXP_LOCATION \
       $ROOT_PATH/$DIRECTORY_LIBS/$DOCS/$DIRECTORY_DATA_ONTOP/$EXAMPLES
  
mv -fv $ROOT_PATH/$DIRECTORY_LIBS/$TMP/$DOCUMENTATION_FILE_NAME \
       $ROOT_PATH/$DIRECTORY_LIBS/$DOCS/$DIRECTORY_DATA_ONTOP
  
cp -fr  $ROOT_PATH/$DIRECTORY_LIBS/$DOCS/$DIRECTORY_DATA_ONTOP/$EXAMPLES/ontology.owl \
        $ROOT_PATH/$DIRECTORY_MAPPING/ 
   
rm -rf  $ROOT_PATH/$DIRECTORY_LIBS/$TMP/* $ROOT_PATH/$DIRECTORY_LIBS/$TMP/.git

##################################
###### Install CoreseInfer #######
##################################

tput setaf 2
echo 
echo " ########################### "
echo " ### Install CoreseInfer ### "
echo " ########################### "
echo 
sleep 2
tput setaf 7

git clone https://github.com/rac021/CoreseInfer.git $ROOT_PATH/$DIRECTORY_LIBS/$TMP

cd $ROOT_PATH/$DIRECTORY_LIBS/$TMP

mvn clean install assembly:single

echo

mv -fv $ROOT_PATH/$DIRECTORY_LIBS/$TMP/target/$CORESE_COMPILE_NAME \
       $ROOT_PATH/$DIRECTORY_LIBS/$CORESE_TARGET_NAME

# mv -v $ROOT_PATH/$DIRECTORY_LIBS/$TMP/$CORESE_EXP_LOCATION \
#      $ROOT_PATH/$DIRECTORY_LIBS/$DOCS/$DIRECTORY_DATA_CORESE/$EXAMPLES

mv -fv $ROOT_PATH/$DIRECTORY_LIBS/$TMP/$DOCUMENTATION_FILE_NAME \
       $ROOT_PATH/$DIRECTORY_LIBS/$DOCS/$DIRECTORY_DATA_CORESE

rm -rf $ROOT_PATH/$DIRECTORY_LIBS/$TMP/* $ROOT_PATH/$DIRECTORY_LIBS/$TMP/.git


#############################################
###### Install Traefik_reverse_proxy ########
#############################################

tput setaf 2
echo 
echo " ##################################### "
echo " ### Install Traefik reverse proxy ### "
echo " ##################################### "
echo 
sleep 2
tput setaf 7

git clone https://github.com/rac021/Traefik_reverse_proxy.git $ROOT_PATH/$DIRECTORY_LIBS/$Traefik_LOCATION 

#########################
#### Clean TMP folder ###
#########################

rm -rf $ROOT_PATH/$DIRECTORY_LIBS/$TMP/


tput setaf 2
echo 
echo " ###  install success  ########## "
echo 
sleep 2
tput setaf 7

