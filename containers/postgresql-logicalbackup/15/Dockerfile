ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV PG_MAJOR=15 \
    PG_MINOR=5 \
    WALG_VERSION="2.0.1" \
    HOME=/opt/drycc/postgresql 
ENV PGDATA=$HOME/$PG_MAJOR/data \
    PGHOME=$HOME \
    MC_VERSION="2023.07.18.21.05.38"
# Install postgresql && mc
RUN . init-stack && install-stack postgresql $PG_MAJOR.$PG_MINOR \
  && install-stack mc $MC_VERSION \ 
  && install-packages pigz

RUN chmod g+rwX $PGHOME \
   && sed -i "s|/var/lib/postgresql.*|$PGHOME:/bin/bash|" /etc/passwd \
   # Set permissions for OpenShift
   && chmod 775 $PGHOME \
   && chmod 664 /etc/passwd \
   && mkdir -p /usr/share/man/man{1..8} \
   && mkdir -p $PGDATA  \
   && groupadd postgres && useradd -g postgres postgres \
   && chown -R postgres:postgres $HOME 

ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 EDITOR=/usr/bin/editor \
    PATH=$PATH:/opt/drycc/postgresql/$PG_MAJOR/bin/:/opt/drycc/mc/bin/
USER postgres
ENTRYPOINT ["init-stack"]
CMD [ "psql" ]