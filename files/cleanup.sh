#!/bin/sh

set -e

echo '--- Running cleanup.sh ---'

echo '--- Rebooting ---'
# Finally restart
# See https://github.com/hashicorp/packer/issues/3487 for why this is used
nohup shutdown --reboot now </dev/null >/dev/null 2>&1 &

echo 'Cleaning up after bootstrapping and rebooting...'
sudo apt-get -y autoremove
sudo apt-get -y clean
sudo rm -rf /tmp/*
cat /dev/null > ~/.bash_history
exit