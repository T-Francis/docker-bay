#!/bin/bash

#
# DOCKER JOBS

# docker dialog
function dockerDialog {
ret=""
while read -p 'Do you want install docker for DEBIAN-stretch or UBUNTU-16.04 (enter debian/ubuntu) or quit : ' dist ; do
    case $dist in
        "Debian" | "debian" | "deb")
            ret=1
            echo "$ret"
            exit 0
            ;;
        "Ubuntu" | "ubuntu" | "ubu")
            ret=2
            echo "$ret"
            exit 0
            ;;
        "Quit" | "quit" | "q")  
            ret=0
            echo "$ret"
            exit 0
            ;;
        *)
            ;;
    esac
done

}

# docker install
function installDocker {
distrib=$1

    if [ $distrib == "debian" ]
    then

        doUpdateAndUpgrade

        sudo apt-get install apt-transport-https -y
        sudo apt-get install ca-certificates -y
        sudo apt-get install curl -y
        sudo apt-get install gnupg2 -y
        sudo apt-get install software-properties-common -y

        curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo apt-key add -

        sudo add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
        $(lsb_release -cs) \
        stable"

        doUpdateAndUpgrade

        sudo apt-get install docker-ce -y

        sudo docker run hello-world

    elif [ $distrib == "ubuntu" ]
    then
        echo "need ubuntu process"
    else
       echo "none, need handle error"
    fi
}

# docker as global dialog
function dockerForUserDialog {
ret=""
while read -p 'Do you want to install docker for user ?(y/n) : ' res; do
    case $res in
        "Yes" | "yes" | "y")
            ret=1
            echo "$ret"
            exit 0
            ;;
        "No" | "no" | "n")
            ret=0
            echo "$ret"
            exit 0
            ;;
        *)
            ;;
    esac
done
}

# global docker permission || #TODO=> fix it! broken, if chown and chmod not done, didn't get permissions, got permission  if done, but return error, try to fix
function dockerForUser {
userName=$1

    sudo groupadd docker
    sudo usermod -aG docker $userName
    sudo mkdir /home/$userName/.docker
    sudo chown "$userName":"$userName" /home/"$userName"/.docker -R
    sudo chmod g+rwx "/home/$userName/.docker" -R

    echo -e "\n#################################\nYou should consider about log out and log in in order to get active permission\n"
    read -n 1 -s -r -p 'got it! (press a key)'
    echo -e "\n"

}

#docker-compose installation
function dockerUserNameDialog {
confirm=0
while [ $confirm -eq 0 ]; do
    read -p 'Please enter the username you want give the docker power : ' userName
    read -p "Do you confirm the username : $userName  ? (y/n) : " confirm
        case $confirm in
        "Yes" | "yes" | "y")
            confirm=1
            echo "$userName"
            exit 0
            ;;
        "No" | "no" | "n")
            confirm=0
            ;;
        *)
            confirm=0
            ;;
    esac
done
}

#
# DOCKER COMPOSE JOBS

#docker-compose dialog
function dockerComposeDialog {
ret=""
while read -p 'Do you want to install docker-compose ? (y/n) : ' compose; do
    case $compose in
        "Yes" | "yes" | "y")
            ret=1
            echo "$ret"
            exit 0
            ;;
        "No" | "no" | "n")
            ret=0
            echo "$ret"
            exit 0
            ;;
        *)
            ;;
    esac
done
}

#docker-compose installation
function dockerComposeInstall {

    doUpdateAndUpgrade
    sudo curl -L https://github.com/docker/compose/releases/download/1.19.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    # docker-compose --version

}

#
#  BASIC 

#Do and apt update and upgrade
function doUpdateAndUpgrade {
    sudo apt -y update && sudo apt -y upgrade
}


#  
#  RUN DIALOG

# we run dialog about installation
dockerDialog=$( dockerDialog )
dockerComposeDialog=$( dockerComposeDialog )
dockerForUserDialog=$( dockerForUserDialog )

#run a dialog for userName if docker for user was choose
if [ $dockerForUserDialog -eq 1 ]
then
    dockerUserName=$( dockerUserNameDialog )
fi

#  
#  RUN JOB
#  runnin jobs regarding selection

if [ $dockerDialog -eq 0 ] && [ $dockerComposeDialog -eq 0 ] && [ $dockerForUserDialog -eq 0 ]
then
     echo -e "Nothing to do here !\nSee you around..."
else

    # we running a basic update and upgrade
    doUpdateAndUpgrade

    #Docker case if dialog result was 0; no install, else 1 debian, 2 ubuntu
    if [ $dockerDialog -eq 0 ]
    then
        echo "docker wont be installed"
    elif [ $dockerDialog -eq 1 ]
    then
        installDocker "debian"
    elif [ $dockerDialog -eq 2 ]
    then
        installDocker "ubuntu"
    fi

    #Docker-compose case result was 0; no install, else 1 install
    if [ $dockerComposeDialog -eq 0 ]
    then
        echo "Compose wont be installed"
    elif [ $dockerComposeDialog -eq 1 ]
    then
        dockerComposeInstall
    fi

    #docker as global case result was 0; no install, else 1 install
    if [ $dockerForUserDialog -eq 0 ]
    then
        echo "docker power wont be give to any one"
    elif [ $dockerForUserDialog -eq 1 ]
    then
        dockerForUser $dockerUserName
    fi

fi

