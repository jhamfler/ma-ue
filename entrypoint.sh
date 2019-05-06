#!/bin/bash
ips=()
ip=

echo started
echo UE: $UEDOMAIN
echo ip: $UEIP

if [ -z "$UEDOMAIN" ]
then
        UEDOMAIN=ue.default.svc.cluster.local
fi
echo UEDOMAIN: "$NFNAME"

if [ -z "$UEIP" ]
then
        ips=($(dig +short $UEDOMAIN))
        ips=("${ips[@]%%:*}")

        ip=$ips
        echo found ip: $ips
else
        ip=$UEIP
fi

echo starting Network Function: $UEDOMAIN
echo NFservices --https_addr "$UEDOMAIN"":4430"
ma-ue --target "https://amf.default.svc.cluster.local:4430/amfstart"
