#!/bin/bash

BUNGEE_JAR_PATH=$BUNGEE_HOME/$BUNGEE_JAR

if [[ ! -e $BUNGEE_JAR_PATH ]]; then
    echo "Downloading ${BUNGEE_JAR_URL:=${BUNGEE_BASE_URL}/${BUNGEE_JOB_ID:-lastStableBuild}/artifact/proxy/build/libs/${BUNGEE_JAR}}"
    if ! curl -o $BUNGEE_JAR_PATH -fsSL $BUNGEE_JAR_URL; then
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
  exec sudo -u velocity java $JVM_OPTS -jar $BUNGEE_JAR_PATH "$@"
else
  exec java $JVM_OPTS -jar $BUNGEE_JAR_PATH "$@"
fi
