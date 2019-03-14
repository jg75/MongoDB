#! /bin/bash

dirname=$(dirname $0)
retries=120
sleep=5

usage() {
    echo Usage: "$0 [-d directory -r <retries> -s <sleep seconds>]"
    exit
}

waitfor() {
    local host=$1
    local port=$2

    for ((i = 0; i <= retries; i++))
    do
        if mongo --host $host --port $port --eval 'rs.status()' > /dev/null 2>&1
        then
            break
        elif [ $i -eq $retries ]
        then
            return 1
        else
            echo Waiting $sleep seconds for $host:$port
            sleep $sleep
        fi
    done
}

provision() {
    local server=$(basename $1)
    local dir=$dirname/$server
    local host=$2
    local port=$3

    if [ $server == "router" ]
    then
        router=$server
        router_host=$host
        router_port=$port
    fi

    if waitfor $host $port
    then
        for file in $(find $dir -type f -name '*.js')
        do
            mongo --host $host --port $port $file
        done
    fi
}

input() {
    echo "$@" | awk 'BEGIN{
        delimeters[0] = ","
        delimeters[1] = ":"
    } {
        indices[0] = index($0, delimeters[0])
        indices[1] = index($0, delimeters[1])

        server = substr($0, 0, indices[0])
        hostname = substr($0, indices[0] + 1)
        port = 27017

        if (indices[1] > 0) {
            port = substr($0, indices[1] + 1)
            hostname = substr(hostname, 0, length(hostname) - length(port))
        }
    }END{
       print server, hostname, port
    }'
}

create-users() {
    local dir=$dirname/users
    local host=$1
    local port=$2

    for file in $(find $dir -type f -name '*.js')
    do
        mongo --host $host --port $port admin $file
    done
}

while getopts "hd:r:s:" opt "$@"
do
    case $opt in
        d) dirname=$OPTARG
            ;;
        r) retries=$OPTARG
            ;;
        s) sleep=$OPTARG
            ;;
        *) usage
            ;;
    esac
done

shift $((OPTIND-1))

while [ $# -gt 0 ]
do
    provision $(input $1)
    shift
done

create-users $router_host $router_port
openssl rand -base64 756 > $dirname/../keys/keyfile
chmod 400 $dirname/../keys/keyfile

