#!/bin/bash

set -ex

ROOT=$(realpath $(dirname $BASH_SOURCE)/..)

cd $ROOT

run() {
  case "$1" in
    build)
      build-images
      ;;
    up)
      docker run \
          -d \
          --rm \
          --net host \
          -v /tmp/checkpoint:/checkpoint \
          --name coach \
          -e DISPLAY=$DISPLAY \
          -v /tmp/.X11-unix:/tmp/.X11-unix \
          coach:master \
          tail -f /dev/null
      ;;
    down)
      docker stop coach
      ;;
    shell)
      docker exec -it coach /bin/bash 
      ;;
  esac
}

build-images() {
  docker build -f docker/Dockerfile.base -t coach-base:master .
  docker build -f docker/Dockerfile.gym_environment -t coach:master .
}

run $@