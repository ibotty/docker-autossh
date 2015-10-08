#!/bin/sh
set -e

HOME=`mktemp -d`
export HOME

mkdir -p $HOME/.ssh
chmod 0700 $HOME/.ssh
if [ -f /secrets/known-hosts ]; then
    cp /secrets/known-hosts $HOME/.ssh/known_hosts
fi

AUTOSSH_LOGFILE=$HOME/log
export AUTOSSH_LOGFILE
mkfifo $AUTOSSH_LOGFILE

AUTOSSH_PIDFILE=$HOME/pid
export AUTOSSH_PIDFILE

# log to stdout
tail -f $AUTOSSH_LOGFILE &

echo "starting autossh $@ as $USER"
autossh -f "$@"
pid=$(cat $AUTOSSH_LOGFILE)

wait $pid
