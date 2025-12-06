#!/bin/bash
# /etc/keepalived/check_salt.sh
# Simpler Healthcheck für keepalived:
# - Exit 0 -> alles OK, Node darf MASTER sein
# - Exit 1 -> Node gilt als "krank", BACKUP soll übernehmen

if systemctl is-active --quiet salt-master; then
    exit 0
else
    exit 1
fi
