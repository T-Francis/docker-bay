#!/bin/bash

#
# DEPLOY JOBS

# deploy starter container traefik,portainer
function starterDeploy() {
    # deploying treafik at first since it's front proxy
    cd ~/docker-bay/containers/traefik/ && docker-compose up -d 
    # deploying portainer
    cd ~/docker-bay/containers/portainer/ && docker-compose up -d
}

# deploy extra container such as sgbd's, adminer, redis...
function deployExtra() {
    # deploying sgbd's containers
    cd ~/docker-bay/containers/mysql/ && docker-compose up -d

    cd ~/docker-bay/containers/mariadb/ && docker-compose up -d

    cd ~/docker-bay/containers/redis/ && docker-compose up -d

    cd ~/docker-bay/containers/nodejs/sample-container/ && docker-compose up -d

    # deploy adminer to have a fast and easy access to the database
    cd ~/docker-bay/containers/adminer/ && docker-compose up -d
}

#  
#  RUN JOB
#  runnin jobs regarding selection

mode=$1
originalDirectory=`pwd`

if [ -d "~/docker-bay" ];then
    echo "~/docker-bay not found, exiting.."

else

    if [ "$1" == "starter" ];then
        starterDeploy
    elif [ "$1" == "full" ];then
        starterDeploy
        deployExtra
    else
        echo "$1 is not a valid mode"
        exit 1
    fi
    # returning to the original directory
    cd $originalDirectory

fi
