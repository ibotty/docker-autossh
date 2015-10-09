#!/bin/sh
set -e

HOME=`mktemp -d`
USER=autossh
export HOME USER

echo "$USER:x:$UID:1000:Autossh User:$HOME:/bin/sh" >> /etc/passwd

mkdir -p $HOME/.ssh
chmod 0700 $HOME/.ssh
if [ -f /secrets/known-hosts ]; then
    cp /secrets/known-hosts $HOME/.ssh/known_hosts
fi

AUTOSSH_DEBUG=true
export AUTOSSH_DEBUG

AUTOSSH_LOGFILE=$HOME/log
export AUTOSSH_LOGFILE
mkfifo $AUTOSSH_LOGFILE

# log to stdout
tail -f $AUTOSSH_LOGFILE &

set -x
exec autossh -M 0 -o ServerAliveInterval=1 -o ServerAliveCountMax=3 "$@"
