#!/bin/sh
docker build . -t disruptive-guestbook
mkdir -p build
docker run --rm --entrypoint cat disruptive-guestbook  /home/application/function.zip > build/function.zip

sam local start-api -t sam.yaml -p 8080

