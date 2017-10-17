#!/bin/bash
# Remove the old container if it exists and launch a new one

CONTAINER_NAME=blog
CID=$(docker ps -q -f status=running -f name=^/${CONTAINER_NAME}$)
if [ -n "${CID}" ]; then
  docker rm -f ${CID}
fi
docker run -d -p 80:80 --name $CONTAINER_NAME blog:latest
