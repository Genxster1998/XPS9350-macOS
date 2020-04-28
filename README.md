# macOS on Dell XPS 9350

This repository contains a sample configuration to run macOS (Currently Mojave Sierra `10.14.2`) on a Dell XPS 9350

## Used Hardware Configuration (Dell XPS 9350)

- Intel i7-6560U
- 8GB RAM
- Sharp `SHP144` `LQ133Z1` QHD+ (3200x1800) Touchscreen display
- [PLEXTOR 512GB SSD](http://www.goplextor.com/Product/Detail/M6G-2280) (PLEXTOR PX-512M6G-2280) on latest firmware
- Dell DW1830 Wireless
  - Wi-Fi device ID [`14e4:43ba`]
  - Bluetooth device ID [`0a5c:6410`], chipset `20703A1`
- Webcam, device ID [`05ac:8600`]
- RTS525A SD card reader
- BIOS version `1.9.0`


## Installation

* Clone latest version of this repo: `git clone https://github.com/hackintosh-stuff/XPS9350-macOS`
* Create a Mojave installer disk (USB or other removable disk).
  - Download Mojave installer and write it to the installer disk (Google how to).
  - Install Clover with UEFI only and UEFI64Drivers to the installer disk just created.
  - Mount EFI partition on the installer disk and replace the original CLOVER folder with the one shipped with this repo (`XPS9350-macOS\CLOVER`).
* Change BIOS settings to the following
  - Disable Secure Boot
  - Set SATA Operation to AHCI
* Boot the installer disk and install.
* Boot installed OS and run `XPS9350-macOS\post-install.command`, follow its guidance until post-installation is done.

For a detailed installation description see [README_FULL.md](https://github.com/hackintosh-stuff/XPS9350-macOS/blob/master/README_FULL.md)


## Credits

- [XPS 13 9350 setup by syscl](https://github.com/syscl/XPS9350-macOS)
- [XPS 13 9360 setup by the-darkvoid](https://github.com/the-darkvoid/XPS9360-macOS)
- [OS-X-Clover-Laptop-Config (Hot-patching)](https://github.com/RehabMan/OS-X-Clover-Laptop-Config)
- [Dell XPS 13 9360 Guide by bozma88](https://www.tonymacx86.com/threads/guide-dell-xps-13-9360-on-macos-sierra-10-12-x-lts-long-term-support-guide.213141/)
- [VoodooI2C on XPS 13 9360 by Vygr10565](https://www.tonymacx86.com/threads/guide-dell-xps-13-9360-on-macos-sierra-10-12-x-lts-long-term-support-guide.213141/page-202#post-1708487)
- [USB-C Hotplug through ExpressCard by dpassmor](https://www.tonymacx86.com/threads/usb-c-hotplug-questions.211313/)
- Kext authors mentioned in [kexts/kexts.txt](https://github.com/hackintosh-stuff/XPS9360-macOS/blob/master/kexts/kexts.txt)
