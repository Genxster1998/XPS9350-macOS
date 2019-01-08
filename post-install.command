#!/bin/bash

export LANG=C

# Bold / Non-bold
BOLD="\033[1m"
RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[1;34m"
#echo -e "\033[0;32mCOLOR_GREEN\t\033[1;32mCOLOR_LIGHT_GREEN"
OFF="\033[m"

# Repository location
REPO=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${REPO}

PLISTBUDDY="/usr/libexec/plistbuddy"
DIALOG="${REPO}/tools/dialog"
BOOTOPTION="${REPO}/tools/bootoption"
BACKTITLE="XPS 13 9350 Post-install by maz-1"

array_contains () {
    local array="$1[@]"
    local seeking=$2
    local in=1
    for element in "${!array}"; do
        if [[ $element == $seeking ]]; then
            in=0
            break
        fi
    done
    return $in
}

if [[ $EUID -ne 0 ]];
then
    git_status="$(git status -sb 2>/dev/null|head -1)"
    local_branch="$(echo "$git_status"|perl -ne '/^##\s+(\S+)\.\.\./ and print "$1\n"')"
    remote_alias="$(echo "$git_status"|perl -ne '/^##\s+\S+\.\.\.(\S+)\/[^\s\/]+\s/ and print "$1\n"')"
    remote_branch="$(echo "$git_status"|perl -ne '/^##\s+\S+\.\.\.\S+\/([^\s\/]+)\s/ and print "$1\n"')"
    if test -f ./.git/index && test "$(git log ${local_branch} --not ${remote_alias}/${remote_branch})" = ""
    then
        echo -e "${GREEN}[GIT]${OFF}: Updating local data to latest version"
        git pull ${remote_alias} ${remote_branch}
    fi
    exec sudo /bin/bash "$0" "$@"
    exit 0
fi

EFIs=$(diskutil list|perl -ne '/^\s+\d+:\s+EFI\s+.*(disk\S+)\s*$/ and print "$1\n"'|while read line; \
    do \
    VOLNAME=$(diskutil info $line|perl -ne '/Volume Name:\s*(\S.*)\s*$/ and print "$1\n"'); \
    echo "\"$line ($VOLNAME)\""; \
    done
    )
EFI_ARG="$(echo "$EFIs"|awk '{printf " %d %s\n", NR, $0}')"
CMD="${DIALOG} --title \"Choose EFI partition\" --backtitle \"${BACKTITLE}\" --menu \"Choose EFI partition on your internal drive\" 15 60 5 ${EFI_ARG} --stdout"
clear
selected_efi=$(echo "$EFIs"|sed -n $(eval $CMD)p)
test -z "$selected_efi" && selected_efi=$(echo "$EFIs"|sed -n 1p)
if test `expr $(echo "$EFIs" | wc -l) - 1` 1>/dev/null
then
    vol=$(echo $selected_efi|perl -ne '/^\"(disk\d+s\d+)/ and print "$1\n"')
    if diskutil info $vol|grep -E "Mounted:\s+Yes" >/dev/null 2>&1
    then
        mount_point=$(diskutil info $vol|perl -ne '/^\s*Mount Point:\s*(\/.*\S)\s*$/ and print "$1\n"')
    else
        vol_label=$(diskutil info $vol|perl -ne '/^\s*Volume Name:\s*(\S.*)\s*$/ and print "$1\n"')
        if test -d "/Volumes/${vol_label// /_}"
        then
            random_hex=$(hexdump -n 4 -e '4/4 "%08X" 1 "\n"' /dev/random)
            random_hex=${random_hex:0:4}
            mount_point="/Volumes/EFI_${random_hex}"
        else
            mount_point="/Volumes/${vol_label// /_}"
        fi
        mkdir ${mount_point}
        mount -t msdos /dev/$vol ${mount_point} || ${DIALOG} --title 'Error!' --backtitle "${BACKTITLE}" --msgbox "Cannot mount specified EFI partition" 6 50 --stdout
    fi
fi


clover_path_new="$(${DIALOG} --title "Verify clover folder" --backtitle "${BACKTITLE}" --inputbox "Is this the correct clover path? If not, modify it." 8 50 "${mount_point}/EFI/CLOVER" --stdout)"
test -z "$clover_path_new" || clover_path="$clover_path_new"
clear
#echo $clover_path
if test -f ./.git/index && test "$(cat "$clover_path/XPS9350_REV" 2>/dev/null)" != "$(git rev-parse --short HEAD 2>/dev/null)" || test ! -f "$clover_path/XPS9350_REV"
then
    mkdir -p "$clover_path"
    cp -f ./CLOVER/config.plist "$clover_path/../"
    mv -f "$clover_path/config.plist" "$clover_path/../" 2>/dev/null
    mv -f "$clover_path/themes" "$clover_path/../clover_themes" 2>/dev/null
    rm -rf "$clover_path"
    mkdir -p "$clover_path"
    cp -r ./CLOVER/* "$clover_path/"
    mv -n "$clover_path/../clover_themes"/* "$clover_path/themes" 2>/dev/null
    rm -rf "$clover_path/../clover_themes"
    if test -f ./.git/index
    then
        git rev-parse --short HEAD > "$clover_path/XPS9350_REV"
    else
        test -f ./XPS9350_REV && cat ./XPS9350_REV > "$clover_path/XPS9350_REV"
    fi
    
    for i in ACPI Boot BootGraphics CPU Devices Graphics KernelAndKextPatches SystemParameters; do
        ${PLISTBUDDY} -c "Delete ':$i'" "$clover_path/../config.plist" 2>/dev/null
    done
    
    if [ `${PLISTBUDDY} -c "Print :SMBIOS:SerialNumber" "$clover_path/../config.plist"` != 'FAKESERIAL' ]
    then
        ${DIALOG} --title "Warning" --backtitle "${BACKTITLE}" --yesno "Preserve existing SMBIOS settings?" 6 60 --stdout || smbios_db="1"
        clear
    else
        smbios_db="1"
    fi
    if test "$smbios_db" = "1" 
    then
        gProductArr=['MacBookPro13,2','MacBookPro13,1','MacBook9,1']
        gProductName=`${PLISTBUDDY} -c "Print ':SMBIOS:ProductName'" "$clover_path/../config.plist"`
        array_contains gProductArr "${gProductName}" || gProductName="MacBookPro13,2"
        gGenerateSerialAndMLB=`"${REPO}"/tools/macserial "${gProductName}" -n 1`
        gGenerateSerial=`echo ${gGenerateSerialAndMLB}|grep -oE '^\S+'`
        gGenerateMLB=`echo ${gGenerateSerialAndMLB}|grep -oE '\S+$'`
        gGenerateUUID=$(uuidgen)
        ${PLISTBUDDY} -c "Add ':RtVariables:MLB' string" "$clover_path/../config.plist" 2>/dev/null
        ${PLISTBUDDY} -c "Set ':RtVariables:MLB' ${gGenerateMLB}" "$clover_path/../config.plist"
        
        ${PLISTBUDDY} -c "Add ':RtVariables:ROM' string" "$clover_path/../config.plist" 2>/dev/null
        ${PLISTBUDDY} -c "Set ':RtVariables:ROM' UseMacAddr0" "$clover_path/../config.plist"
        
        ${PLISTBUDDY} -c "Add ':SMBIOS:SerialNumber' string" "$clover_path/../config.plist" 2>/dev/null
        ${PLISTBUDDY} -c "Set ':SMBIOS:SerialNumber' ${gGenerateSerial}" "$clover_path/../config.plist"
        
        ${PLISTBUDDY} -c "Add ':SMBIOS:BoardSerialNumber' string" "$clover_path/../config.plist" 2>/dev/null
        ${PLISTBUDDY} -c "Set ':SMBIOS:BoardSerialNumber' ${gGenerateMLB}" "$clover_path/../config.plist"
        
        ${PLISTBUDDY} -c "Add ':SMBIOS:SmUUID' string" "$clover_path/../config.plist" 2>/dev/null
        ${PLISTBUDDY} -c "Set ':SMBIOS:SmUUID' ${gGenerateUUID}" "$clover_path/../config.plist"
    fi
    ${PLISTBUDDY} -c "Delete ':GUI'" "$clover_path/config.plist" 2>/dev/null
    ${PLISTBUDDY} -c "Delete ':RtVariables'" "$clover_path/config.plist" 2>/dev/null
    ${PLISTBUDDY} -c "Delete ':SMBIOS'" "$clover_path/config.plist" 2>/dev/null
    ${PLISTBUDDY} -c "Merge \"$clover_path/../config.plist\"" "$clover_path/config.plist"
    rm -f "$clover_path/../config.plist"
    #
    # Fix HiDPI boot graphics issue
    #
    gEDID=$(ioreg -lw0 | grep -i "IODisplayEDID" | sed -e 's/.*<//' -e 's/>//')
    gHorizontalRez_pr=${gEDID:116:1}
    gHorizontalRez_st=${gEDID:112:2}
    gHorizontalRez=$((0x$gHorizontalRez_pr$gHorizontalRez_st))
    gVerticalRez_pr=${gEDID:122:1}
    gVerticalRez_st=${gEDID:118:2}
    gVerticalRez=$((0x$gVerticalRez_pr$gVerticalRez_st))
    ${PLISTBUDDY} -c "Add ':BootGraphics:EFILoginHiDPI' string" "$clover_path/config.plist" 2>/dev/null
    ${PLISTBUDDY} -c "Add ':BootGraphics:UIScale' string" "$clover_path/config.plist" 2>/dev/null
    if [[ $gHorizontalRez -gt 1920 || $gSystemHorizontalRez -gt 1920 ]];
    then
      ${PLISTBUDDY} -c "Set :BootGraphics:EFILoginHiDPI 1" "$clover_path/config.plist"
      ${PLISTBUDDY} -c "Set :BootGraphics:UIScale 2" "$clover_path/config.plist"
    else
      ${PLISTBUDDY} -c "Set :BootGraphics:EFILoginHiDPI 0" "$clover_path/config.plist"
      ${PLISTBUDDY} -c "Set :BootGraphics:UIScale 1" "$clover_path/config.plist"
    fi
    # install CPUFriend
    gCpuName=$(sysctl machdep.cpu.brand_string |sed -e "/.*) /s///" -e "/ CPU.*/s///")
    if test -d ./kexts/cpupm/${gCpuName}
    then
        rm -rf "$clover_path/kexts/Other/CPUFriend.kext"
        rm -rf "$clover_path/kexts/Other/CPUFriendDataProvider.kext"
        rm -f "$clover_path/ACPI/patched/SSDT-CpuFriend.aml"
        cp -r ./kexts/cpupm/CPUFriend.kext "$clover_path/kexts/Other/"
        cp -f ./kexts/cpupm/${gCpuName}/SSDT-CpuFriend.aml "$clover_path/ACPI/patched/"
    fi
    
    # add uefi entry for clover
    rm -f /tmp/entry_exists
    EFI_UUID=$(diskutil info "$(echo $clover_path|sed -e 's|/[Ee][Ff][Ii]/[Cc][Ll][Oo][Vv][Ee][Rr]||g')"|perl -ne '/Partition UUID:\s+(\S{8}-\S{4}-\S{4}-\S{4}-\S{12})/ and print "$1\n"')
    ROOT_UUID=$(diskutil info /|perl -ne '/Partition UUID:\s+(\S{8}-\S{4}-\S{4}-\S{4}-\S{12})/ and print "$1\n"')
    ${BOOTOPTION} list|perl -ne '/\s+(\d+|--):\s+(Boot\d+)\s+/ and print "$2\n"'|while read line
    do
        entry_props="$(${BOOTOPTION} info $line)"
        entry_uuid=$(echo "$entry_props"|perl -ne '/Partition UUID: (\S{8}-\S{4}-\S{4}-\S{4}-\S{12})/ and print "$1\n"')
        entry_name=$(echo "$entry_props"|perl -ne '/Description:\s+(\S.*\S)\s*$/ and print "$1\n"')
        entry_path=$(echo "$entry_props"|perl -ne '/Loader Path:\s+(\S.*\S)\s*$/ and print "$1\n"')
        if test "$ROOT_UUID" = "$entry_uuid" && test "${entry_name}" = "Mac OS X"
        then
            ${BOOTOPTION} delete -n $line
        fi
        if [ "$entry_uuid" = "$EFI_UUID" ]
        then
            entry_path=$(echo $entry_path|tr [a-z] [A-Z]|sed -e 's/^\\//g')
            if [[ "$entry_path" == "EFI\CLOVER\CLOVERX64.EFI" ]]
            then
                touch /tmp/entry_exists
            fi
        fi
    done
    if test ! -f /tmp/entry_exists
    then
        ${BOOTOPTION} create -l "$clover_path/CLOVERX64.efi" -d "CLOVER"
    fi
    rm -f /tmp/entry_exists
fi
# optional operations
optional_ops=$(${DIALOG} --checklist "Select optional tweaks" 10 60 4 \
1 "Enable TRIM support for 3rd party SSD" off \
2 "Enable 3rd Party application support" off \
3 "Disable TouchID launch daemons" off \
--stdout)
clear
if [[ $optional_ops == *"1"* ]]; then
    echo -e "${BOLD}Enabling TRIM support for 3rd party SSD...${OFF}"
    trimforce enable
fi
if [[ $optional_ops == *"2"* ]]; then
    echo -e "${BOLD}Enabling 3rd Party application support...${OFF}"
    spctl --master-disable
fi
if [[ $optional_ops == *"3"* ]]; then
    echo -e "${BOLD}Disabling TouchID launch daemons...${OFF}"
    launchctl remove -w /System/Library/LaunchDaemons/com.apple.biometrickitd.plist
    launchctl remove -w /System/Library/LaunchDaemons/com.apple.biokitaggdd.plist
fi
# install kexts & daemons
echo -e "${BOLD}Installing ComboJack...${OFF}"
./kexts/ComboJack_Installer/install.sh
echo -e "${BOLD}Installing USBFix...${OFF}"
./kexts/USBFix/install.sh
echo -e "${BOLD}Installing kexts...${OFF}"
./kexts/Library-Extensions/install.sh

${DIALOG} --title "Done" --backtitle "${BACKTITLE}" --msgbox "Done, restart to take effect." 6 60 --stdout
clear