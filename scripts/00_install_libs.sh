#!/bin/bash

echo
echo "Executing Script : $0 "
echo ""

CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CURRENT_DIRECTORY="scripts"
ROOT_PATH="${CURRENT_PATH/'/'$CURRENT_DIRECTORY/''}"

DIRECTORY_LIBS="libs"
DIRECTORY_DATA="data"
DIRECTORY_DATA_ONTOP="ontop"
DIRECTORY_DATA_CORESE="corese"
DIRECTORY_DATA_CONFIG="conf"
TMP="tmp"

if [ ! -d "$ROOT_PATH/$DIRECTORY_LIBS" ]; then
mkdir -p $ROOT_PATH/$DIRECTORY_LIBS
fi
if [ ! -d "$ROOT_PATH/$DIRECTORY_DATA" ]; then
mkdir -p $ROOT_PATH/$DIRECTORY_DATA
fi
if [ ! -d "$ROOT_PATH/$DIRECTORY_DATA/$DIRECTORY_DATA_ONTOP" ]; then
mkdir $ROOT_PATH/$DIRECTORY_DATA/$DIRECTORY_DATA_ONTOP
fi
if [ ! -d "$ROOT_PATH/$DIRECTORY_DATA/$DIRECTORY_DATA_CORESE" ]; then
mkdir -p $ROOT_PATH/$DIRECTORY_DATA/$DIRECTORY_DATA_CORESE
fi
if [ ! -d "$ROOT_PATH/$CURRENT_DIRECTORY/$DIRECTORY_DATA_CONFIG" ]; then
mkdir -p $ROOT_PATH/$CURRENT_DIRECTORY/$DIRECTORY_DATA_CONFIG
fi


#######################
#### Install yedGen ###
#######################

tput setaf 2
echo ""
echo "######################"
echo "### Install yedGen ###"
echo "######################"
echo ""
sleep 2
tput setaf 7

git clone https://github.com/rac021/obdaYedGen-3.14.2.git $DIRECTORY_LIBS/$TMP
cd $ROOT_PATH/$DIRECTORY_LIBS/$TMP
mvn clean install assembly:single 
mv $ROOT_PATH/$DIRECTORY_LIBS/$TMP/target/YedODBA-3.14.2-1.0-SNAPSHOT-jar-with-dependencies.jar \
   $ROOT_PATH/$DIRECTORY_LIBS/YedODBA.jar

rm -rf $ROOT_PATH/$DIRECTORY_LIBS/$TMP/* $ROOT_PATH/$DIRECTORY_LIBS/$TMP/.git

##################################
### Install Ontop-Materializer ###
##################################

tput setaf 2
echo ""
echo "##################################"
echo "### Install Ontop-Materializer ###"
echo "##################################"
echo ""
sleep 2
tput setaf 7

git clone https://github.com/rac021/ontop-matarializer.git $ROOT_PATH/$DIRECTORY_LIBS/$TMP
cd $ROOT_PATH/$DIRECTORY_LIBS/$TMP
mvn clean install assembly:single
mv $ROOT_PATH$DIRECTORY_LIBS/$TMP/target/ontop-materializer-1.17.0-jar-with-dependencies.jar \
   $ROOT_PATH/$directoryInstall/ontop-materializer.jar

rm -rf $ROOT_PATH/$DIRECTORY_LIBS/$TMP/* $ROOT_PATH/$DIRECTORY_LIBS/$TMP/.git


##################################
###### Install CoreseInfer #######
##################################

tput setaf 2
echo ""
echo "###########################"
echo "### Install CoreseInfer ###"
echo "###########################"
echo ""
sleep 2
tput setaf 7

git clone https://github.com/rac021/CoreseInfer.git $ROOT_PATH/$DIRECTORY_LIBS/$TMP
cd $ROOT_PATH/$DIRECTORY_LIBS/$TMP
mvn clean install assembly:single
mv $ROOT_PATH/$DIRECTORY_LIBS/$TMP/target/CoreseInferMaven-1.0.0-jar-with-dependencies.jar \
   $ROOT_PATH/$DIRECTORY_LIBS/CoreseInfer.jar

rm -rf $ROOT_PATH/$DIRECTORY_LIBS/$TMP/* $ROOT_PATH/$DIRECTORY_LIBS/$TMP/.git


#########################
#### Clean TMP folder ###
#########################

rm -rf $ROOT_PATH/$DIRECTORY_LIBS/$TMP/

tput setaf 2
echo ""
echo "#########################"
echo "###  install success  ###"
echo "#########################"
echo ""
sleep 2
tput setaf 7


