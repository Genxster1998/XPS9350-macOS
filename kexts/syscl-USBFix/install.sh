#!/bin/bash
cd `dirname $0`

# Clean legacy stuff
#

sudo rm /usr/local/sbin/sleepwatcher
sudo rm /Library/LaunchDaemons/com.syscl.externalfix.sleepwatcher.plist
sudo rm /etc/
sudo rm /etc/

# install 
sudo cp sleepwatcher /usr/local/sbin
sudo chmod 755 /usr/local/sbin/sleepwatcher
sudo chown root:wheel /usr/local/sbin/sleepwatcher
sudo cp com.syscl.externalfix.sleepwatcher.plist /Library/LaunchDaemons/
sudo chmod 644 /Library/LaunchDaemons/com.syscl.externalfix.sleepwatcher.plist
sudo chown root:wheel /Library/LaunchDaemons/com.syscl.externalfix.sleepwatcher.plist
sudo launchctl load /Library/LaunchDaemons/com.syscl.externalfix.sleepwatcher.plist
exit 0
