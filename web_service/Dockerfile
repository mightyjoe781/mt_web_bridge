FROM node:18-alpine

WORKDIR /mt_frontend/

COPY public/ /mt_frontend/public
COPY src/ /mt_frontend/src
COPY package.json/ /mt_frontend/

RUN npm install

CMD ["npm", "start"]