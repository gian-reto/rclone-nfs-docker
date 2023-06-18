#!/usr/bin/env sh

mkdir -p \
    /mnt/rclone \
    /run/openrc

rc-update add nfs
rc-update add rclone
rc-update add timestamp_updater

touch /run/openrc/softlevel

sed -i 's/^tty/#&/' /etc/inittab

exec /sbin/init
