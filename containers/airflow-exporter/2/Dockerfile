ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV AIRFLOW_VERSION="2.8.0"

RUN install-stack airflow_exporter $AIRFLOW_VERSION 
  
EXPOSE 9112
USER 1001
ENTRYPOINT [ "init-stack", "airflow_exporter" ]
