#!/bin/bash
#
# Run  Docker image of zap 
IMAGE="owasp/zap2docker-weekly"
ROOTPATH=$1
URL=$2
REPORTNAME=$3
#
echo "ROOTPATH"
echo "$ROOTPATH"
#

chmod 777 *.*
chmod 777 -R $ROOTPATH
ls -l
echo "$pwd"
echo "START RUNNING ZAP"
sudo docker run -v ${ROOTPATH}:/zap/wrk/:rw -t ${IMAGE} zap-baseline.py \
    -t ${URL} -r ${REPORTNAME}
ls -l
echo "DONE"