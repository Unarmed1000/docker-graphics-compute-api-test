#!/bin/bash
docker run --rm --env HOST_UID=$(id -u) --env HOST_GID=$(id -g) -v "$PWD":/playground -w /playground -it docker-graphics-compute-api-test:u18_04play "$@"
