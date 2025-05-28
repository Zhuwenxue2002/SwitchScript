#!/bin/sh
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
    # Escape dots
    regex=$(echo "$regex" | sed 's/\./\\./g')
    # Convert * to .*
    regex=$(echo "$regex" | sed 's/\*/.*/g')
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
    local description_name="${5:-$repo}" # Default to repo name if not provided
    local specific_file="$6"
    local specific_file_dest="$7"

    # Convert glob pattern to regex for jq
    local regex_pattern=$(glob_to_regex "$asset_pattern")

    echo "--- Processing $repo ---"
    echo "Fetching latest release info for $repo..."
    release_info=$(curl -sL "https://api.github.com/repos/$repo/releases/latest")

    # Add this line to see the raw output from curl
    echo "Raw curl output for $repo:"
    echo "$release_info"
    echo "---"

    if [ $? -ne 0 ] || ! echo "$release_info" | tr -d '[:cntrl:]' | jq -e . > /dev/null; then
        echo "Error: Failed to fetch release info for $repo\033[31m failed\\033[0m."
        return 1
    fi

    # Extract release name and download URL based on asset pattern
    release_name=$(echo "$release_info" | tr -d '[:cntrl:]' | jq -r '.name // .tag_name') # Use name if available, otherwise tag_name
    # Use the converted regex pattern in the jq match function
    download_url=$(echo "$release_info" | tr -d '[:cntrl:]' | jq -r ".assets[] | select(.name | match(\"$regex_pattern\")) | .browser_download_url")

    if [ -z "$release_name" ]; then
        echo "Warning: Could not extract release name for $repo."
        release_name="Unknown Release"
    fi

    if [ -z "$download_url" ]; then
        echo "Error: Could not find asset matching '$asset_pattern' for $repo\033[31m failed\\033[0m."
        echo "Available assets:"
        echo "$release_info" | tr -d '[:cntrl:]' | jq -r '.assets[].name'
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

# Write config.ini in /config/tesla
echo "Writing config.ini in ./config/tesla..."
cat > ./config/tesla/config.ini << ENDOFFILE
[tesla]
; 特斯拉自定义快捷键。
key_combo=L+ZL+R
ENDOFFILE
if [ $? -ne 0 ]; then
    echo "Writing config.ini in ./config/tesla\033[31m failed\\033[0m."
else
    echo "Writing config.ini in ./config/tesla\033[32m success\033[0m."
fi

echo ""
echo "\033[32mYour Switch SD card is prepared!\033[0m"
