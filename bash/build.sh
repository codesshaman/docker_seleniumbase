#!/bin/bash

CONT_NAME="$(grep "CONTAINER_NAME" .env | sed -r 's/.{,15}//')"

docker image rm ${CONT_NAME}

docker build -t ${CONT_NAME} .

docker images | grep ${CONT_NAME}
