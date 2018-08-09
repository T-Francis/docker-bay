#!/bin/bash

#
# DEPLOY JOBS

# deploy starter container traefik,portainer
function starterDeploy() {
    # deploying treafik at first since it's front proxy
    cd ~/docker-bay/services/traefik/ && docker-compose up -d 
    # deploying portainer
    cd ~/docker-bay/services/portainer/ && docker-compose up -d
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
    else
        echo "$1 is not a valid mode"
        exit 1
    fi
    # returning to the original directory
    cd $originalDirectory

fi
