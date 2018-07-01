FROM node:carbon

RUN apt-get update && apt-get install -y git ssh --no-install-recommends

RUN npm install ungit -g

RUN useradd ungit -m

#USER ungit

VOLUME ["/repo"]

EXPOSE 8448

CMD ["ungit", "--no-launchBrowser", "--forcedLaunchPath=/repo"]
