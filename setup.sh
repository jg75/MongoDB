#! /bin/bash 
dir=$(dirname $0)

docker-compose -f $dir/docker-compose-no-auth.yml up -d mongodb
docker-compose -f $dir/docker-compose-no-auth.yml up provisioner.mongodb
docker-compose down
