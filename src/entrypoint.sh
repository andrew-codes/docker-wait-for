#!/bin/sh

: ${SLEEP_LENGTH:=2}
: ${TIMEOUT_LENGTH:=300}

wait_for() {
  START=$(date +%s)
  echo "Waiting for $1 ..."
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" $1)
  echo "STATUS=${STATUS}"
  while [ $STATUS -eq '000' ];
    do
      if [ $(($(date +%s) - $START)) -gt $TIMEOUT_LENGTH ]; then
          echo "Service $1:$2 did not start within $TIMEOUT_LENGTH seconds. Aborting..."
          exit 1
      fi
      echo "Waiting for $1 ...sleep $SLEEP_LENGTH"
      sleep $SLEEP_LENGTH
      STATUS=$(curl -s -o /dev/null -w "%{http_code}" $1)
      echo "STATUS=${STATUS}"
  done
}

for var in "$@"
do
  wait_for $var
done
