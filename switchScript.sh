#!/bin/sh
set -e

### Credit to the Authors at https://rentry.org/CFWGuides
### Script created by Fraxalotl
### Mod by huangqian8
### Mod by xiaobai

# -------------------------------------------

# Function to download and process a GitHub Release asset
# Arguments:
# $1: Repository name (e.g., Atmosphere-NX/Atmosphere)
# $2: Asset file pattern to download (e.g., '*.zip', 'fusee.bin') - can be a regex pattern
# $3: Local filename to save the downloaded asset
# $4: Target directory for unzipped contents (optional, if not a zip, pass empty string)
# $5: Name to include in description.txt (optional, defaults to repo name)
# $6: Specific file name to extract from zip (optional, for extracting a single file like .nro or .bin)
# $7: Destination directory for the extracted file (optional, used with $6)
download_github_release() {
    local repo="$1"
    local asset_pattern="$2"
    local local_filename="$3"
    local target_dir="$4"
    local description_name="${5:-$repo}" # Default to repo name if not provided
    local specific_file="$6"
    local specific_file_dest="$7"

    echo "--- Processing GitHub Release: $repo ---"
    echo "Fetching latest release info for $repo..."

    # Capture curl output and status separately, piping through sed to remove non-printable and non-space characters
    release_info=$(curl -sL "https://api.github.com/repos/$repo/releases/latest" | sed 's/[^[:print:][:space:]]//g')
    local curl_status=$? # Capture curl exit status immediately

    # Check curl status first
    if [ $curl_status -ne 0 ]; then
        echo "Error: curl failed to fetch release info for $repo (exit status $curl_status).\\033[31m failed\\\\033[0m."
        # Optionally print release_info here for debugging if curl failed but still produced output
        # echo "Curl output: $release_info"
        return 1
    fi

    # Now check if the output is valid JSON using jq
    # After cleaning potentially problematic characters with sed
    if ! echo "$release_info" | jq -e . > /dev/null; then
        echo "Error: Fetched data for $repo is not valid JSON after cleaning.\\033[31m failed\\\\033[0m."
        # Print the problematic output for debugging
        echo "Problematic output: $release_info"
        return 1
    fi

    # If both checks pass, proceed with parsing and downloading
    release_name=$(echo "$release_info" | jq -r '.name // .tag_name') # Use name if available, otherwise tag_name
    download_url=$(echo "$release_info" | jq -r ".assets[] | select(.name | match(\"$asset_pattern\")) | .browser_download_url")

    if [ -z "$release_name" ]; then
        echo "Warning: Could not extract release name for $repo."
        release_name="Unknown Release"
    fi

    if [ -z "$download_url" ]; then
        echo "Error: Could not find asset matching '$asset_pattern' for $repo\033[31m failed\\033[0m."
        echo "Available assets:"
        echo "$release_info" | jq -r '.assets[].name'
        return 1
    fi

    # Add release name to description.txt
    echo "$description_name $release_name" >> ../description.txt
    echo "Downloading $local_filename from $download_url..."

    # Download the file
    curl -sL "$download_url" -o "$local_filename"

    if [ $? -ne 0 ]; then
        echo "$local_filename download\033[31m failed\\033[0m."
        return 1
    fi

    if [ ! -s "$local_filename" ]; then
        echo "$local_filename download\033[31m failed\033[0m: Downloaded file is missing or empty."
        return 1
    fi

    echo "$local_filename download\033[32m success\033[0m."

    # Process the downloaded file (unzip, move, or extract specific file)
    if [ -n "$target_dir" ]; then # If target_dir is provided, assume it's a zip file to be unzipped
        echo "Unzipping $local_filename to $target_dir..."
        if unzip -oq "$local_filename" -d "$target_dir"; then
             echo "$local_filename extraction\033[32m success\033[0m."
        else
             echo "$local_filename extraction\033[31m failed\033[0m."
             # Optionally, keep the failed zip file for debugging
             # rm "$local_filename"
             return 1
        fi
    elif [ -n "$specific_file" ] && [ -n "$specific_file_dest" ]; then # If specific_file and destination are provided, extract specific file
        echo "Extracting $specific_file from $local_filename to $specific_file_dest..."
        # Ensure destination directory exists for specific file extraction
        mkdir -p "$specific_file_dest"
        if unzip -oq "$local_filename" "$specific_file" -d "$specific_file_dest"; then
            echo "$specific_file extraction\033[32m success\033[0m."
        else
            echo "$specific_file extraction\033[31m failed\033[0m."
            # Optionally, keep the failed zip file for debugging
            # rm "$local_filename"
            return 1
        fi
    else # Otherwise, assume it's a single file to be moved (default destination ./bootloader/payloads/)
        echo "Moving $local_filename to ./bootloader/payloads/..."
        # Ensure destination directory exists for single file move
        mkdir -p ./bootloader/payloads/
        if mv "$local_filename" ./bootloader/payloads/; then
            echo "$local_filename move\033[32m success\033[0m."
        else
            echo "$local_filename move\033[31m failed\033[0m."
            return 1
        fi
    fi

    # Clean up the downloaded file unless it was a specific file extraction
    if [ -z "$specific_file" ] || [ -z "$specific_file_dest" ]; then
        rm "$local_filename"
    fi

    echo "--- Finished processing $repo ---"
    echo "" # Add a blank line for better readability

    return 0 # Indicate success
}


