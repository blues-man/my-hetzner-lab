#!/usr/bin/env bash

HOSTNAME=${1:-bootstrap.ocp4-upi.bohne.io}
IP=${2:-10.84.3.2}

resolve_conf=$( echo -e "search ucp4-upi.bohne.io\nnameserver 10.84.3.1" | jq -sRr @uri )

IFCFG=$(cat <<EOF
DEVICE=\"ens3\"
BOOTPROTO=\"static\"
NM_CONTROLLED=\"yes\"
ONBOOT=\"yes\"
TYPE=\"Ethernet\"
NETMASK=255.255.255.0
GATEWAY=10.84.3.1
IPADDR=$IP
EOF
)
# /etc/sysconfig/network-scripts/ifcfg-ens3 
ifcfg_ens3=$( echo -e "$IFCFG" | jq -sRr @uri )

json=$(cat <<EOF
[
{
    "contents": {
         "source":"data:,$ifcfg_ens3"
    },
    "filesystem": "root",
    "path": "/etc/sysconfig/network-scripts/ifcfg-ens3",
    "mode": 420,
    "user": {
        "name": "root"
    }
},
{
    "contents": {
         "source":"data:,$resolve_conf"
    },
    "filesystem": "root",
    "path": "/etc/resolv.conf",
    "mode": 420,
    "user": {
        "name": "root"
    }
},
{
    "contents": {
         "source":"data:,$HOSTNAME"
    },
    "filesystem": "root",
    "path": "/etc/hostname",
    "mode": 420,
    "user": {
        "name": "root"
    }
}
]
EOF
)

echo $json 




