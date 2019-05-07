#!/bin/bash
ips=()
ip=

echo started
echo UE: $TARGETDOMAIN
echo ip: $TARGETIP

if [ -z "$TARGETDOMAIN" ]
then
        TARGETDOMAIN=amf.default.svc.cluster.local
fi
echo TARGETDOMAIN: "$TARGETDOMAIN"

if [ -z "$TARGETIP" ]
then
        ips=($(dig +short $TARGETDOMAIN))
        ips=("${ips[@]%%:*}")

        ip=$ips
        echo found ip: $ips
else
        ip=$TARGETIP
fi

echo starting UE
echo ma-ue --target "https://""$TARGETDOMAIN"":4430/amfstart"
echo ma-ue --target "https://""$TARGETIP"":4430/amfstart"
cd /usr/local/bin/
echo $(pwd)
ma-ue --target "https://""$TARGETIP"":4430/amfstart"
