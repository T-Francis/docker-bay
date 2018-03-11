# **Welcome to the docker-bay**

**What is it ?**

The goal of this project is to bring a diverse development environnement with multiple stack without being annoyed by version conflict and stuff.

The other part is having fun using some cool technologies :)

**What it does ?**

It build for you a docker playground mainly from compilation of other projects as core and some simplification or custom config.

**Disclaimer**

This project is made to have a basic usage of powerfull tool with a progressive learning curve and finally end with a better knowledge about used technologies.

Most of homemade script are just basic shortcurt and rewriting of native features and the portainer templates system need to be more exploited.

Since it's a side hand project and mainly a sandbox no support will given *NOT MADE FOR USAGE OUSTSIDE A DEVELOPMENT BOX*

*happy coding !*

# **Get Started**

## Clone the repo and source the script

```bash
git clone https://github.com/T-Francis/docker-bay.git ~/docker-bay \
    && printf '\n# Sourcing the docker-bay bash \n. ~/docker-bay/.dockerbay/dockerbay_bash\n' >> ~/.bashrc
```

It will clone **docker-bay** repository into the current-user `/home` and add the `dockerbay.sh` as source in the bashrc

Log out & log in of terminal to refresh bashrc source and access  the `dockerbay.sh` 

***

### A) *Start from a fresh debian/ubuntu install and lazy to install stuff ?*

Check :
-  **[Lazy install](#lazy-install-docker-install)** for an automated docker install (require root/sudo) 
-  **[Lazy deploy](#lazy-deploy-docker-bay-deployement)** for an automated docker-bay deployment

### B) *Already have docker & docker-compose ?*

This project run actually with **docker v17.12.0-ce build c97c6d6**  &  **docker-compose  v1.19.0, build 8dd22a9**

Maybe check version and ready to go !

```bash
# Get docker and compose versions
docker --version && docker-compose --version
```
 
# **Lazy install** 
(docker install ans docker-compose installation)

If you just installed your *debian-9* or *ubuntu-16.04*

```bash
dockerbay-install-docker 
```
It run the installation script with 3 short dialog about kind of wanted installation.

From now run any container you want or look about the [Lazy deploy](#lazy-deploy)


# **Lazy deploy** 
(docker-bay deployement)

## ***IMPORTANT NOTE***

***This script will deploy `treafik` as front proxy listening on the port `:80` so be sure this port is not already bind on your host by any `apache nginx tomcat` or else***

Choose either **starter** or **full** deployement, you can revert or redeploy at anytime

```bash
dockerbay-deploy starter
#or
dockerbay-deploy full
```
- starter containers : *trafik* , *portainer*
- extra containers : *mysql* , *maria-db* , *mongodb* , *adminer* , *adminMongo* , *redis* , *nodejs-workspace* , *ungit*

# **Usage**

Run any container by changing the `docker-compose.yml` in any containers directory with custom config and run `docker-compose up -d` in the container directory

## ***Add a Container***

```bash
mkdir ~/docker-bay/containers/newContainer
cd ~/docker-bay/containers/newContainer
touch docker-compose.yml
nano docker-compose.yml
# write some config
# you done
```

## ***compose-up or compose-down a container***

- `dockerbay-up` 
```bash
dockerbay-up newContainer # -d for detached mode
#or
dockerbay-up newContainer/sub-directory/nested-sub-directory  # -d for detached mode
```
- `dockerbay-down` 
```bash
dockerbay-down any-containers
#or
dockerbay-down any-containers/sub-directory/nested-sub-directory
```

*dockerbay-up* and *dockerbay-down* are shortcuts for *docker-compose up (-d)* and *docker-compose down* for a given containers location in `~/docker-bay/containers`

## ***Host & Redirect***

**Traefik** is based a DNS for redirection (see more in official doc)

Edit `hosts` file or have a valid DNS redirection to the machine host

- Example of edited `hosts` file
```conf
your.machine.host.ip	  portainer.dockerbay
your.machine.host.ip 	  adminer.dockerbay
...
# example
# 192.168.1.27		portainer.dockerbay
# 192.168.1.27 		adminer.dockerbay
# 192.168.1.27 		ungit.dockerbay
# 192.168.1.27 		adminmongo.dockerbay
# 192.168.1.27 		nodejs.dockerbay
# 192.168.1.27 		traefik.dockerbay
```

## ***Access to container***

###  ***bash terminal***

- `dockerbay-tunnel` 
```bash
dockerbay-tunnel nameOrIdOfContainer
```
*dockerbay-tunnel* is a shortcut for run a `docker exec -ti [...] /bin/bash` for a given container name or id 

### ***web-browser***

- Access to traefik dashboard :
```plaintext
http://your.machine.host.ip:8080

# based on example
# http://192.168.1.27:8080/
# OR
# http://traefik.dockerbay
```

- Access to portainer example
```plaintext
http://your.machine.host.ip:9009

# based on example
# http://192.168.1.27:9009/
# OR
# http://portainer.dockerbay
```

## ***Access to SGBD's***

### ***From adminer (credentials by default)***

```plaintext
 http://adminer.dockerbay
```
```plaintext
server : 
    dockerbay_mysql 
    dockerbay_mongodb
    dockerbay_mariadb

for each :
    database : dockerbay_db
    user : root OR dockerbayuser
    password : root OR dockerbayuser
```

**Note**

In example, **docker service** name are used, **server ip** will be the **docker network ip** as far they're on the same **networks** (*they are by default*), check **portainer or traefik dashboard** to check ip's and network

### ***From an application***

**server ip** will be the **docker ip** as far they're on the same **networks** (*they are by default*), check **portainer or traefik dashboard** to check ip's and network

## ***Dockerbay compose exemple***

```yml
version: "3"

services:
  dockerbay_adminmongo:
    build: ./
    image: dockerbay/adminmongo
    container_name: dockerbay-adminmongo
    networks:
      - traefik
    environment:
      - CONN_NAME=dockerbay
      - DB_HOST=dockerbay_mongodb
      - DB_PORT=27017
    ports:
      - "3123:1234"
    labels:
      - "traefik.port=1234"
      - "traefik.backend=dockerbay_adminmongo"
      - "traefik.frontend.rule=Host:adminmongo.dockerbay"
    command : node app.js
    stdin_open: true
    tty: true

networks:
  traefik:
    external:
      name: traefik_webgateway
```

## ***Changelog***

- Release:
    - 0.1:
        - Rework of the default container configuration (default name, service, ports ...)
        - Introduction of mongodb, adminMongo, ungit containers

## ***To do***

- have a better management of arguments for dockerbay shortcuts (docker compose --build, docker exec --user, etc...)
- get a deeper look about portainer templates system
- fix the templates issues
- take a look about running sql script on staturp
- ... so many more