set -e

### Credit to the Authors at https://rentry.org/CFWGuides
### Script created by Fraxalotl
### Mod by huangqian8
### Mod by xiaobai

# -------------------------------------------

# Function to convert a glob pattern to a regex pattern for jq
glob_to_regex() {
    local glob="$1"
    local regex="$glob"
    # Escape special regex characters
    regex=$(echo "$regex" | sed 's/\./\\./g; s/\[/\\[/g; s/\]/\\]/g; s/\^/\\^/g; s/\$/\\$/g')
    # Convert glob patterns to regex
    regex=$(echo "$regex" | sed 's/\*/.*/g; s/\?/./g')
    # Add anchors to match the whole string
    regex="^$regex$"
    echo "$regex"
}

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
    local description_name="${5:-$repo}"
    local specific_file="$6"
    local specific_file_dest="$7"

    # Convert glob pattern to regex for jq
    local regex_pattern=$(glob_to_regex "$asset_pattern")

    echo "--- Processing $repo ---"
    echo "Fetching latest release info for $repo..."

    # Add a small delay to avoid hitting rate limits
    sleep 1

    # Use GitHub Token if available (replace YOUR_TOKEN with actual token)
    local github_token="YOUR_TOKEN"
    local auth_header=""
    if [ -n "$github_token" ]; then
        auth_header="-H \"Authorization: Bearer $github_token\""
    fi

    # Fetch release info
    release_info=$(curl -sL -H "Accept: application/vnd.github+json" $auth_header "https://api.github.com/repos/$repo/releases/latest")
    local http_status=$(curl -sL -o /dev/null -w "%{http_code}" -H "Accept: application/vnd.github+json" $auth_header "https://api.github.com/repos/$repo/releases/latest")
    local rate_remaining=$(curl -sL -I -H "Accept: application/vnd.github+json" $auth_header "https://api.github.com/repos/$repo/releases/latest" | grep -i "x-ratelimit-remaining" | tr -d '\r' | awk '{print $2}')

    # Check HTTP status
    if [[ "$http_status" -eq 403 ]]; then
        echo "::error::❌ GitHub API rate limit exceeded. Please wait or add a GitHub Token."
        return 1
    elif [[ "$http_status" -ne 200 ]]; then
        echo "::error::❌ HTTP $http_status: Failed to fetch release info for $repo"
        return 1
    fi

    # Check rate limit
    if [[ "$rate_remaining" -lt 5 ]]; then
        echo "::warning::⚠️ GitHub API rate limit is low ($rate_remaining remaining)"
    fi

    # Parse release info
    if ! echo "$release_info" | tr -d '[:cntrl:]' | jq -e . > /dev/null; then
        echo "::error::❌ Invalid JSON response for $repo"
        return 1
    fi

    # Extract release name (fallback to tag_name if name is empty)
    release_name=$(echo "$release_info" | tr -d '[:cntrl:]' | jq -r '.name // .tag_name // "Unknown Release"')
    download_url=$(echo "$release_info" | tr -d '[:cntrl:]' | jq --arg regex "$regex_pattern" -r '.assets[] | select(.name | test($regex)) | .browser_download_url' | head -n 1)

    if [ -z "$download_url" ]; then
        echo "::error::❌ Could not find asset matching '$asset_pattern' for $repo"
        echo "Available assets:"
        echo "$release_info" | tr -d '[:cntrl:]' | jq -r '.assets[].name'
        return 1
    fi

    # Add release name to description.txt
    echo "$description_name $release_name" >> ../description.txt
    echo "Downloading $local_filename from $download_url..."

    # Download the file
    if ! curl -sL -f "$download_url" -o "$local_filename"; then
        echo "::error::❌ $local_filename download failed (HTTP $?)"
        return 1
    fi

    if [ ! -s "$local_filename" ]; then
        echo "::error::❌ $local_filename download failed: Downloaded file is missing or empty"
        return 1
    fi

    echo "::notice::✅ $local_filename download success."

    # Process the file based on extension
    if [[ "$local_filename" == *.zip ]]; then
        if [ -n "$target_dir" ]; then
            echo "Unzipping $local_filename to $target_dir..."
            if unzip -oq "$local_filename" -d "$target_dir"; then
                echo "::notice::✅ $local_filename extraction success"
                rm "$local_filename"
            else
                echo "::error::❌ $local_filename extraction failed"
                return 1
            fi
        elif [ -n "$specific_file" ] && [ -n "$specific_file_dest" ]; then
            echo "Extracting $specific_file from $local_filename to $specific_file_dest..."
            mkdir -p "$specific_file_dest"
            if unzip -oq "$local_filename" "$specific_file" -d "$specific_file_dest"; then
                echo "::notice::✅ $specific_file extraction success"
                rm "$local_filename"
            else
                echo "::error::❌ $specific_file extraction failed"
                return 1
            fi
        else
            echo "::warning::⚠️ No target directory or specific file specified for $local_filename"
        fi
    else
        local move_target_dir="./bootloader/payloads/"
        if [ -n "$target_dir" ]; then
            move_target_dir="$target_dir/"
        fi

        echo "Moving $local_filename to $move_target_dir..."
        mkdir -p "$move_target_dir"
        if mv "$local_filename" "$move_target_dir"; then
            echo "::notice::✅ $local_filename move success"
        else
            echo "::error::❌ $local_filename move failed"
            return 1
        fi
    fi

    echo "--- Finished processing $repo ---"
    echo ""
    return 0
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
        echo "::error::❌ $local_filename download failed"
        return 1
    fi

    if [ ! -s "$local_filename" ]; then
        echo "::error::❌ $local_filename download failed: Downloaded file is missing or empty"
        return 1
    fi

    echo "::notice::✅$local_filename download success."

    # Add a check to skip moving if target_dir is the current directory
    if [ -n "$target_dir" ] && [ "$target_dir" != "." ] && [ "$target_dir" != "./" ]; then
        echo "Moving $local_filename to $target_dir..."
        mkdir -p "$target_dir" # Ensure target directory exists
        if mv "$local_filename" "$target_dir/"; then
            echo "::notice::✅$local_filename move success."
        else
            echo "::error::❌ $local_filename move failed"
            return 1
        fi
    elif [ -n "$target_dir" ]; then
        # If target_dir is provided but is '.' or './', confirm file is in place
        echo "File $local_filename already downloaded to the target directory ($target_dir)."
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

