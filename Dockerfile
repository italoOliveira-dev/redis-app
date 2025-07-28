FROM node:alpine

WORKDIR /usr/application

COPY ./package.json ./

RUN npm install

COPY ./ ./

CMD ["npm", "start"]