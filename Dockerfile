FROM alpine

ARG PASSWORD

RUN apk add --no-cache --update-cache nodejs npm \
    curl git openjdk8-jre gettext

RUN git clone https://github.com/grglzrv/L3MON.git

WORKDIR L3MON/server

RUN npm run && npm install pm2 -g && npm install
RUN pm2 start index.js && sleep 5 && pm2 stop index
RUN sed -i "s/\"password\": \"\"/\"password\": \"$(echo -n "$PASSWORD" | md5sum | awk '{print $1}')\"/g" maindb.json

EXPOSE 22533

ENTRYPOINT ["pm2-runtime"]
CMD ["start", "index.js"]
