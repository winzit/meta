#!/bin/sh

sudo apt install schroot debootstrap

sudo mkdir -p /srv/chroot/debian-sid
sudo debootstrap sid /srv/chroot/debian-sid

sudo tee /etc/schroot/chroot.d/debian-sid << EOF
# schroot chroot definitions.
# See schroot.conf(5) for complete documentation of the file format.
#
# Please take note that you should not add untrusted users to
# root-groups, because they will essentially have full root access
# to your system.  They will only have root access inside the chroot,
# but that's enough to cause malicious damage.
#
# The following lines are examples only.  Uncomment and alter them to
# customise schroot for your needs, or create a new entry from scratch.
#
[debian-sid]
description=Debian Sid for building packages suitable for uploading to Debian
type=directory
directory=/srv/chroot/debian-sid
users=codespace
root-groups=root,codespace
personality=linux
preserve-environment=true
EOF

cat debconfig.txt | tee -a ~/.bashrc

sudo schroot -c debian-sid
