#!/bin/bash

if [ "$(id -u)" != "0" ]; then
  exec sudo "$0" "$@"
fi



if (ioreg | grep AppleThunderboltNHI >/dev/null)
then
	true
else
	/usr/local/bin/usb_eject 0x00100000
	USB2_RESULT=$?
	/usr/local/bin/usb_eject 0x00200000
	USB3_RESULT=$?
	if [[ $USB2_RESULT -eq 0 || $USB3_RESULT -eq 0 ]]; then
		osascript <<'END'
tell application "System Events"
    tell application process "SystemUIServer"
        set ExpressCardProperties to item 1 of (get properties of every menu bar item of menu bar 1 whose description starts with "PC Card")
    end tell
    set iconXpos to (item 1 of position in ExpressCardProperties) + ((item 1 of size in ExpressCardProperties) / 2) as integer
    set iconYpos to (item 2 of position in ExpressCardProperties) + ((item 2 of size in ExpressCardProperties) / 2) as integer
    set menuYpos to ((item 2 of size in ExpressCardProperties) * 2.5) as integer
end tell
tell current application
    do shell script "/usr/local/bin/cliclick kd:alt c:" & iconXpos & "," & iconYpos & " ku:alt"
    do shell script "/usr/local/bin/cliclick kd:alt c:" & iconXpos & "," & menuYpos & " ku:alt"
end tell
END
	fi
fi

sleep 1

pmset sleepnow