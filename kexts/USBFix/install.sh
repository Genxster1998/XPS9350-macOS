#!/bin/bash
cd `dirname $0`

# Clean legacy stuff
#

sudo rm /usr/local/sbin/sleepwatcher
sudo launchctl unload /Library/LaunchDaemons/com.syscl.externalfix.sleepwatcher.plist
sudo rm /Library/LaunchDaemons/com.syscl.externalfix.sleepwatcher.plist
sudo rm /etc/sysclusbfix.sleep
sudo rm /etc/sysclusbfix.wake
sudo rm /etc/sysclusbfix.unplug

sudo rm /usr/local/sbin/USBFix
sudo launchctl unload /Library/LaunchDaemons/com.maz1.USBFix.plist
sudo rm /Library/LaunchDaemons/com.maz1.USBFix.plist

# install 

sudo cp USBFix /usr/local/sbin
sudo chmod 755 /usr/local/sbin/USBFix
sudo chown root:wheel /usr/local/sbin/USBFix
sudo chmod u+s /usr/local/sbin/USBFix

sudo cp com.maz1.USBFix.plist /Library/LaunchDaemons/
sudo chmod 644 /Library/LaunchDaemons/com.maz1.USBFix.plist
sudo chown root:wheel /Library/LaunchDaemons/com.maz1.USBFix.plist
sudo launchctl load /Library/LaunchDaemons/com.maz1.USBFix.plist
exit 0
