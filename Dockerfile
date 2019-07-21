FROM openjdk:8u131-jre-alpine

VOLUME ["/server", "/plugins", "/config"]
WORKDIR /server

ENV BUNGEE_HOME=/server \
    BUNGEE_BASE_URL=https://ci.velocitypowered.com/job/velocity \
    BUNGEE_JAR=velocity-proxy-1.0.3-SNAPSHOT-all.jar \
    MEMORY=512m

COPY *.sh /usr/bin/

RUN apk --no-cache add curl bash sudo

EXPOSE 25577

RUN set -x \
	&& addgroup -g 1000 -S velocity \
	&& adduser -u 1000 -D -S -G velocity velocity \
	&& addgroup velocity wheel

CMD ["/usr/bin/run-bungeecord.sh"]