# Function to download a single file from a direct URL
# Arguments:
# $1: Download URL
# $2: Local filename to save
# $3: Target directory to move after download (optional)
# $4: Name to include in description.txt (optional)
download_direct_file() {
    local url="$1"
    local local_filename="$2"
    local target_dir="$3"
    local description_name="$4"

    echo "--- Processing direct download: $local_filename ---"
    echo "Downloading $local_filename from $url..."
    curl -sL "$url" -o "$local_filename"

if [ $? -ne 0 ]; then
        echo "$local_filename download\033[31m failed\\033[0m."
        return 1
    fi

    if [ ! -s "$local_filename" ]; then
        echo "$local_filename download\033[31m failed\033[0m: Downloaded file is missing or empty."
        return 1
    fi

    echo "$local_filename download\033[32m success\033[0m."

    if [ -n "$target_dir" ]; then
        echo "Moving $local_filename to $target_dir..."
        mkdir -p "$target_dir" # Ensure target directory exists
        if mv "$local_filename" "$target_dir/"; then
            echo "$local_filename move\033[32m success\033[0m."
        else
            echo "$local_filename move\033[31m failed\033[0m."
            return 1
        fi
    fi

    if [ -n "$description_name" ]; then
         # Attempt to extract filename from URL for description if description_name is provided but no explicit name
         local base_filename=$(basename "$url")
         echo "$description_name $base_filename" >> ../description.txt
    fi

    echo "--- Finished processing direct download: $local_filename ---"
    echo "" # Add a blank line for better readability

    return 0 # Indicate success
}


# -------------------------------------------
# Main Script Execution Starts Here
# -------------------------------------------

echo "Starting Switch Script..."
echo "-----------------------------------------"

### Create a new folder for storing files and necessary subdirectories
echo "Setting up directory structure..."
if [ -d SwitchSD ]; then
  echo "Removing existing SwitchSD directory..."
  rm -rf SwitchSD
fi
if [ -e description.txt ]; then
  echo "Removing existing description.txt file..."
  rm -rf description.txt
fi

mkdir -p ./SwitchSD
cd SwitchSD

# Create necessary subdirectories upfront
mkdir -p atmosphere/config
mkdir -p atmosphere/hosts
mkdir -p config/tesla
mkdir -p bootloader/payloads
mkdir -p switch
mkdir -p atmosphere/contents # Common for overlays
mkdir -p config/sys-con # Potential config location
mkdir -p config/MissionControl # Potential config location
mkdir -p mods # Based on SimpleModManager needing this
mkdir -p config/ultrahand # For overlays.ini and lang files
mkdir -p config/ultrahand/lang # For language files
mkdir -p switch/.packages # For OC Toolkit
mkdir -p atmosphere/kips # For loader.kip

