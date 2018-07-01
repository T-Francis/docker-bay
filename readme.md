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
```
- starter containers : *trafik* , *portainer*

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
# 192.168.1.27		portainer.local
# 192.168.1.27 		adminer.local
# 192.168.1.27 		ungit.local
# 192.168.1.27 		adminmongo.local
# 192.168.1.27 		nodejs.local
# 192.168.1.27 		traefik.local
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
# http://traefik.local
```

- Access to portainer example
```plaintext
# based on example
# http://portainer.local
```

## ***Access to SGBD's***

### ***From adminer (credentials by default)***

```plaintext
 http://adminer.local
```
```plaintext
server : 
    mysql 
    mongodb
    mariadb

for each :
    database : mysql / mongodb / mariadb
    user & password : root OR mysql-user / mongodb-user / mariadb-user  
```

**Note**

In example, **docker service** name are used, **server ip** will be the **docker network ip** as far they're on the same **networks** (*they are by default*), check **portainer or traefik dashboard** to check ip's and network

### ***From an application***

**server ip** will be the **docker ip** as far they're on the same **networks** (*they are by default*), check **portainer or traefik dashboard** to check ip's and network

## ***Dockerbay compose exemple***

```yml
version: 3

services:
  adminmongo:
    build:
      context: ~/docker-bay/dockerfiles/adminmongo
      dockerfile: Dockerfile
    container_name: adminmongo
    networks:
      - traefik
    environment:
      - CONN_NAME=local
      - DB_HOST=mongodb
      - DB_PORT=27017
      - DB_USERNAME=mongo-user
      - DB_PASSWORD=mongo-user
    labels:
      - traefik.port=1234
      - traefik.backend=adminmongo
      - traefik.frontend.rule=Host:adminmongo.local
    command : node app.js
    stdin_open: true
    tty: true
    depends_on:
        mongodb

  mongodb:
    container_name: mongodb
    image: mongo:latest
    volumes: 
      - ~/docker-bay/volumes/mongodb:/data/db
    restart: always
    networks:
      - traefik
    environment:
      MONGODB_ADMIN_USER: root
      MONGODB_ADMIN_PASS: root
      MONGODB_APPLICATION_DATABASE: example_database
      MONGODB_APPLICATION_USER: mongo-user
      MONGODB_APPLICATION_PASS: mongo-user
    labels:
      - traefik.port=27017
      - traefik.backend=mongodb

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
    - 0.2:
        - This update bring a lot of change that implying the rewrite of a lot of file, it's clearly not a good practice to made so many change at the same time, but sometimes, what need to be done has to be done :s
        - Introduction of the `dockerfiles/` directory that will serve as image build workspace
        - Rework of the `adminmongo`&`mongodb` / `ungit` container (move of the Dockerfile)
        - update of the naming for default values host/redirect, container name etc .. (will be more generic and friendly than *-dockerbay)
        - Remove of the `deploy-full` function 
        - Remove of the `php` and `nodejs` container (will be convert in dockerfiles/image)
        - Remove of the `clean-clrf` function (didn't work as expected)
        - Rewrite of the docker compose files, remove of the quote, structuration of the yaml        

## ***To do***

- have a better management of arguments for dockerbay shortcuts (docker compose --build, docker exec --user, etc...)
- get a deeper look about portainer templates system
- take a look about running sql script on staturp
- ... so many more