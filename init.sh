#!/bin/sh 

./1_settingup-codespace-for-debian-packaging.sh
./2_generate-gnupg-key.sh
./3_copy-workspaces-to-home-codespace.sh
./4_create-chroot.sh

sudo reboot