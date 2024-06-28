#!/bin/bash

CONT_NAME="$(grep "CONTAINER_NAME" .env | sed -r 's/.{,15}//')"
USER_ID="$(grep "USER_ID" .env | sed -r 's/.{,8}//')"
GRUP_ID="$(grep "GRUP_ID" .env | sed -r 's/.{,8}//')"
SCRIPT_ARGS="${@:2}"
SCRIPT_NAME=$1

echo $CONT_NAME

container_id=$(docker run -d -v $PWD/sbase:/SeleniumBase/sbase:Z -e USER_ID=$USER_ID -e GRUP_ID=$GRUP_ID -e ARGUMENTS="$SCRIPT_ARGS" $CONT_NAME tail -f /dev/null)

docker exec $container_id bash -c "python3 /SeleniumBase/sbase/scripts/$SCRIPT_NAME.py"

docker stop $container_id && docker rm $container_id
