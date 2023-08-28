FROM docker.io/crystallang/crystal:1.9.2

WORKDIR /app

# make sure you ran shards build --production before updating the docker image
# also docker image rm to make sure you're getting the newest binaries
COPY ./bin /app/bin

ENV DATABASE_URL=postgres://postgres:postgres@host.docker.internal:5432/postgres
EXPOSE 3000

CMD ["/app/bin/app"]
