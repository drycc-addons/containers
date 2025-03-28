ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV LAKEFS_VERSION="1.52.0" 

RUN install-stack lakefs $LAKEFS_VERSION

RUN addgroup --system lakefs && \
    useradd --system --gid lakefs --uid 1001 lakefs
USER lakefs
EXPOSE 8000/tcp
ENTRYPOINT ["init-stack","lakefs"]
CMD ["run"]