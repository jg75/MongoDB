#! /bin/bash
tempfile=$(mktemp)

trap "rm $tempfile.* 2> /dev/null" EXIT

backup() {
    for host in $@
    do
        uri=mongodb://@$host/config

        mongo $uri --eval 'if(db.isMaster().secondary) {db.fsyncLock();}' > $tempfile.$host

        if grep lockCount $tempfile.$host > /dev/null 2>&1
        then
            mongodump --host $host --oplog
            mongo $uri --eval 'db.fsyncUnlock();'
        fi
    done
}

mongo mongodb://@mongodb:27017/config --eval 'sh.stopBalancer()'

backup 1.config.mongodb 2.config.mongodb 3.config.mongodb
backup 1.replica1.mongodb 2.replica1.mongodb 3.replica1.mongodb

mongo mongodb://@mongodb:27017/config --eval 'sh.startBalancer()'