### Create a new folder for storing files
if [ -d SwitchSD ]; then
  rm -rf SwitchSD
fi
if [ -e description.txt ]; then
  rm -rf description.txt
fi
mkdir -p ./SwitchSD/atmosphere/config
mkdir -p ./SwitchSD/atmosphere/hosts
mkdir -p ./SwitchSD/config/tesla
mkdir -p ./SwitchSD/bootloader/payloads
mkdir -p ./SwitchSD/switch
mkdir -p ./SwitchSD/atmosphere/contents
mkdir -p ./SwitchSD/config/sys-con
mkdir -p ./SwitchSD/config/MissionControl

cd SwitchSD

# Now replace the existing download blocks with calls to the functions

# Fetch latest atmosphere
download_github_release "Atmosphere-NX/Atmosphere" "*.zip" "atmosphere.zip" "./" "Atmosphere" || { echo "Atmosphere processing failed. Exiting."; exit 1; }

# Fetch latest fusee.bin
download_github_release "Atmosphere-NX/Atmosphere" "fusee.bin" "fusee.bin" "" "fusee.bin" || { echo "fusee.bin processing failed. Exiting."; exit 1; }

# Fetch latest hekate (EasyWorld大佬的汉化版本)
download_github_release "easyworld/hekate" "*_sc.zip" "hekate.zip" "./" "Hekate + Nyx" || { echo "Hekate + Nyx processing failed. Exiting."; exit 1; }

# Fetch logo (direct download)
download_direct_file "https://raw.githubusercontent.com/Zhuwenxue2002/SwitchPlugins/main/theme/logo.zip" "logo.zip" "./" "logo" || { echo "logo processing failed. Exiting."; exit 1; }

# Fetch latest Lockpick_RCM
# This one requires extracting a specific .bin file from the zip
download_github_release "impeeza/Lockpick_RCMDecScots" "*.zip" "Lockpick_RCM.zip" "" "Lockpick_RCM.bin" "Lockpick_RCM.bin" "./bootloader/payloads" || { echo "Lockpick_RCM processing failed. Exiting."; exit 1; }

# Fetch latest TegraExplorer.bin
# This one downloads a .bin file directly
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

# Fetch lastest QuickNTP (downloads a .zip)
# Assuming it extracts to the current directory (./SwitchSD) like nx-ovlloader
download_github_release "zdm65477730/QuickNTP" "*.zip" "QuickNTP.zip" "./" "QuickNTP" || { echo "QuickNTP processing failed. Exiting."; exit 1; }

# 在现有下载调用之后，添加以下内容：

# ======================
# 新增功能模块下载
# ======================

