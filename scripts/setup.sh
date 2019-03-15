#! /bin/bash
dir=$(dirname $0)/..

# Start mongo with no authentication
docker-compose -f $dir/docker-compose-no-auth.yml up -d mongodb

# Run the provisioner to configure the cluster
docker-compose -f $dir/docker-compose-no-auth.yml up provisioner.mongodb

# Stop and remove the mongodb containers with no authentication
docker-compose -f $dir/docker-compose-no-auth.yml down

# You can now use docker-compose for mongodb and backup.mongodb
