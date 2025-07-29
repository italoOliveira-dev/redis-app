FROM node:alpine

RUN addgroup -S node-app \
    && adduser -S node-app -G node-app -h /home/node-app -D

WORKDIR /usr/application

COPY ./package.json ./
COPY ./package-lock.json ./

RUN chown -R node-app:node-app /usr/application
USER node-app

RUN npm install --ignore-scripts

COPY ./index.js ./

CMD ["npm", "start"]