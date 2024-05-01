#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /myapp/tmp/pids/server.pid

# docker-composeのcommandに渡された値、
# あるいはDockerfileのCMDに渡された引数が$@に入る
echo "\$@ : $@"
echo "\$* : $*"
echo "\$0 : $0"
echo "\$1 : $1"
echo "\$2 : $2"

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"