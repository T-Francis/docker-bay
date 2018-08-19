FROM node:8.11.3-slim

WORKDIR /app/adminmongo

COPY ./adminmongo ./

ARG GUI_PASSWORD

RUN sed -i -e "s/@GUI_PASSWORD@/$GUI_PASSWORD/g" /app/adminmongo/config/app.json

RUN npm install

EXPOSE 1234

CMD ["node"]