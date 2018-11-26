#!/bin/bash
HOSTNAME="123.123.123.12"
ID="PEASANT_SCRIPT"
echo -e "hostname: $HOSTNAME\nid: $ID" |sudo tee /etc/salt/minion
