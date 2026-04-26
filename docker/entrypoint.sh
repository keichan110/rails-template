#!/bin/bash
set -e

# Rails server.pid が残っている場合は削除
rm -f /app/tmp/pids/server.pid

# Gemfile.lock が存在する場合はbundle installを確認
if [ -f /app/Gemfile.lock ]; then
  bundle check || bundle install
fi

exec "$@"
