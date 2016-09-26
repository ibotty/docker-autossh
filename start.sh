#!/bin/bash
set -euo pipefail

generate_container_user() {
    local USER_ID; USER_ID="$(id -u)"
    local GROUP_ID; GROUP_ID="$(id -g)"

    if [ x"$USER_ID" != x"0" -a x"$USER_ID" != x"1001" ]; then

        NSS_WRAPPER_PASSWD=/opt/app-root/etc/passwd
        NSS_WRAPPER_GROUP=/etc/group

        sed -e 's/^default:/builder:/' < /etc/passwd > $NSS_WRAPPER_PASSWD

        echo "default:x:${USER_ID}:${GROUP_ID}:Default Application User:${HOME}:/sbin/nologin" >> $NSS_WRAPPER_PASSWD

        export NSS_WRAPPER_PASSWD
        export NSS_WRAPPER_GROUP

        LD_PRELOAD=libnss_wrapper.so
        export LD_PRELOAD
    fi
}

generate_container_user

export USER="$(whoami)"

mkdir -p "$HOME/.ssh"
chown 0700 "$HOME/.ssh" || true

if [ -f /secrets/known-hosts ]; then
    cp /secrets/known-hosts $HOME/.ssh/known_hosts
fi

export AUTOSSH_DEBUG="${AUTOSSH_DEBUG-true}"

export AUTOSSH_LOGFILE=$HOME/log
mkfifo $AUTOSSH_LOGFILE

# log to stdout
tail -f $AUTOSSH_LOGFILE &

set -x
exec autossh -M 0 -o ServerAliveInterval=1 -o ServerAliveCountMax=3 \
    -i /secrets/ssh-privkey "$@"
