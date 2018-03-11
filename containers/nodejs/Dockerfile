FROM node:carbon
# giving permission to node for loopback-cli install
RUN chown -R node /usr/local

RUN mkdir /home/node/app

RUN usermod -a -G sudo node && \
    echo 'node ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    chown -R 1000:1000 /home/node/app

USER node

WORKDIR /home/node/app

RUN npm install -g loopback-cli

EXPOSE 3000

ENTRYPOINT ["/bin/bash"]