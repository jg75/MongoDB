#! /bin/bash 
dir=$(dirname $0)

docker-compose -f $dir/docker-compose-first.yml up -d mongodb
docker-compose -f $dir/docker-compose-first.yml up provisioner.mongodb
docker-compose down
docker-compose up -d
