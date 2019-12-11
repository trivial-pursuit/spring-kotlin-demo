#!/bin/sh
docker build . -t disruptive-guestbook
mkdir -p build/distributions
docker run --rm --entrypoint cat disruptive-guestbook  /home/application/function.zip > build/distributions/function.zip
echo
echo
echo "To run the docker container execute:"
echo "    $ docker run -p 8080:8080 disruptive-guestbook"
