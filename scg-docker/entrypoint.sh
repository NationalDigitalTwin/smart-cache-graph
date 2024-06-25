#!/bin/sh

# Runs in the smart-cache-graph container, with directory /fuseki/.
## This starts Fuseki.
## Command line arguments are passed from "docker run"

# env | sort

MAIN=io.telicent.core.MainSmartCacheGraph
FUSEKI_LIB="${FUSEKI_DIR}/lib"

## All in one directory
FUSEKI_CP="$FUSEKI_LIB"'/*'

env | grep "OTEL" >/dev/null 2>&1
if [ $? -eq 0 ]; then
  export FUSEKI_FMOD_OTEL=true
  if [ -z "${OTEL_SERVICE_NAME}" ]; then
    export OTEL_SERVICE_NAME="smart-cache-graph"
  fi
  JAVA_OPTIONS="-javaagent:${FUSEKI_DIR}/agents/opentelemetry-javaagent.jar ${JAVA_OPTIONS}"
fi
echo "java" $JAVA_OPTIONS -cp "$FUSEKI_CP" $MAIN "$@"
exec "java" $JAVA_OPTIONS -cp "$FUSEKI_CP" $MAIN "$@"