# 1. 超频相关组件
download_github_release "halop/OC_Toolkit_SC_EOS" "kip.zip" "kip.zip" "" "kip" "loader.kip" "./atmosphere/kips" || { echo "::error::❌ kip processing failed"; exit 1; }
download_github_release "halop/OC_Toolkit_SC_EOS" "OC.Toolkit.zip" "OC.Toolkit.zip" "./switch/.packages" "OC Toolkit" || { echo "::error::❌ OC Toolkit processing failed"; exit 1; }
download_github_release "halop/OC_Toolkit_SC_EOS" "sys-clk.zip" "sys-clk.zip" "./" "sys-clk" || { echo "::error::❌ sys-clk processing failed"; exit 1; }

# 2. 特斯拉插件系统
download_github_release "ppkantorski/Ultrahand-Overlay" "ovlmenu.ovl" "ovlmenu.ovl" "./switch/.overlays" "Ultrahand" || { echo "::error::❌ Ultrahand menu failed"; exit 1; }
download_github_release "ppkantorski/Ultrahand-Overlay" "lang.zip" "lang.zip" "./config/ultrahand/lang" "Ultrahand Lang" || { echo "::error::❌ Language pack failed"; exit 1; }

# 3. 系统工具插件
download_github_release "zdm65477730/EdiZon-Overlay" "*.zip" "EdiZon.zip" "./" "EdiZon" || { echo "::error::❌ EdiZon failed"; exit 1; }
download_github_release "zdm65477730/ovl-sysmodules" "*.zip" "ovl-sysmodules.zip" "./" "ovl-sysmodules" || { echo "::error::❌ ovl-sysmodules failed"; exit 1; }
download_direct_file "https://github.com/wei2ard/AutoFetch/releases/download/latest/Status-Monitor-Overlay.zip" "Status-Monitor-Overlay.zip" "./" "Status-Monitor" || { echo "::error::❌ Status-Monitor failed"; exit 1; }
download_github_release "zdm65477730/ReverseNX-RT" "*.zip" "ReverseNX-RT.zip" "./" "ReverseNX-RT" || { echo "::error::❌ ReverseNX-RT failed"; exit 1; }
download_github_release "zdm65477730/Fizeau" "*.zip" "Fizeau.zip" "./" "Fizeau" || { echo "::error::❌ Fizeau failed"; exit 1; }
download_github_release "averne/MasterVolume" "*.zip" "MasterVolume.zip" "./" "MasterVolume" || { echo "::error::❌ MasterVolume failed"; exit 1; }

# ======================
# 新增配置文件生成
# ======================

# 1. overlays.ini (特斯拉插件配置)
cat > ./config/ultrahand/overlays.ini << 'ENDOFFILE'
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

# 2. exosphere.ini (隐身模式)
cat > ./exosphere.ini << 'ENDOFFILE'
[exosphere]
debugmode=1
debugmode_user=0
disable_user_exception_handlers=0
enable_user_pmu_access=0
blank_prodinfo_sysmmc=1
blank_prodinfo_emummc=1
allow_writing_to_cal_sysmmc=0
log_port=0
log_baud_rate=115200
log_inverted=0
ENDOFFILE

# 3. hekate_ipl.ini (启动项配置)
cat > ./bootloader/hekate_ipl.ini << 'ENDOFFILE'
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

# 4. 系统配置文件
cat > ./atmosphere/config/system_settings.ini << 'ENDOFFILE'
[eupld]
upload_enabled = u8!0x0

[ro]
ease_nro_restriction = u8!0x1

[atmosphere]
dmnt_cheats_enabled_by_default = u8!0x0
dmnt_always_save_cheat_toggles = u8!0x1
fatal_auto_reboot_interval = u64!0x2710
enable_dns_mitm = u8!0x1
add_defaults_to_dns_hosts = u8!0x1
enable_external_bluetooth_db = u8!0x1

[usb]
usb30_force_enabled = u8!0x1

[tc]
sleep_enabled = u8!0x0
holdable_tskin = u32!0xEA60
tskin_rate_table_console = str!"[[-1000000, 28000, 0, 0], [28000, 42000, 0, 51], [42000, 48000, 51, 102], [48000, 55000, 102, 153], [55000, 60000, 153, 255], [60000, 68000, 255, 255]]"
tskin_rate_table_handheld = str!"[[-1000000, 28000, 0, 0], [28000, 42000, 0, 51], [42000, 48000, 51, 102], [48000, 55000, 102, 153], [55000, 60000, 153, 255], [60000, 68000, 255, 255]]"
ENDOFFILE
