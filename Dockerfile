FROM openjdk:8u92-jdk-alpine

RUN apk add --no-cache bash git automake autoconf gcc nodejs

# Workaround taken from https://github.com/npm/npm/issues/9863#issuecomment-248276058
RUN cd $(npm root -g)/npm \
  && npm install fs-extra \
  && sed -i -e s/graceful-fs/fs-extra/ -e s/fs\.rename/fs.move/ ./lib/utils/rename.js

RUN npm update -g npm
