#!/bin/bash

while getopts s:t:ip option
do
case "${option}"
in
s) SOURCE_FOLDER=${OPTARG};;
t) TARGET_NAME=${OPTARG};;
ip) DISP=${OPTARG};;
esac
done

if [ -z "$DISP"]; then
    if [ -z "$SOURCE_FOLDER" ]; then
    docker run -i -p 8787:8787 -e DISPLAY=${DISP} --name sandbox -h sandbox -v ${SOURCE_FOLDER}:/home/riccardo/${TARGET_NAME}
    else
    docker run -i -p 8787:8787 -e DISPLAY=${DISP} --name sandbox -h sandbox
    fi
else
    if [ -z "$SOURCE_FOLDER" ]; then
    docker run -i -p 8787:8787 -e --name sandbox -h sandbox -v ${SOURCE_FOLDER}:/home/riccardo/${TARGET_NAME}
    else
    docker run -i -p 8787:8787 -e --name sandbox -h sandbox
    fi
fi