echo "Directory structure created."
echo "-----------------------------------------"

# Now call the functions to download and process files

# Fetch latest atmosphere
download_github_release "Atmosphere-NX/Atmosphere" "*.zip" "atmosphere.zip" "./" "Atmosphere" || { echo "Atmosphere processing failed. Exiting."; exit 1; }

# Fetch latest fusee.bin
download_github_release "Atmosphere-NX/Atmosphere" "fusee.bin" "fusee.bin" "" "fusee.bin" || { echo "fusee.bin processing failed. Exiting."; exit 1; }

# Fetch latest hekate (EasyWorld大佬的汉化版本)
download_github_release "easyworld/hekate" "*_sc.zip" "hekate.zip" "./" "Hekate + Nyx" || { echo "Hekate + Nyx processing failed. Exiting."; exit 1; }

# Fetch logo (direct download)
download_direct_file "https://raw.githubusercontent.com/Zhuwenxue2002/SwitchPlugins/main/theme/logo.zip" "logo.zip" "./" "logo" || { echo "logo processing failed. Exiting."; exit 1; }

# Fetch latest Lockpick_RCM
download_github_release "impeeza/Lockpick_RCMDecScots" "*.zip" "Lockpick_RCM.zip" "" "Lockpick_RCM.bin" "Lockpick_RCM.bin" "./bootloader/payloads" || { echo "Lockpick_RCM processing failed. Exiting."; exit 1; }

# Fetch latest TegraExplorer.bin
download_github_release "suchmememanyskill/TegraExplorer" "*.bin" "TegraExplorer.bin" "" "TegraExplorer" || { echo "TegraExplorer processing failed. Exiting."; exit 1; }

# Fetch latest 90DNS tester (downloads a .nro)
download_github_release "meganukebmp/Switch_90DNS_tester" "*.nro" "Switch_90DNS_tester.nro" "./switch/Switch_90DNS_tester" "Switch_90DNS_tester" || { echo "Switch_90DNS_tester processing failed. Exiting."; exit 1; }

# Fetch latest DBI (downloads a .nro)
download_github_release "rashevskyv/dbi" "*.nro" "DBI.nro" "./switch/DBI" "DBI" || { echo "DBI processing failed. Exiting."; exit 1; }

# Fetch latest Awoo Installer (downloads a .zip)
download_github_release "dragonflylee/Awoo-Installer" "*.zip" "Awoo-Installer.zip" "./" "Awoo Installer" || { echo "Awoo Installer processing failed. Exiting."; exit 1; }

# Fetch latest Hekate-toolbox (downloads a .nro)
download_github_release "WerWolv/Hekate-Toolbox" "*.nro" "HekateToolbox.nro" "./switch/HekateToolbox" "HekateToolbox" || { echo "HekateToolbox processing failed. Exiting."; exit 1; }

# Fetch latest NX-Activity-Log (downloads a .nro)
download_github_release "zdm65477730/NX-Activity-Log" "*.nro" "NX-Activity-Log.nro" "./switch/NX-Activity-Log" "NX-Activity-Log" || { echo "NX-Activity-Log processing failed. Exiting."; exit 1; }

# Fetch latest JKSV (downloads a .nro)
download_github_release "J-D-K/JKSV" "*.nro" "JKSV.nro" "./switch/JKSV" "JKSV" || { echo "JKSV processing failed. Exiting."; exit 1; }

# Fetch latest aio-switch-updater (downloads a .zip)
download_github_release "HamletDuFromage/aio-switch-updater" "*.zip" "aio-switch-updater.zip" "./" "aio-switch-updater" || { echo "aio-switch-updater processing failed. Exiting."; exit 1; }

