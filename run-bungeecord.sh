#!/bin/bash

BUNGEE_JAR=$BUNGEE_HOME/velocity-proxy-1.0.0-SNAPSHOT-all.jar

if [[ ! -e $BUNGEE_JAR ]]; then
    echo "Downloading ${BUNGEE_JAR_URL:=${BUNGEE_BASE_URL}/${BUNGEE_JOB_ID:-lastStableBuild}/artifact/proxy/build/libs/velocity-proxy-1.0.0-SNAPSHOT-all.jar}"
    if ! curl -o $BUNGEE_JAR -fsSL $BUNGEE_JAR_URL; then
        echo "ERROR: failed to download" >&2
        exit 2
    fi
fi

if [ -d /plugins ]; then
    echo "Copying BungeeCord plugins over..."
    cp -r /plugins $BUNGEE_HOME
fi

if [ -d /config ]; then
    echo "Copying BungeeCord configs over..."
    cp -u /config/config.yml "$BUNGEE_HOME/config.yml"
fi

if [ $UID == 0 ]; then
  chown -R velocity:velocity $BUNGEE_HOME
fi

echo "Setting initial memory to ${INIT_MEMORY:-${MEMORY}} and max to ${MAX_MEMORY:-${MEMORY}}"
JVM_OPTS="-Xms${INIT_MEMORY:-${MEMORY}} -Xmx${MAX_MEMORY:-${MEMORY}} ${JVM_OPTS}"

if [ $UID == 0 ]; then
  exec sudo -u velocity java $JVM_OPTS -jar $BUNGEE_JAR "$@"
else
  exec java $JVM_OPTS -jar $BUNGEE_JAR "$@"
fi
