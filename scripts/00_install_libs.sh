#!/bin/bash

rootPath=`pwd`
directoryInstall="libs"
tmp="tmp"

if [ -d "$directoryInstall" ] ; then
mkdir $directoryInstall
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


git clone https://github.com/rac021/obdaYedGen-3.14.2.git $directoryInstall/$tmp
cd $rootPath/$directoryInstall/$tmp
mvn clean install assembly:single 
mv $rootPath/$directoryInstall/$tmp/target/YedODBA-3.14.2-1.0-SNAPSHOT-jar-with-dependencies.jar \
   $rootPath/$directoryInstall/YedODBA.jar

rm -rf $rootPath/$directoryInstall/$tmp/* $rootPath/$directoryInstall/$tmp/.git

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

git clone https://github.com/rac021/ontop-matarializer.git $rootPath/$directoryInstall/$tmp
cd $rootPath/$directoryInstall/$tmp
mvn clean install assembly:single
mv $rootPath/$directoryInstall/$tmp/target/ontop-materializer-1.17.0-jar-with-dependencies.jar \
   $rootPath/$directoryInstall/ontop-materializer.jar

rm -rf $rootPath/$directoryInstall/$tmp/* $rootPath/$directoryInstall/$tmp/.git


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

git clone https://github.com/rac021/CoreseInfer.git $rootPath/$directoryInstall/$tmp
cd $rootPath/$directoryInstall/$tmp
mvn clean install assembly:single
mv $rootPath/$directoryInstall/$tmp/target/CoreseInferMaven-1.0.0-jar-with-dependencies.jar \
   $rootPath/$directoryInstall/CoreseInfer.jar

rm -rf $rootPath/$directoryInstall/$tmp/* $rootPath/$directoryInstall/$tmp/.git


#########################
#### Clean tmp folder ###
#########################

rm -rf $rootPath/$directoryInstall/$tmp/

tput setaf 2
echo ""
echo "#########################"
echo "###  install success  ###"
echo "#########################"
echo ""
sleep 2
tput setaf 7

