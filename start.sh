#!/bin/sh
set -e

HOME=${HOME-/tmp/home}

mkdir -p $HOME/.ssh
chmod 0700 $HOME/.ssh
if [ -f /secrets/known-hosts]; then
    cp /secrets/known-hosts $HOME/.ssh/known_hosts
fi

exec "$@"
