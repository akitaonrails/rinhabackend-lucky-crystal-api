FROM docker.io/crystallang/crystal:1.9.2

# Install utilities required to make this Dockerfile run
RUN apt-get update && \
    apt-get install -y wget

# Apt installs:
# - Postgres cli tools are required for lucky-cli.
# - tmux is required for the Overmind process manager.
RUN apt-get update && \
    apt-get install -y postgresql-client tmux && \
    rm -rf /var/lib/apt/lists/*

# Install lucky cli
WORKDIR /lucky/cli
RUN git clone https://github.com/luckyframework/lucky_cli . && \
    git checkout v1.0.0 && \
    shards build --without-development && \
    cp bin/lucky /usr/bin && \
    rm -Rf /lucky/cli

WORKDIR /app

COPY shard.yml shard.lock ./

COPY ./config /app/config
COPY ./src /app/src
COPY ./db /app/db
COPY ./docker /app/docker
COPY ./tasks.cr /app/tasks.cr
COPY ./tasks /app/tasks
COPY ./spec /app/spec

RUN shards check || shards install
RUN shards build --production

ENV DATABASE_URL=postgres://postgres:password@postgres:5432/postgres
EXPOSE 3000

CMD ["./docker/entrypoint.sh"]
