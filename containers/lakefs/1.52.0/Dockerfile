ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV LAKEFS_VERSION="1.52.0" 

RUN install-stack lakefs $LAKEFS_VERSION

RUN addgroup --system lakefs && \
<<<<<<< HEAD
    useradd --system --gid lakefs --shell /bin/false --create-home --home-dir /home/lakefs lakefs

RUN mkdir -p /home/lakefs  && \
    chown -R lakefs:lakefs /home/lakefs

=======
    useradd --system --gid lakefs --uid 1001 lakefs
>>>>>>> 5d218e344ac3d65af0c01a647f536a8e7605c49b
USER lakefs
EXPOSE 8000/tcp
ENTRYPOINT ["init-stack","lakefs"]
CMD ["run"]