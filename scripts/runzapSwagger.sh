#!/bin/bash
#
# Run  Docker image of zap 
IMAGE="owasp/zap2docker-weekly"
ROOTPATH=$1
JSON=$2
AUTHURL=$3
REPORTNAME=$4
CLIENTID=$5
CLIENTSECRET=$6
SCOPE=$7
USERID=$8
EMAIL=$9

#
echo "ROOTPATH"
echo "$ROOTPATH"
#

chmod 777 *.*
chmod 777 -R $ROOTPATH
python3 ${ROOTPATH}/scripts/Authtoken.py ${AUTHURL} ${CLIENTID} ${CLIENTSECRET} ${SCOPE}
authtoken=$(python3 ${ROOTPATH}/scripts/Authtoken.py ${AUTHURL} ${CLIENTID} ${CLIENTSECRET} ${SCOPE})

#ls -l
echo "$pwd"
echo "START RUNNING ZAP"
rm auth.prop
echo "----> Building prop file:"
echo  "replacer.full_list(0).description=auth1" >> auth.prop
echo  "replacer.full_list(0).enabled=true" >> auth.prop
echo  "replacer.full_list(0).matchtype=REQ_HEADER" >> auth.prop
echo  "replacer.full_list(0).matchstr=Authorization" >> auth.prop
echo  "replacer.full_list(0).regex=false" >> auth.prop
echo  "replacer.full_list(0).replacement=Bearer $authtoken" >> auth.prop
echo  "formhandler.fields.field\\(0\\).fieldId=userId" >> auth.prop
echo  "formhandler.fields.field\\(0\\).value=${USERID}" >> auth.prop
echo "formhandler.fields.field\\(0\\).enabled=true" >>auth.prop                
echo "formhandler.fields.field\\(1\\).fieldId=includeCountryCode" >> auth.prop 
echo "formhandler.fields.field\\(1\\).value=true" >> auth.prop 
echo "formhandler.fields.field\\(1\\).enabled=true" >> auth.prop 
echo "formhandler.fields.field\\(2\\).fieldId=includeFunctionCode" >> auth.prop 
echo "formhandler.fields.field\\(2\\).value=true" >> auth.prop 
echo "formhandler.fields.field\\(2\\).enabled=true" >> auth.prop
echo "formhandler.fields.field\\(3\\).fieldId=email" >> auth.prop
echo "formhandler.fields.field\\(3\\).value=${EMAIL}" >> auth.prop
echo "formhandler.fields.field\\(3\\).enabled=true" >> auth.prop

#sudo docker run -v ${ROOTPATH}:/zap/wrk/:rw -t ${IMAGE} zap-api-scan.py \
#   -t ${JSON} -f openapi -r ${REPORTNAME} -z "-config formhandler.fields.field\\(0\\).fieldId=userId \
#                 -config formhandler.fields.field\\(0\\).value=${USERID} \
#                 -config formhandler.fields.field\\(0\\).enabled=true \ 
#                 -config formhandler.fields.field\\(1\\).fieldId=includeCountryCode \ 
#                 -config formhandler.fields.field\\(1\\).value=true \  
#                 -config formhandler.fields.field\\(1\\).enabled=true \ 
#                 -config formhandler.fields.field\\(2\\).fieldId=includeFunctionCode \ 
#                -config formhandler.fields.field\\(2\\).value=true \  
#                 -config formhandler.fields.field\\(2\\).enabled=true \
#                 -config formhandler.fields.field\\(3\\).fieldId=email \ 
#                 -config formhandler.fields.field\\(3\\).value=${EMAIL} \
#                 -config formhandler.fields.field\\(3\\).enabled=true \
#                 -config replacer.full_list\(0\).description=auth1 \
#                 -config replacer.full_list\(0\).enabled=true \
#                 -config replacer.full_list\(0\).matchtype=REQ_HEADER \
#                 -config replacer.full_list\(0\).matchstr=Authorization \
#                 -config replacer.full_list\(0\).regex=false \
#                 -config replacer.full_list\(0\).replacement=Bearer ${authtoken}"
docker pull ${IMAGE}
sudo docker run -v ${ROOTPATH}:/zap/wrk/:rw -t ${IMAGE} zap-api-scan.py \
    -t ${JSON} -f openapi -r ${REPORTNAME} -z "-configfile /zap/wrk/auth.prop" -d
echo "ls -l"
ls-l
cp ${ROOTPATH}/${REPORTNAME} ${ROOTPATH}/reports/${REPORTNAME}
echo "DONE"