# Fetch latest wiliwili (downloads a .zip, needs specific file extraction)
download_github_release "xfangfang/wiliwili" "*NintendoSwitch.zip" "wiliwili-NintendoSwitch.zip" "" "wiliwili" "wiliwili/wiliwili.nro" "./switch/wiliwili" || { echo "wiliwili processing failed. Exiting."; exit 1; }

# Fetch latest SimpleModDownloader (downloads a .nro)
download_github_release "PoloNX/SimpleModDownloader" "*.nro" "SimpleModDownloader.nro" "./switch/SimpleModDownloader" "SimpleModDownloader" || { echo "SimpleModDownloader processing failed. Exiting."; exit 1; }

# Fetch latest SimpleModManager (downloads a .nro)
download_github_release "nadrino/SimpleModManager" "*.nro" "SimpleModManager.nro" "./switch/SimpleModManager" "SimpleModManager" || { echo "SimpleModManager processing failed. Exiting."; exit 1; }

# Fetch latest Moonlight (downloads a .nro)
download_github_release "XITRIX/Moonlight-Switch" "*.nro" "Moonlight-Switch.nro" "./switch/Moonlight-Switch" "Moonlight" || { echo "Moonlight processing failed. Exiting."; exit 1; }

# Fetch latest ezRemote (downloads a .nro)
download_github_release "cy33hc/switch-ezremote-client" "*.nro" "ezremote-client.nro" "./switch/ezremote-client" "switch-ezremote-client" || { echo "ezremote-client processing failed. Exiting."; exit 1; }

# Fetch latest hb-appstore (downloads a .nro)
download_github_release "fortheusers/hb-appstore" "*.nro" "appstore.nro" "./switch/appstore" "hb-appstore" || { echo "hb-appstore processing failed. Exiting."; exit 1; }

# Fetch latest switch-nsp-forwarder (downloads a .nro)
download_github_release "TooTallNate/switch-nsp-forwarder" "*.nro" "nsp-forwarder.nro" "./switch/nsp-forwarder" "switch-nsp-forwarder" || { echo "switch-nsp-forwarder processing failed. Exiting."; exit 1; }

# Fetch latest MissionControl (downloads a .zip)
download_github_release "ndeadly/MissionControl" "*.zip" "MissionControl.zip" "./" "MissionControl" || { echo "MissionControl processing failed. Exiting."; exit 1; }

# Fetch latest sys-con (downloads a .zip)
download_github_release "o0Zz/sys-con" "*.zip" "sys-con.zip" "./" "sys-con" || { echo "sys-con processing failed. Exiting."; exit 1; }

# Fetch latest nx-ovlloader (downloads a .zip)
download_github_release "zdm65477730/nx-ovlloader" "*.zip" "nx-ovlloader.zip" "./" "nx-ovlloader" || { echo "nx-ovlloader processing failed. Exiting."; exit 1; }

# Fetch lastest QuickNTP (downloads a .zip) - Assuming it extracts to the current directory (./SwitchSD)
download_github_release "zdm65477730/QuickNTP" "*.zip" "QuickNTP.zip" "./" "QuickNTP" || { echo "QuickNTP processing failed. Exiting."; exit 1; }

# Fetch kip (downloads a .zip, needs specific file extraction)
# Original script moved loader.kip to ./atmosphere/kips
download_github_release "halop/OC_Toolkit_SC_EOS" "kip.zip" "kip.zip" "" "kip" "loader.kip" "./atmosphere/kips" || { echo "kip processing failed. Exiting."; exit 1; }

# Fetch OC_Toolkit (downloads a .zip)
# Original script moved "OC Toolkit" directory to ./switch/.packages
download_github_release "halop/OC_Toolkit_SC_EOS" "OC.Toolkit.zip" "OC.Toolkit.zip" "" "OC_Toolkit" "OC Toolkit" "./switch/.packages" || { echo "OC_Toolkit processing failed. Exiting."; exit 1; }

