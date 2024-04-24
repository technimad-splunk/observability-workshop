#!/bin/bash
echo "Building: $1";
export ACCESS_TOKEN="<redacted"
export REALM="eu0"
export RUM_TOKEN="<redacted>"
export HEC_TOKEN="<redacted>"
#export HEC_URL="https://http-inputs-o11y-workshop-eu0.splunkcloud.com:443/services/collector/event"
export HEC_URL="https://http-inputs-o11y-workshop-us1.splunkcloud.com:443/services/collector/event"
export INSTANCE=$1

orb create -c cloud-init.yaml -a arm64 ubuntu:jammy $INSTANCE
sleep 2
ORBENV=ACCESS_TOKEN:REALM:RUM_TOKEN:HEC_TOKEN:HEC_URL:INSTANCE orb -m $INSTANCE -u splunk ansible-playbook /home/splunk/orbstack-profile.yml
sleep 2
ORBENV=ACCESS_TOKEN:REALM:RUM_TOKEN:HEC_TOKEN:HEC_URL:INSTANCE orb -m $INSTANCE -u splunk ansible-playbook /home/splunk/orbstack-secrets.yml
echo "ssh splunk@$INSTANCE@orb"
ssh splunk@$INSTANCE@orb
