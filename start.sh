#!/bin/sh
set -e

HOME=`mktemp -d`
export HOME

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

AUTOSSH_PIDFILE=$HOME/pid
export AUTOSSH_PIDFILE

# log to stdout
tail -f $AUTOSSH_LOGFILE &

autossh -f -M 0 -o ServerAliveInterval=1 -o ServerAliveCountMax=3 "$@"
pid=$(cat $AUTOSSH_PIDFILE)

echo "starting autossh with pid $pid"
echo "and args -f -M 0 -o ServerAliveInterval=1 -o ServerAliveCountMax=3 $@"
wait $pid
