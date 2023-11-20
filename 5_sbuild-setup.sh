#!/bin/bash 

sudo apt-get install sbuild schroot debootstrap apt-cacher-ng devscripts piuparts
cp -a ./.sbuildrc ~/
sudo sbuild-adduser codespace
sudo ln -sf ~/.sbuildrc /root/.sbuildrc

sudo sbuild-createchroot --include=eatmydata,ccache unstable /srv/chroot/unstable-amd64-sbuild http://ftp.us.debian.org/debian
sudo sbuild-update -udcar u
schroot -l | grep sbuild

sudo tee ~/.gbp.conf << EOF
[DEFAULT]
# the default build command:
builder = sbuild
EOF

sudo tee -a /etc/fstab << EOF
# For speeding up sbuild/schroot and prevent SSD wear-out
none /var/lib/schroot/session        tmpfs uid=root,gid=root,mode=0755 0 0
none /var/lib/schroot/union/overlay  tmpfs uid=root,gid=root,mode=0755 0 0
none /var/lib/sbuild/build           tmpfs uid=sbuild,gid=sbuild,mode=2770 0 0
EOF

#Delete chroot
#sudo rm -r /srv/chroot/unstable-amd64-sbuild/
#sudo rm /etc/schroot/chroot.d/unstable-amd64-sbuild-* /etc/sbuild/chroot/unstable-amd64-sbuild
./5_sbuild-unstable.sh