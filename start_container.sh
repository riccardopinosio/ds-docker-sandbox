#!/bin/bash

while getopts s:t option
do
case "${option}"
in
s) SOURCE_FOLDER=${OPTARG};;
t) TARGET_NAME=${OPTARG};;
esac
done

if [ -z "$SOURCE_FOLDER" ]; then
docker run -i -p 8787:8787 --name sandbox -h sandbox -v ${SOURCE_FOLDER}:/home/riccardo/${TARGET_NAME}
else
docker run -i -p 8787:8787 --name sandbox -h sandbox
fi
