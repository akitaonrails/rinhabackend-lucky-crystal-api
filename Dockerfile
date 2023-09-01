FROM docker.io/crystallang/crystal:1.9.2

# Apt installs:
# - Postgres cli tools are required for lucky-cli.
RUN apt-get update && \
    apt-get install -y postgresql-client wget && \
    rm -rf /var/lib/apt/lists/*

# only if you want to run 'lucky db.migrate', but skipping in favor of db/structure.sql directly
# Install lucky cli
# WORKDIR /lucky/cli
# RUN git clone https://github.com/luckyframework/lucky_cli . && \
#     git checkout v1.0.0 && \
#     shards build --without-development && \
#     cp bin/lucky /usr/bin && \
#     rm -Rf /lucky/cli

WORKDIR /app

COPY shard.yml shard.lock ./
RUN shards install --production --skip-postinstall

COPY ./config /app/config
COPY ./src /app/src
COPY ./db /app/db
COPY ./docker /app/docker

RUN shards build --production

ENV DATABASE_URL=postgres://postgres:password@postgres:5432/postgres
EXPOSE 3000

CMD ["./docker/entrypoint.sh"]
