#!/bin/bash

service="vdab_vpn"

if systemctl is-active --quiet $service; then
    echo $service active
fi

