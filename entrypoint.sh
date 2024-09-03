#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /myapp/tmp/pids/server.pid

# production環境の場合のみ
if [ "$RAILS_ENV" = "production" ]; then
  bundle exec rails assets:precompile
  bundle exec rails db:create
  bundle exec rails db:seed
  bundle exec ridgepole -c config/database.yml -E production --apply -f db/Schemafile
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
