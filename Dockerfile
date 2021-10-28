FROM apache/nifi:1.14.0

USER nifi

COPY docker/lib /opt/nifi/nifi-current/lib
COPY docker/sh /opt/nifi/scripts

WORKDIR /opt/nifi/nifi-current/

ENTRYPOINT ["/bin/bash"]
