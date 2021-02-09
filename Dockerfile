FROM node:slim
EXPOSE 8000
COPY . .
RUN npm install
CMD node src/index.js