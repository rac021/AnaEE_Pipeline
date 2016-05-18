#!/bin/bash

docker rmi -f $(docker images)

docker build -t blazegraph .
