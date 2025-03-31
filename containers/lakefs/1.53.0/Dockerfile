ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV LAKEFS_VERSION="1.53.0" 

RUN install-stack lakefs $LAKEFS_VERSION

RUN addgroup --system lakefs && \
    useradd --system --gid lakefs --shell /bin/false --create-home --home-dir /home/lakefs lakefs
    
RUN mkdir -p /home/lakefs  && \
    chown -R lakefs:lakefs /home/lakefs

USER lakefs
EXPOSE 8000/tcp
ENTRYPOINT ["init-stack","lakefs"]
CMD ["run"]