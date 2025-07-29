FROM node:alpine

RUN addgroup -S node \
    && adduser -S node -G node -h /home/node -D

WORKDIR /usr/application
RUN chown node:node /usr/application
USER node

COPY ./package.json ./
COPY ./package-lock.json ./

RUN npm install --ignore-scripts

COPY ./index.js ./

CMD ["npm", "start"]