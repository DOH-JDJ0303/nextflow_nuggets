#!/bin/bash

SEQ=$1
SAMPLE=$2
VALUE=$3

if [ "$VALUE" != 'ok' ]
then
    echo "ERROR: Third position must be 'ok'." && exit 1234
fi

zcat ${SEQ} | grep -v '>' | tr -d '\n\r\t ' | wc -c | tr -d '\n' > ${SAMPLE}-length.txt