# Fetch sys-clk (downloads a .zip)
# Original script unzips to current directory
download_github_release "halop/OC_Toolkit_SC_EOS" "sys-clk.zip" "sys-clk.zip" "./" "sys-clk" || { echo "sys-clk processing failed. Exiting."; exit 1; }

# Fetch sys-patch (downloads a .zip)
# Original script unzips to current directory
download_github_release "borntohonk/sys-patch" "*.zip" "sys-patch.zip" "./" "sys-patch" || { echo "sys-patch processing failed. Exiting."; exit 1; }

# Fetch ldn_mitm (downloads a .zip)
# Original script unzips to current directory
download_github_release "zdm65477730/ldn_mitm" "*.zip" "ldn_mitm.zip" "./" "ldn_mitm" || { echo "ldn_mitm processing failed. Exiting."; exit 1; }


# -------------------------------------------\
# File Processing and Configuration
# -------------------------------------------\
echo "Starting file processing and configuration..."
echo "-----------------------------------------"

### Write overlays.ini in /config/ultrahand
echo "Writing overlays.ini in ./config/ultrahand/..."
cat > ./config/ultrahand/overlays.ini << ENDOFFILE
[sys-patch-overlay.ovl]
priority=20
star=false
hide=false
use_launch_args=false
launch_args=
custom_name=系统补丁
custom_version=

[sys-clk-overlay.ovl]
priority=20
star=false
hide=false
use_launch_args=false
launch_args=
custom_name=系统超频
custom_version=

[FPSLocker.ovl]
priority=20
star=false
hide=false
use_launch_args=false
launch_args=
custom_name=FPS补丁
custom_version=

[EdiZon.ovl]
priority=20
star=false
hide=false
use_launch_args=false
launch_args=
custom_name=金手指
custom_version=

[ovl-sysmodules.ovl]
priority=20
star=false
hide=false
use_launch_args=false
launch_args=
custom_name=系统模块
custom_version=

[QuickNTP.ovl]
priority=20
star=false
hide=false
use_launch_args=false
launch_args=
custom_name=时间校准
custom_version=

[Status-Monitor-Overlay.ovl]
priority=20
star=false
hide=false
use_launch_args=false
launch_args=
custom_name=状态监视
custom_version=

[ReverseNX-RT.ovl]
priority=20
star=false
hide=false
use_launch_args=false
launch_args=
custom_name=底座模式
custom_version=

[MasterVolume.ovl]
priority=20
star=false
hide=false
use_launch_args=false
launch_args=
custom_name=音量调节
custom_version=

[ldn_mitm.ovl]
priority=20
star=false
hide=false
use_launch_args=false
launch_args=
custom_name=联机补丁
custom_version=

[Fizeau.ovl]
priority=20
star=false
hide=false
use_launch_args=false
launch_args=
custom_name=色彩调节
custom_version=
ENDOFFILE
if [ $? -ne 0 ]; then
    echo "Writing overlays.ini in ./config/ultrahand/\\033[31m failed\\033[0m."
else
    echo "Writing overlays.ini in ./config/ultrahand/\\033[32m success\\033[0m."
fi
echo "-----------------------------------------"


### Rename hekate_ctcaer_*.bin to payload.bin
echo "Renaming hekate_ctcaer_*.bin to payload.bin..."
# Assuming hekate_ctcaer_*.bin is downloaded to the current directory (.)
find . -name "*hekate_ctcaer*.bin" -exec mv {} payload.bin \;
if [ $? -ne 0 ]; then
    echo "Rename hekate_ctcaer_*.bin to payload.bin\\033[31m failed\\033[0m."
else
    echo "Rename hekate_ctcaer_*.bin to payload.bin\\033[32m success\\033[0m."
fi
echo "-----------------------------------------"


### Write hekate_ipl.ini in /bootloader/
echo "Writing hekate_ipl.ini in ./bootloader/..."
cat > ./bootloader/hekate_ipl.ini << ENDOFFILE
[config]
autoboot=0
autoboot_list=0
bootwait=3
backlight=100
noticker=0
autohosoff=1
autonogc=1
updater2p=0
bootprotect=0

