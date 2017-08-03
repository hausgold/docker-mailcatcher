#!/bin/bash

# Configure the mDNS hostname on avahi
if [ -n "${MDNS_HOSTNAME}" ]; then
    sed \
      -e "s/.*\(host-name=\).*/\1${MDNS_HOSTNAME}/g" \
      -i /etc/avahi/avahi-daemon.conf
    echo "Configured mDNS hostname to ${MDNS_HOSTNAME}.local"
fi

# Disable the rlimits from default debian
sed \
  -e 's/^\(rlimit\)/#\1/g' \
  -i /etc/avahi/avahi-daemon.conf

# Start avahi
/usr/sbin/avahi-daemon --no-rlimits
