FROM schickling/mailcatcher:latest
LABEL org.opencontainers.image.authors="containers@hausgold.de"

# You can change this environment variable on run's with -e
ENV MDNS_HOSTNAME=mailcatcher.local

# Install system packages
RUN apk add --no-cache \
  dbus avahi avahi-tools haproxy supervisor bash

# Reconfigure supervisord
RUN sed \
  -e 's#^\(files =\).*#\1 /etc/supervisor/conf.d/*.conf#g' \
  -i /etc/supervisord.conf

# Copy custom scripts
COPY config/*.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/*

# Configure haproxy
COPY config/haproxy.conf /etc/haproxy/haproxy.cfg
COPY config/haproxy/errors /etc/haproxy/errors

# Configure supervisord
COPY config/supervisor/* /etc/supervisor/conf.d/

# Define the command to run per default
CMD ["/usr/bin/supervisord", "-nc", "/etc/supervisord.conf"]