[Fusee]
icon=bootloader/res/icon_ams.bmp
payload=bootloader/payloads/fusee.bin

[CFW (emuMMC)]
emummcforce=1
fss0=atmosphere/package3
atmosphere=1
icon=bootloader/res/icon_Atmosphere_emunand.bmp
id=cfw-emu
kip1=atmosphere/kips/loader.kip

[CFW (sysMMC)]
emummc_force_disable=1
fss0=atmosphere/package3
atmosphere=1
icon=bootloader/res/icon_Atmosphere_sysnand.bmp
id=cfw-sys
kip1=atmosphere/kips/loader.kip

[Stock SysNAND]
emummc_force_disable=1
fss0=atmosphere/package3
icon=bootloader/res/icon_stock.bmp
stock=1
id=ofw-sys
ENDOFFILE
if [ $? -ne 0 ]; then
    echo "Writing hekate_ipl.ini in ./bootloader/ directory\\033[31m failed\\033[0m."
else
    echo "Writing hekate_ipl.ini in ./bootloader/ directory\\033[32m success\\033[0m."
fi
echo "-----------------------------------------"


### write exosphere.ini in root of SD Card
echo "Writing exosphere.ini in root of SD card..."
cat > ./exosphere.ini << ENDOFFILE
[exosphere]
debugmode=1
debugmode_user=0
disable_user_exception_handlers=0
enable_user_pmu_access=0
; 控制真实系统启用隐身模式。
blank_prodinfo_sysmmc=1
; 控制虚拟系统启用隐身模式。
blank_prodinfo_emummc=1
allow_writing_to_cal_sysmmc=0
log_port=0
log_baud_rate=115200
log_inverted=0
ENDOFFILE
if [ $? -ne 0 ]; then
    echo "Writing exosphere.ini in root of SD card\\033[31m failed\\033[0m."
else
    echo "Writing exosphere.ini in root of SD card\\033[32m success\\033[0m."
fi
echo "-----------------------------------------"


### Write emummc.txt & sysmmc.txt in /atmosphere/hosts
echo "Writing emummc.txt and sysmmc.txt in ./atmosphere/hosts..."
cat > ./atmosphere/hosts/emummc.txt << ENDOFFILE
# 屏蔽任天堂服务器
127.0.0.1 *nintendo.*
127.0.0.1 *nintendo-europe.com
127.0.0.1 *nintendoswitch.*
127.0.0.1 ads.doubleclick.net
127.0.0.1 s.ytimg.com
127.0.0.1 ad.youtube.com
127.0.0.1 ads.youtube.com
127.0.0.1 clients1.google.com
207.246.121.77 *conntest.nintendowifi.net
207.246.121.77 *ctest.cdn.nintendo.net
69.25.139.140 *ctest.cdn.n.nintendoswitch.cn
95.216.149.205 *conntest.nintendowifi.net
95.216.149.205 *ctest.cdn.nintendo.net
95.216.149.205 *90dns.test
ENDOFFILE
cp ./atmosphere/hosts/emummc.txt ./atmosphere/hosts/sysmmc.txt
if [ $? -ne 0 ]; then
    echo "Writing emummc.txt and sysmmc.txt in ./atmosphere/hosts\\033[31m failed\\033[0m."
else
    echo "Writing emummc.txt and sysmmc.txt in ./atmosphere/hosts\\033[32m success\\033[0m."
fi
echo "-----------------------------------------"

### Write boot.ini in root of SD Card
echo "Writing boot.ini in root of SD card..."
cat > ./boot.ini << ENDOFFILE
[payload]
file=payload.bin
ENDOFFILE
if [ $? -ne 0 ]; then
    echo "Writing boot.ini in root of SD card\\033[31m failed\\033[0m."
else
    echo "Writing boot.ini in root of SD card\\033[32m success\\033[0m."
