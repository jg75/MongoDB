#! /bin/bash

dirname=$(dirname $0)
retries=40
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
    local dir=$dirname/$(basename $1)
    local host=$2
    local port=$3

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
    input $1
    provision $(input $1)
    shift
done
