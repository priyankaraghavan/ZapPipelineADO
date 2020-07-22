# ZapPipelineADO
This repository shows how one may authenticate and automate ZAP with ADO. Of course this can also be used for other pipelines like Jenkins or Argo. 
The scripts folder contains the python file to perform authentication on Azure AD. 
The token is tied with a bash script that used AD token and produced a config file. This is then sent to docker image as arguments
