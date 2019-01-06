#!/bin/bash

if [[ $EUID -ne 0 ]];
then
    exec sudo /bin/bash "$0" "$@"
fi

cd "$( dirname "${BASH_SOURCE[0]}" )"

#sudo kextunload -b com.no-one.BrcmFirmwareStore
sudo rm -rf /System/Library/Extensions/BrcmFirmwareRepo.kext
sudo rm -rf /Library/Extensions/BrcmFirmwareRepo.kext
sudo cp -r BrcmFirmwareRepo.kext /Library/Extensions/
sudo chmod -R 755 /Library/Extensions/BrcmFirmwareRepo.kext
sudo chown -R 0:0 /Library/Extensions/BrcmFirmwareRepo.kext

#sudo kextunload -b com.no-one.BrcmPatchRAM2
sudo rm -rf /System/Library/Extensions/BrcmPatchRAM2.kext
sudo rm -rf /Library/Extensions/BrcmPatchRAM2.kext
sudo cp -r BrcmPatchRAM2.kext /Library/Extensions/
sudo chmod -R 755 /Library/Extensions/BrcmPatchRAM2.kext
sudo chown -R 0:0 /Library/Extensions/BrcmPatchRAM2.kext

sudo touch /Library/Extensions
sudo kextcache -i /

exit 0
