#! /bin/bash
dir=$(dirname $0)
replica_sets=(
    config
    replica1
)

docker-compose down
docker system prune -af

[ -f $dir/data/keys/keyfile ] &&
    rm -f $dir/data/keys/keyfile

for replica_set in config replica1
do
    for db_dir in $(
        find $dir/data/$replica_set \
             -depth 1 -maxdepth 1 \
             -type d -name "[1-3]"
    )
    do
        rm -rf $db_dir
    done
done
