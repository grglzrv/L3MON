FROM alpine

ENV pass=changeme

RUN apk add --no-cache --update-cache nodejs npm \
    curl git openjdk8-jre gettext

RUN git clone https://github.com/grglzrv/L3MON.git

WORKDIR L3MON/server

RUN npm run && npm install pm2 -g && npm install
RUN pm2 start index.js && sleep 5 && pm2 stop index
RUN export hash="$(echo -n "$pass" | md5sum | awk '{print $1}')" && \
    sed -i 's|"password": ""|"password": "$hash"|g' maindb.json && \
    envsubst < maindb.json > maindb.json.1 && \
    mv maindb.json.1 maindb.json

EXPOSE 22533

ENTRYPOINT ["pm2-runtime"]
CMD ["start", "index.js"]
