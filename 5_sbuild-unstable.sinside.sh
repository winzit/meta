#!/bin/sh

apt-get update
rm /etc/unsupported-skip-usrmerge-conversion
apt-get install --fix-broken
rm /etc/unsupported-skip-usrmerge-conversion
apt-get install usr-is-merged
apt-get install --fix-broken
apt-get update
apt install sudo
usermod -aG sudo codespace

cat /etc/debian_version

