#!/bin/bash

CONT_NAME="$(grep "CONTAINER_NAME" .env | sed -r 's/.{,15}//')"
SCRIPT_ARGS="${@:2}"
SCRIPT_NAME=$1

echo $CONT_NAME

container_id=$(docker run -d -v $PWD/sbase:/SeleniumBase/sbase -e USER_ID=$USER_ID -e GRUP_ID=$GRUP_ID -e ARGUMENTS="$SCRIPT_ARGS" $CONT_NAME tail -f /dev/null)

docker exec $container_id bash -c "python3 /SeleniumBase/sbase/scripts/$SCRIPT_NAME.py"
