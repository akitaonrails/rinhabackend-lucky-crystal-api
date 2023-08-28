#!/bin/bash

set -euo pipefail
cd /app

# This is the entrypoint script used for development docker workflows.
# By default it will:
#  - Install dependencies.
#  - Run migrations.
#  - Start the dev server.
# It also accepts any commands to be run instead.


warnfail () {
  echo "$@" >&2
  exit 1
}

case ${1:-} in
  "") # If no arguments are provided, start lucky dev server.
    ;;

  *) # If any arguments are provided, execute them instead.
    exec "$@"
esac

if ! [ -d bin ] ; then
  echo "Creating bin directory"
  mkdir bin
fi
if ! shards check ; then
  echo "Installing shards..."
  shards install
fi

echo "Waiting for postgres to be available..."
/app/docker/wait-for-it.sh -q pgbouncer:5432

if ! psql -d "$DATABASE_URL" -c '\d migrations' > /dev/null ; then
  echo "Finishing database setup..."
  lucky db.reset
fi

echo "Starting lucky PROD server..."
export LUCKY_ENV=production
/app/bin/app
