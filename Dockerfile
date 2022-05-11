FROM node:16-alpine
WORKDIR /app
COPY ["package.json", "package-lock.json", "./"]
RUN ["npm", "ci"]
COPY ["app.js", "."]
ENTRYPOINT ["npm", "start"]
