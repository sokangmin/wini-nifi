FROM apache/nifi:1.14.0

COPY docker/lib /opt/nifi/nifi-current/lib
COPY docker/sh /opt/nifi/scripts
