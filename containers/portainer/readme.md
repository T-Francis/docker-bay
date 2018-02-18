# Portainer 

From : [@official Portainer Github](https://github.com/portainer/portainer)

The default configuration will connect Portainer against the local Docker host, using an nginx container (port 80).

## The nginx front proxy:

- Start from alpine image
- Deleting the default config
- Copying the portainer host config

```bash
FROM nginx:alpine

RUN rm /etc/nginx/conf.d/default.conf
COPY config/portainer.conf /etc/nginx/conf.d/portainer.conf
```

## The docker-compose:

```yml
version: '2'

services:
  proxy:
    build: nginx/
    container_name: "portainer-proxy"
    ports:
      - "80:80"
    networks:
      - local

  templates:
    image: portainer/templates
    container_name: "portainer-templates"
    networks:
      - local

  portainer:
    image: portainer/portainer
    container_name: "portainer-app"

    #Automatically choose 'Manage the Docker instance where Portainer is running' by adding <--host=unix:///var/run/docker.sock> to the command
    command: --templates http://templates/templates.json
    networks:
      - local
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /opt/portainer/data:/data

  watchtower:
    image: v2tec/watchtower
    container_name: "portainer-watchtower"
    command: --cleanup portainer-app portainer-watchtower portainer/templates
    networks:
      - local
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock

networks:
  local:
    driver: bridge
```


## Usage:

Run it: 

```bash
docker-compose up -d
```

And then access Portainer by hitting [http://host/portainer](http://host/portainer) with a web browser.


## Know issues

- Volume management

I experience a bug whe i want create a volume through Portainer UI, seems broken.

To use custome volume for container creation, create it with the docker-engine command line in your favorite terminal.

```bash

```