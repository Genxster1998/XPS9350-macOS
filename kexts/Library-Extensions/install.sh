#!/bin/bash

if [[ $EUID -ne 0 ]];
then
    exec sudo /bin/bash "$0" "$@"
fi

vercomp () {
    if [[ $1 == $2 ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}


cd "$( dirname "${BASH_SOURCE[0]}" )"

echo "Deleting old BrcmPatchRAM kexts..."
sudo rm -rf /Library/Extensions/BrcmPatchRAM2.kext
sudo rm -rf /Library/Extensions/BrcmPatchRAM3.kext
sudo rm -rf /Library/Extensions/BrcmFirmwareRepo.kext
sudo rm -rf /Library/Extensions/BrcmBluetoothInjector.kext

echo "Installing BrcmFirmwareRepo..."
sudo cp -r BrcmFirmwareRepo.kext /Library/Extensions/
sudo chmod -R 755 /Library/Extensions/BrcmFirmwareRepo.kext
sudo chown -R 0:0 /Library/Extensions/BrcmFirmwareRepo.kext

vercomp $(sw_vers -productVersion | sed "s:.[[:digit:]]*.$::g") 10.15
case $? in
    0) op='=';;
    1) op='>';;
    2) op='<';;
esac

if [[ $op == '=' ]]; then
    echo "Installing BrcmPatchRAM3..."
    sudo cp -r BrcmPatchRAM3.kext /Library/Extensions/
    sudo chmod -R 755 /Library/Extensions/BrcmPatchRAM3.kext
    sudo chown -R 0:0 /Library/Extensions/BrcmPatchRAM3.kext
    echo "Installing BrcmBluetoothInjector..."
    sudo cp -r BrcmBluetoothInjector.kext /Library/Extensions/
    sudo chmod -R 755 /Library/Extensions/BrcmBluetoothInjector.kext
    sudo chown -R 0:0 /Library/Extensions/BrcmBluetoothInjector.kext
elif [[ $op == '<' ]]; then
    echo "Installing BrcmPatchRAM2..."
    sudo cp -r BrcmPatchRAM2.kext /Library/Extensions/
    sudo chmod -R 755 /Library/Extensions/BrcmPatchRAM2.kext
    sudo chown -R 0:0 /Library/Extensions/BrcmPatchRAM2.kext
fi

echo "Rebuilding kext cache..."
sudo touch /Library/Extensions
sudo kextcache -i /

exit 0
