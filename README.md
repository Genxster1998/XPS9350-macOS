# macOS on Dell XPS 9350

This repository contains a sample configuration to run macOS (Currently Mojave Sierra `10.14.1`) on a Dell XPS 9350

## Used Hardware Configuration

- Dell XPS 9350
  - Intel i7-6560U
  - 8GB RAM
  - Sharp `SHP144` `LQ133Z1` QHD+ (3200x1800) Touchscreen display
  - [PLEXTOR 512GB SSD](http://www.goplextor.com/Product/Detail/M6G-2280) (PLEXTOR PX-512M6G-2280) on latest firmware
    - Formatted for APFS with 4K sectors, using [nvme-cli](https://github.com/linux-nvme/nvme-cli) using this [guide](https://www.tonymacx86.com/threads/guide-sierra-on-hp-spectre-x360-native-kaby-lake-support.228302/)
  - Dell DW1830 Wireless (Taobao)
    - Wi-Fi device ID [`14e4:43ba`], shows as Apple Airport Extreme
    - Bluetooth device ID [`0a5c:6410`], chipset `20703A1` with firmware `v5 c4518` using `BrcmPatchRAM2.kext`
  - Webcam, device ID [`05ac:8600`], works out of the box
  - Disabled devices
    - SD card reader, [macOS open-source project](https://github.com/syscl/Sinetek-rtsx)

- Firmware Revisions
  - BIOS version `1.9.0`

- External Devices
  - [Dell WD15 USB-C Dock](https://www.dell.com/support/article/us/en/04/sln304627/dell-dock-wd15-usb-type-c-information-compatibility-and-specifications)
    - Supports USB-C PD (Power Delivery), Ethernet, 3x USB-3, 2x 3.5mm jack, VGA, HDMI & DisplayPort connections


## Preparation

This repository has been tested against Dell XP 9350 bios version `1.9.0`. For best results ensure this is the bios version of the target machine.

## UEFI Variables

In order to run macOS successfully a number of EFI BIOS variables need to be modified. The included Clover bootloader contains an updated `DVMT.efi`, which includes a `setup_var` command to help do just that.

`DVMT.efi` can be launched from Clover directly by renaming it to `Shell64U.efi` in the `tools` folder.

The following variables need to be updated:

| Variable              | Offset | Default value  | Desired value   | Comment                                                    |
|-----------------------|--------|----------------|-----------------|------------------------------------------------------------|
| CFG Lock              | 0x109  | 0x01 (Enabled) | 0x00 (Disabled) | Disable CFG Lock to prevent MSR 0x02 errors on boot        |
| DVMT Pre-allocation   | 0x432  | 0x01 (32M)     | 0x06 (192M)     | Increase DVMT pre-allocated size to 192M for QHD+ displays |
| DVMT Total Gfx Memory | 0x433  | 0x01 (128M)    | 0x03 (MAX)      | Increase total gfx memory limit to maximum                 |

## Clover Configuration

All Clover hotpatches are included in source DSL format in the DSDT folder.
If required the script `--compile-dsdt` option can be used to compile any changes to the DSL files into `./CLOVER/ACPI/patched`.

## AppleHDA

In order to support the Realtek ALC256 (ALC3246) codec of the Dell XPS 9350, AppleALC is included with layout-id `13`.

Alternatively, a custom AppleHDA injector can be used.
The script option `--patch-hda` option generates an AppleHDA_ALC256.kext injector and installs it in `/Library/Extensions`.

For combo jack support and startup/wakeup fix run `kexts/ComboJack_Installer/install.sh`

## USB

If usb disks get ejected upon sleep/wake, run `kexts/syscl-USBFix/install.sh` to install a daemon that safely unmount usb disks before sleep and remount after wake.

Type-c hotplug works, but when you want to wake up the laptop, detach type-c device first, or the type-c port will become invalid, in this case you will have to sleep/wake again to bring type-c back.


## Display Profiles

Display profiles for the Sharp LQ133Z1 display (Dell XPS 9350 QHD+) are included in the displays folder.

Profiles can be installed by copying them into `/Users/<username>/Library/ColorSync/Profiles` folder, additionally the macOS built-in `ColorSync` utility can be used to inspect the profiles.

Profiles are configured on a per display basis in the `System Preferences` -> `Display` preferences menu.

## CPU Profile

In order for macOS to effectively manage the power profile of the i7-6560U processor in the Dell XPS 9350 model used here, it is necessary to include a powermanagement profile for `X86PlatformPlugin`.

A pre-built `CPUFriend.kext` and `SSDT-CpuFriend.aml` is included in the `kext` folder for the i7-6560U.

Instructions on how to build a power mangaement profile for any other CPU types can be found here:

https://github.com/PMheart/CPUFriend/blob/master/Instructions.md

## Undervolting

**Warning: [undervolting](https://en.wikipedia.org/wiki/Dynamic_voltage_scaling) may render your XPS 9350 unusable.**

**Ensure that the variable offset is correct for your current bios.**

* Dump your bios with [Fptw64](https://overclocking.guide/download/flash-programming-tool/): `fptw64.exe -d bios.bin -bios`
* Open dumped bios with [UEFITool](https://github.com/LongSoft/UEFITool), search for "BIOS LOCK" and you will find the section for bios settings, extract the section, let's say the extracted file is `Section_PE32_image_Setup_Setup.sct`
* Open `Section_PE32_image_Setup_Setup.sct` with [Universal IFR Extractor](https://github.com/donovan6000/Universal-IFR-Extractor) and click extract, there will be a file named `Section_PE32_image_Setup_Setup IFR.txt`
* Open `Section_PE32_image_Setup_Setup IFR.txt` and you will see all the hidden settings.

Essentially undervolting allows your processor to run on a lower voltage than its specifications, reducing the core temperature.

This allows longer battery life and longer turbo boost.

The undervolt settings I use are configured in UEFI, with the following settings:

- Overclock & SpeedShift enable  
  `0x3D` -> `01`  
  `0xD8` -> `01`  

- Undervolt values:  
  `0x42` -> `0x64` (CPU: -100 mV)  
  `0x44` -> `01`   (Negative voltage for `0x653`)  
  `0x502` -> `0x1E` (GPU: -30 mV)  
  `0x504` -> `01`   (Negative voltage for `0x85A`)

Remember, these values work for my specific machine, but might cause any other laptop to fail to boot! **Test with Intel XTU or ThrottleStop first!**

## HiDPI
For a fhd display, use [one-key-hidpi](https://github.com/xzhih/one-key-hidpi)

## Credits

- [XPS 13 9350 setup by syscl](https://github.com/syscl/XPS9350-macOS)
- [OS-X-Clover-Laptop-Config (Hot-patching)](https://github.com/RehabMan/OS-X-Clover-Laptop-Config)
- [Dell XPS 13 9360 Guide by bozma88](https://www.tonymacx86.com/threads/guide-dell-xps-13-9360-on-macos-sierra-10-12-x-lts-long-term-support-guide.213141/)
- [VoodooI2C on XPS 13 9630 by Vygr10565](https://www.tonymacx86.com/threads/guide-dell-xps-13-9360-on-macos-sierra-10-12-x-lts-long-term-support-guide.213141/page-202#post-1708487)
- [USB-C Hotplug through ExpressCard by dpassmor](https://www.tonymacx86.com/threads/usb-c-hotplug-questions.211313/)
- Kext authors mentioned in [kexts/kexts.txt](https://github.com/hackintosh-stuff/XPS9360-macOS/blob/master/kexts/kexts.txt)
