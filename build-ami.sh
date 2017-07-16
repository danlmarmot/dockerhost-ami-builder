#!/usr/bin/env bash

docker build -t ami .
docker run --rm -it -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY ami
