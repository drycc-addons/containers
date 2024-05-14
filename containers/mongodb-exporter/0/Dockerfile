ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV MONGODB_EXPORTER_VERSION="0.40.0"

RUN install-stack mongodb_exporter $MONGODB_EXPORTER_VERSION 

EXPOSE 9216
ENV PATH="/opt/drycc/mongodb_exporter/bin:$PATH"
USER 1001
ENTRYPOINT [ "mongodb_exporter" ]