fi
echo "-----------------------------------------"

### Write override_config.ini in /atmosphere/config
echo "Writing override_config.ini in ./atmosphere/config..."
cat > ./atmosphere/config/override_config.ini << ENDOFFILE
[hbl_config] 
program_id_0=010000000000100D
override_address_space=39_bit
; 按住R键点击相册进入HBL自制软件界面。\n
override_key_0=R
ENDOFFILE
if [ $? -ne 0 ]; then
    echo "Writing override_config.ini in ./atmosphere/config\\033[31m failed\\033[0m."
else
    echo "Writing override_config.ini in ./atmosphere/config\\033[32m success\\033[0m."
fi
echo "-----------------------------------------"

### Write system_settings.ini in /atmosphere/config
echo "Writing system_settings.ini in ./atmosphere/config..."
cat > ./atmosphere/config/system_settings.ini << ENDOFFILE
[eupld]
; 禁用将错误报告上传到任天堂
upload_enabled = u8!0x0

[ro]
; 控制 RO 是否应简化其对 NRO 的验证。\n
; （注意：这通常不是必需的，可以使用 IPS 补丁。\nease_nro_restriction = u8!0x1

[atmosphere]
; 是否自动开启所有金手指。0=关。1=开。\ndmnt_cheats_enabled_by_default = u8!0x0

; 如果你希望大气记住你上次金手指状态，请删除下方；号
dmnt_always_save_cheat_toggles = u8!0x1

; 如果大气崩溃，10秒后自动重启
; 1秒=1000毫秒，转换16进制
fatal_auto_reboot_interval = u64!0x2710

; 使电源菜单的"重新启动"按钮重新启动到payload
; 设置"normal"正常重启l 设置"rcm"重启RCM，\n
; power_menu_reboot_function = str!payload

; 启动90DNS与任天堂服务器屏蔽
enable_dns_mitm = u8!0x1
add_defaults_to_dns_hosts = u8!0x1

; 是否将蓝牙配对数据库用与虚拟系统
enable_external_bluetooth_db = u8!0x1

[usb]
; 开启USB3.0，尾数改为0是关闭
usb30_force_enabled = u8!0x1

[tc]
sleep_enabled = u8!0x0
holdable_tskin = u32!0xEA60
tskin_rate_table_console = str!"[[-1000000, 28000, 0, 0], [28000, 42000, 0, 51], [42000, 48000, 51, 102], [48000, 55000, 102, 153], [55000, 60000, 153, 255], [60000, 68000, 255, 255]]"
tskin_rate_table_handheld = str!"[[-1000000, 28000, 0, 0], [28000, 42000, 0, 51], [42000, 48000, 51, 102], [48000, 55000, 102, 153], [55000, 60000, 153, 255], [60000, 68000, 255, 255]]"
ENDOFFILE
if [ $? -ne 0 ]; then
    echo "Writing system_settings.ini in ./atmosphere/config\\033[31m failed\\033[0m."
else
    echo "Writing system_settings.ini in ./atmosphere/config\\033[32m success\\033[0m."
fi
echo "-----------------------------------------"


### Delete unneeded files
echo "Deleting unneeded files..."
rm -f switch/haze.nro
rm -f switch/reboot_to_hekate.nro
rm -f switch/reboot_to_payload.nro
echo "Unneeded files deleted."
echo "-----------------------------------------"


# Final step: Create the resulting zip file for distribution
echo "Creating final zip archive..."
# Navigate back to the parent directory to zip the SwitchSD folder
cd ..
zip -rq SwitchSD.zip SwitchSD
if [ $? -ne 0 ]; then
    echo "Creating final zip\\033[31m failed\\033[0m."
    exit 1
else
    echo "Creating final zip\\033[32m success\\033[0m."
fi
echo "-----------------------------------------"


echo ""
echo "\\033[32mYour Switch SD card is prepared!\\033[0m"
echo "-----------------------------------------"

exit 0 # Explicitly exit with success status if everything is done