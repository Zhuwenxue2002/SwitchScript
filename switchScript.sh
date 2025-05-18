#!/bin/sh
set -e

### Credit to the Authors at https://rentry.org/CFWGuides
### Script created by Fraxalotl
### Mod by huangqian8
### Mod by xiaobai

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
cd SwitchSD

### Fetch latest atmosphere from https://github.com/Atmosphere-NX/Atmosphere/releases/latest
curl -sL https://api.github.com/repos/Atmosphere-NX/Atmosphere/releases/latest \
  | jq '.name' \
  | xargs -I {} echo {} >> ../description.txt
curl -sL https://api.github.com/repos/Atmosphere-NX/Atmosphere/releases/latest \
  | grep -oP '"browser_download_url": "\Khttps://[^"]*atmosphere[^"]*.zip' \
  | sed 's/"//g' \
  | xargs -I {} curl -sL {} -o atmosphere.zip
if [ $? -ne 0 ]; then
    echo "atmosphere download\033[31m failed\033[0m."
else
    echo "atmosphere download\033[32m success\033[0m."
    unzip -oq atmosphere.zip
    rm atmosphere.zip
fi

### Fetch latest fusee.bin from https://github.com/Atmosphere-NX/Atmosphere/releases/latest
curl -sL https://api.github.com/repos/Atmosphere-NX/Atmosphere/releases/latest \
  | grep -oP '"browser_download_url": "\Khttps://[^"]*fusee.bin"' \
  | sed 's/"//g' \
  | xargs -I {} curl -sL {} -o fusee.bin
if [ $? -ne 0 ]; then
    echo "fusee download\033[31m failed\033[0m."
else
    echo "fusee download\033[32m success\033[0m."
    mkdir -p ./bootloader/payloads
    mv fusee.bin ./bootloader/payloads
fi



#### 不再使用原本hekate+汉化文件的方式，直接使用EasyWorld大佬的汉化版本
curl -sL https://api.github.com/repos/easyworld/hekate/releases/latest \
  | jq '.name' \
  | xargs -I {} echo {} >> ../description.txt
curl -sL https://api.github.com/repos/easyworld/hekate/releases/latest \
  | grep -oP '"browser_download_url": "\Khttps://[^"]*hekate_ctcaer[^"]*_sc.zip"' \
  | sed 's/"//g' \
  | xargs -I {} curl -sL {} -o hekate.zip
if [ $? -ne 0 ]; then
    echo "Hekate + Nyx download\033[31m failed\033[0m."
else
    echo "Hekate + Nyx download\033[32m success\033[0m."
    unzip -oq hekate.zip
    rm hekate.zip
fi

### Fetch logo
curl -sL https://raw.githubusercontent.com/Zhuwenxue2002/SwitchPlugins/main/theme/logo.zip -o logo.zip
if [ $? -ne 0 ]; then
    echo "logo download\033[31m failed\033[0m."
else
    echo "logo download\033[32m success\033[0m."
    unzip -oq logo.zip
    rm logo.zip
fi

### 更换impeeza维护的Lockpick_RCM
### Fetch latest Lockpick_RCM.bin https://github.com/impeeza/Lockpick_RCMDecScots/releases/latest
curl -sL https://api.github.com/repos/impeeza/Lockpick_RCMDecScots/releases/latest \
  | jq '.tag_name' \
  | xargs -I {} echo Lockpick_RCM.bin {} >> ../description.txt
curl -sL https://api.github.com/repos/impeeza/Lockpick_RCMDecScots/releases/latest \
  | grep -oP '"browser_download_url": "\Khttps://[^"]*Lockpick_RCM[^"]*.zip"' \
  | sed 's/"//g' \
  | xargs -I {} curl -sL {} -o Lockpick_RCM.zip
if [ $? -ne 0 ]; then
    echo "Lockpick_RCM download\033[31m failed\033[0m."
else
    echo "Lockpick_RCM download\033[32m success\033[0m."
    unzip -oq Lockpick_RCM.zip
    mv Lockpick_RCM.bin ./bootloader/payloads
    rm Lockpick_RCM.zip
fi

### Fetch latest TegraExplorer.bin form https://github.com/suchmememanyskill/TegraExplorer/releases
curl -sL https://api.github.com/repos/suchmememanyskill/TegraExplorer/releases/latest \
  | jq '.tag_name' \
  | xargs -I {} echo TegraExplorer {} >> ../description.txt
curl -sL https://api.github.com/repos/suchmememanyskill/TegraExplorer/releases/latest \
  | grep -oP '"browser_download_url": "\Khttps://[^"]*TegraExplorer.bin"' \
  | sed 's/"//g' \
  | xargs -I {} curl -sL {} -o TegraExplorer.bin
if [ $? -ne 0 ]; then
    echo "TegraExplorer download\033[31m failed\033[0m."
else
    echo "TegraExplorer download\033[32m success\033[0m."
    mv TegraExplorer.bin ./bootloader/payloads
fi

### 更换原版90DNS拉取地址
curl -sL https://api.github.com/repos/meganukebmp/Switch_90DNS_tester/releases/latest \
  | jq '.tag_name' \
  | xargs -I {} echo Switch_90DNS_tester {} >> ../description.txt
curl -sL https://api.github.com/repos/meganukebmp/Switch_90DNS_tester/releases/latest \
  | grep -oP '"browser_download_url": "\Khttps://[^"]*Switch_90DNS_tester.nro"' \
  | sed 's/"//g' \
  | xargs -I {} curl -sL {} -o Switch_90DNS_tester.nro
if [ $? -ne 0 ]; then
    echo "Switch_90DNS_tester download\033[31m failed\033[0m."
else
    echo "Switch_90DNS_tester download\033[32m success\033[0m."
    mkdir -p ./switch/Switch_90DNS_tester
    mv Switch_90DNS_tester.nro ./switch/Switch_90DNS_tester
fi


### Fetch lastest DBI from https://github.com/rashevskyv/dbi/releases/latest
curl -sL https://api.github.com/repos/rashevskyv/dbi/releases/latest \
  | jq '.name' \
  | xargs -I {} echo {} >> ../description.txt
curl -sL https://api.github.com/repos/rashevskyv/dbi/releases/latest \
  | grep -oP '"browser_download_url": "\Khttps://[^"]*DBI.nro"' \
  | sed 's/"//g' \
  | xargs -I {} curl -sL {} -o DBI.nro
if [ $? -ne 0 ]; then
    echo "DBI download\033[31m failed\033[0m."
else
    echo "DBI download\033[32m success\033[0m."
    mkdir -p ./switch/DBI
    mv DBI.nro ./switch/DBI
fi

### 更换Z大开发Awoo
### Fetch lastest Awoo Installer from https://github.com/dragonflylee/Awoo-Installer/releases/latest
curl -sL https://api.github.com/repos/dragonflylee/Awoo-Installer/releases/latest \
  | jq '.name' \
  | xargs -I {} echo {} >> ../description.txt
curl -sL https://api.github.com/repos/dragonflylee/Awoo-Installer/releases/latest \
  | grep -oP '"browser_download_url": "\Khttps://[^"]*Awoo-Installer.zip"' \
  | sed 's/"//g' \
  | xargs -I {} curl -sL {} -o Awoo-Installer.zip
if [ $? -ne 0 ]; then
    echo "Awoo Installer download\033[31m failed\033[0m."
else
    echo "Awoo Installer download\033[32m success\033[0m."
    unzip -oq Awoo-Installer.zip
    rm Awoo-Installer.zip
fi

### Fetch lastest Hekate-toolbox from https://github.com/WerWolv/Hekate-Toolbox/releases/latest
curl -sL https://api.github.com/repos/WerWolv/Hekate-Toolbox/releases/latest \
  | jq '.tag_name' \
  | xargs -I {} echo HekateToolbox {} >> ../description.txt
curl -sL https://api.github.com/repos/WerWolv/Hekate-Toolbox/releases/latest \
  | grep -oP '"browser_download_url": "\Khttps://[^"]*HekateToolbox.nro"' \
  | sed 's/"//g' \
  | xargs -I {} curl -sL {} -o HekateToolbox.nro
if [ $? -ne 0 ]; then
    echo "HekateToolbox download\033[31m failed\033[0m."
else
    echo "HekateToolbox download\033[32m success\033[0m."
    mkdir -p ./switch/HekateToolbox
    mv HekateToolbox.nro ./switch/HekateToolbox
fi

### 更换zdmgithub推送版本的NX-Activity-Log拉取地址
curl -sL https://api.github.com/repos/zdm65477730/NX-Activity-Log/releases/latest \
  | jq '.name' \
  | xargs -I {} echo NX-Activity-Log {} >> ../description.txt
curl -sL https://api.github.com/repos/zdm65477730/NX-Activity-Log/releases/latest \
  | grep -oP '"browser_download_url": "\Khttps://[^"]*NX-Activity-Log.nro"' \
  | sed 's/"//g' \
  | xargs -I {} curl -sL {} -o NX-Activity-Log.nro
if [ $? -ne 0 ]; then
    echo "NX-Activity-Log download\033[31m failed\033[0m."
else
    echo "NX-Activity-Log download\033[32m success\033[0m."
    mkdir -p ./switch/NX-Activity-Log
    mv NX-Activity-Log.nro ./switch/NX-Activity-Log
fi


### Fetch lastest JKSV from https://github.com/J-D-K/JKSV/releases/latest
curl -sL https://api.github.com/repos/J-D-K/JKSV/releases/latest \
  | jq '.name' \
  | xargs -I {} echo JKSV {} >> ../description.txt
curl -sL https://api.github.com/repos/J-D-K/JKSV/releases/latest \
  | grep -oP '"browser_download_url": "\Khttps://[^"]*JKSV.nro"' \
  | sed 's/"//g' \
  | xargs -I {} curl -sL {} -o JKSV.nro
if [ $? -ne 0 ]; then
    echo "JKSV download\033[31m failed\033[0m."
else
    echo "JKSV download\033[32m success\033[0m."
    mkdir -p ./switch/JKSV
    mv JKSV.nro ./switch/JKSV
fi


### Fetch lastest aio-switch-updater from https://github.com/HamletDuFromage/aio-switch-updater/releases/latest
curl -sL https://api.github.com/repos/HamletDuFromage/aio-switch-updater/releases/latest \
  | jq '.tag_name' \
  | xargs -I {} echo aio-switch-updater {} >> ../description.txt
curl -sL https://api.github.com/repos/HamletDuFromage/aio-switch-updater/releases/latest \
  | grep -oP '"browser_download_url": "\Khttps://[^"]*aio-switch-updater.zip"' \
  | sed 's/"//g' \
  | xargs -I {} curl -sL {} -o aio-switch-updater.zip
if [ $? -ne 0 ]; then
    echo "aio-switch-updater download\033[31m failed\033[0m."
else
    echo "aio-switch-updater download\033[32m success\033[0m."
    unzip -oq aio-switch-updater.zip
    rm aio-switch-updater.zip
fi

### Fetch lastest wiliwili from https://github.com/xfangfang/wiliwili/releases/latest
curl -sL https://api.github.com/repos/xfangfang/wiliwili/releases/latest \
  | jq '.tag_name' \
  | xargs -I {} echo wiliwili {} >> ../description.txt
curl -sL https://api.github.com/repos/xfangfang/wiliwili/releases/latest \
  | grep -oP '"browser_download_url": "\Khttps://[^"]*wiliwili-NintendoSwitch.zip"' \
  | sed 's/"//g' \
  | xargs -I {} curl -sL {} -o wiliwili-NintendoSwitch.zip
if [ $? -ne 0 ]; then
    echo "wiliwili download\033[31m failed\033[0m."
else
    echo "wiliwili download\033[32m success\033[0m."
    unzip -oq wiliwili-NintendoSwitch.zip
    mkdir -p ./switch/wiliwili
    mv wiliwili/wiliwili.nro ./switch/wiliwili
    rm -rf wiliwili
    rm wiliwili-NintendoSwitch.zip
fi

### Fetch lastest SimpleModDownloader from https://github.com/PoloNX/SimpleModDownloader/releases/latest
curl -sL https://api.github.com/repos/PoloNX/SimpleModDownloader/releases/latest \
  | jq '.tag_name' \
  | xargs -I {} echo SimpleModDownloader {} >> ../description.txt
curl -sL https://api.github.com/repos/PoloNX/SimpleModDownloader/releases/latest \
  | grep -oP '"browser_download_url": "\Khttps://[^"]*SimpleModDownloader.nro"' \
  | sed 's/"//g' \
  | xargs -I {} curl -sL {} -o SimpleModDownloader.nro
if [ $? -ne 0 ]; then
    echo "SimpleModDownloader download\033[31m failed\033[0m."
else
    echo "SimpleModDownloader download\033[32m success\033[0m."
    mkdir -p ./switch/SimpleModDownloader
    mv SimpleModDownloader.nro ./switch/SimpleModDownloader
fi

### Fetch lastest SimpleModManager from https://github.com/nadrino/SimpleModManager/releases/latest
curl -sL https://api.github.com/repos/nadrino/SimpleModManager/releases/latest \
  | jq '.tag_name' \
  | xargs -I {} echo SimpleModManager {} >> ../description.txt
curl -sL https://api.github.com/repos/nadrino/SimpleModManager/releases/latest \
  | grep -oP '"browser_download_url": "\Khttps://[^"]*SimpleModManager.nro"' \
  | sed 's/"//g' \
  | xargs -I {} curl -sL {} -o SimpleModManager.nro
if [ $? -ne 0 ]; then
    echo "SimpleModManager download\033[31m failed\033[0m."
else
    echo "SimpleModManager download\033[32m success\033[0m."
    mkdir -p ./switch/SimpleModManager
    mkdir -p ./mods
    mv SimpleModManager.nro ./switch/SimpleModManager
fi

### Fetch lastest Moonlight from https://github.com/XITRIX/Moonlight-Switch/releases/latest
curl -sL https://api.github.com/repos/XITRIX/Moonlight-Switch/releases/latest \
  | jq '.tag_name' \
  | xargs -I {} echo Moonlight {} >> ../description.txt
curl -sL https://api.github.com/repos/XITRIX/Moonlight-Switch/releases/latest \
  | grep -oP '"browser_download_url": "\Khttps://[^"]*Moonlight-Switch.nro"' \
  | sed 's/"//g' \
  | xargs -I {} curl -sL {} -o Moonlight-Switch.nro
if [ $? -ne 0 ]; then
    echo "Moonlight download\033[31m failed\033[0m."
else
    echo "Moonlight download\033[32m success\033[0m."
    mkdir -p ./switch/Moonlight-Switch
    mv Moonlight-Switch.nro ./switch/Moonlight-Switch
fi

### Fetch lastest ezRemote from https://github.com/cy33hc/switch-ezremote-client/releases/latest
curl -sL https://api.github.com/repos/cy33hc/switch-ezremote-client/releases/latest \
  | jq '.tag_name' \
  | xargs -I {} echo switch-ezremote-client {} >> ../description.txt
curl -sL https://api.github.com/repos/cy33hc/switch-ezremote-client/releases/latest \
  | grep -oP '"browser_download_url": "\Khttps://[^"]*ezremote-client.nro"' \
  | sed 's/"//g' \
  | xargs -I {} curl -sL {} -o ezremote-client.nro
if [ $? -ne 0 ]; then
    echo "ezremote-client download\033[31m failed\033[0m."
else
    echo "ezremote-client download\033[32m success\033[0m."
    mkdir -p ./switch/ezremote-client
    mv ezremote-client.nro ./switch/ezremote-client
fi

### Fetch lastest hb-appstore from https://github.com/fortheusers/hb-appstore/releases/latest
curl -sL https://api.github.com/repos/fortheusers/hb-appstore/releases/latest \
  | jq '.name' \
  | xargs -I {} echo {} >> ../description.txt
curl -sL https://api.github.com/repos/fortheusers/hb-appstore/releases/latest \
  | grep -oP '"browser_download_url": "\Khttps://[^"]*appstore.nro"' \
  | sed 's/"//g' \
  | xargs -I {} curl -sL {} -o appstore.nro
if [ $? -ne 0 ]; then
    echo "appstore download\033[31m failed\033[0m."
else
    echo "appstore download\033[32m success\033[0m."
    mkdir -p ./switch/appstore
    mv appstore.nro ./switch/appstore
fi

### Fetch lastest switch-nsp-forwarder from https://github.com/TooTallNate/switch-nsp-forwarder/releases/latest
curl -sL https://api.github.com/repos/TooTallNate/switch-nsp-forwarder/releases/latest \
  | jq '.tag_name' \
  | xargs -I {} echo switch-nsp-forwarder {} >> ../description.txt
curl -sL https://api.github.com/repos/TooTallNate/switch-nsp-forwarder/releases/latest \
  | grep -oP '"browser_download_url": "\Khttps://[^"]*nsp-forwarder.nro"' \
  | sed 's/"//g' \
  | xargs -I {} curl -sL {} -o nsp-forwarder.nro
if [ $? -ne 0 ]; then
    echo "nsp-forwarder download\033[31m failed\033[0m."
else
    echo "nsp-forwarder download\033[32m success\033[0m."
    mkdir -p ./switch/nsp-forwarder
    mv nsp-forwarder.nro ./switch/nsp-forwarder
fi

### Fetch lastest MissionControl from https://github.com/ndeadly/MissionControl/releases/latest
curl -sL https://api.github.com/repos/ndeadly/MissionControl/releases/latest \
  | jq '.name' \
  | xargs -I {} echo {} >> ../description.txt
curl -sL https://api.github.com/repos/ndeadly/MissionControl/releases/latest \
  | grep -oP '"browser_download_url": "\Khttps://[^"]*MissionControl[^"]*.zip"' \
  | sed 's/"//g' \
  | xargs -I {} curl -sL {} -o MissionControl.zip
if [ $? -ne 0 ]; then
    echo "MissionControl download\033[31m failed\033[0m."
else
    echo "MissionControl download\033[32m success\033[0m."
    unzip -oq MissionControl.zip
    rm MissionControl.zip
fi

## Fetch lastest sys-con from https://github.com/o0Zz/sys-con/releases/latest
curl -sL https://api.github.com/repos/o0Zz/sys-con/releases/latest \
  | jq '.name' \
  | xargs -I {} echo sys-con {} >> ../description.txt
curl -sL https://api.github.com/repos/o0Zz/sys-con/releases/latest \
  | grep -oP '"browser_download_url": "\Khttps://[^"]*sys-con[^"]*.zip"' \
  | sed 's/"//g' \
  | xargs -I {} curl -sL {} -o sys-con.zip
if [ $? -ne 0 ]; then
    echo "sys-con download\033[31m failed\033[0m."
else
    echo "sys-con download\033[32m success\033[0m."
    unzip -oq sys-con.zip
    rm sys-con.zip
fi

## Fetch lastest nx-ovlloader from https://github.com/zdm65477730/nx-ovlloader/releases/latest
curl -sL https://api.github.com/repos/zdm65477730/nx-ovlloader/releases/latest \
  | jq '.name' \
  | xargs -I {} echo  {} >> ../description.txt
curl -sL https://api.github.com/repos/zdm65477730/nx-ovlloader/releases/latest \
  | grep -oP '"browser_download_url": "\Khttps://[^"]*nx-ovlloader[^"]*.zip"' \
  | sed 's/"//g' \
  | xargs -I {} curl -sL {} -o nx-ovlloader.zip
if [ $? -ne 0 ]; then
    echo "nx-ovlloader download\033[31m failed\033[0m."
else
    echo "nx-ovlloader download\033[32m success\033[0m."
    unzip -oq nx-ovlloader.zip
    rm nx-ovlloader.zip
fi


### Write config.ini in /config/tesla
cat > ./config/tesla/config.ini << ENDOFFILE
[tesla]
; 特斯拉自定义快捷键。
key_combo=L+ZL+R
ENDOFFILE
if [ $? -ne 0 ]; then
    echo "Writing config.ini in ./config/tesla\033[31m failed\033[0m."
else
    echo "Writing config.ini in ./config/tesla\033[32m success\033[0m."
fi

### 极限超频的kip
### Fetch kip from https://github.com/halop/OC_Toolkit_SC_EOS/releases/latest
curl -sL https://api.github.com/repos/halop/OC_Toolkit_SC_EOS/releases/latest \
  | jq '.name' \
  | xargs -I {} echo kip {} >> ../description.txt
curl -sL https://api.github.com/repos/halop/OC_Toolkit_SC_EOS/releases/latest \
  | grep -oP '"browser_download_url": "\Khttps://[^"]*kip.zip"' \
  | sed 's/"//g' \
  | xargs -I {} curl -sL {} -o kip.zip
if [ $? -ne 0 ]; then
    echo "kip download\033[31m failed\033[0m."
else
    echo "kip download\033[32m success\033[0m."
    unzip -oq kip.zip
    rm kip.zip
    mkdir -p ./atmosphere/kips
    mv loader.kip ./atmosphere/kips
fi

### 极限超频
### Fetch OC_Toolkit from https://github.com/halop/OC_Toolkit_SC_EOS/releases/latest
curl -sL https://api.github.com/repos/halop/OC_Toolkit_SC_EOS/releases/latest \
  | jq '.name' \
  | xargs -I {} echo {} >> ../description.txt
curl -sL https://api.github.com/repos/halop/OC_Toolkit_SC_EOS/releases/latest \
  | grep -oP '"browser_download_url": "\Khttps://[^"]*OC.Toolkit.zip"' \
  | sed 's/"//g' \
  | xargs -I {} curl -sL {} -o OC.Toolkit.zip
if [ $? -ne 0 ]; then
    echo "OC.Toolkit download\033[31m failed\033[0m."
else
    echo "OC.Toolkit download\033[32m success\033[0m."
    unzip -oq OC.Toolkit.zip
    rm OC.Toolkit.zip
    mkdir -p ./switch/.packages
    mv "OC Toolkit" ./switch/.packages
fi

### Fetch sys-clk from https://github.com/halop/OC_Toolkit_SC_EOS/releases/latest
curl -sL https://api.github.com/repos/halop/OC_Toolkit_SC_EOS/releases/latest \
  | jq '.name' \
  | xargs -I {} echo sys-clk {} >> ../description.txt
curl -sL https://api.github.com/repos/halop/OC_Toolkit_SC_EOS/releases/latest \
  | grep -oP '"browser_download_url": "\Khttps://[^"]*sys-clk.zip"' \
  | sed 's/"//g' \
  | xargs -I {} curl -sL {} -o sys-clk.zip
if [ $? -ne 0 ]; then
    echo "sys-clk download\033[31m failed\033[0m."
else
    echo "sys-clk download\033[32m success\033[0m."
    unzip -oq sys-clk.zip
    rm sys-clk.zip
fi


### 更换sys-patch为官方版本
### Fetch sys-patch from https://github.com/borntohonk/sys-patch/releases/latest
curl -sL https://api.github.com/repos/borntohonk/sys-patch/releases/latest \
  | jq '.name' \
  | xargs -I {} echo {} >> ../description.txt
curl -sL https://api.github.com/repos/borntohonk/sys-patch/releases/latest \
  | grep -oP '"browser_download_url": "\Khttps://[^"]*sys-patch.zip"' \
  | sed 's/"//g' \
  | xargs -I {} curl -sL {} -o sys-patch.zip
if [ $? -ne 0 ]; then
    echo "sys-patch download\033[31m failed\033[0m."
else
    echo "sys-patch download\033[32m success\033[0m."
    unzip -oq sys-patch.zip
    rm sys-patch.zip
fi

### 更换ldn_mitm为z大接手开发版本
### Fetch sys-patch from https://github.com/zdm65477730/ldn_mitm/releases/latest
curl -sL https://api.github.com/repos/zdm65477730/ldn_mitm/releases/latest \
  | jq '.name' \
  | xargs -I {} echo ldn_mitm {} >> ../description.txt
curl -sL https://api.github.com/repos/zdm65477730/ldn_mitm/releases/latest \
  | grep -oP '"browser_download_url": "\Khttps://[^"]*ldn_mitm.zip"' \
  | sed 's/"//g' \
  | xargs -I {} curl -sL {} -o ldn_mitm.zip
if [ $? -ne 0 ]; then
    echo "ldn_mitm download\033[31m failed\033[0m."
else
    echo "ldn_mitm download\033[32m success\033[0m."
    unzip -oq ldn_mitm.zip
    rm ldn_mitm.zip
fi

# 这里为ultrahand菜单项写中文name
### Write overlays.ini in /config/ultrahand
mkdir -p ./config/ultrahand/
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

[ldnmitm_config.ovl]
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

### z大金手指插件
## Fetch lastest EdiZon-Overlay from https://github.com/zdm65477730/EdiZon-Overlay/releases/latest
curl -sL https://api.github.com/repos/zdm65477730/EdiZon-Overlay/releases/latest \
  | jq '.name' \
  | xargs -I {} echo  {} >> ../description.txt
curl -sL https://api.github.com/repos/zdm65477730/EdiZon-Overlay/releases/latest \
  | grep -oP '"browser_download_url": "\Khttps://[^"]*EdiZon[^"]*.zip"' \
  | sed 's/"//g' \
  | xargs -I {} curl -sL {} -o EdiZon.zip
if [ $? -ne 0 ]; then
    echo "EdiZon download\033[31m failed\033[0m."
else
    echo "EdiZon download\033[32m success\033[0m."
    unzip -oq EdiZon.zip
    rm EdiZon.zip
fi

### z大系统模块插件
## Fetch lastest ovl-sysmodules from https://github.com/zdm65477730/ovl-sysmodules/releases/latest
curl -sL https://api.github.com/repos/zdm65477730/ovl-sysmodules/releases/latest \
  | jq '.name' \
  | xargs -I {} echo  {} >> ../description.txt
curl -sL https://api.github.com/repos/zdm65477730/ovl-sysmodules/releases/latest \
  | grep -oP '"browser_download_url": "\Khttps://[^"]*ovl-sysmodules[^"]*.zip"' \
  | sed 's/"//g' \
  | xargs -I {} curl -sL {} -o ovl-sysmodules.zip
if [ $? -ne 0 ]; then
    echo "ovl-sysmodules download\033[31m failed\033[0m."
else
    echo "ovl-sysmodules download\033[32m success\033[0m."
    unzip -oq ovl-sysmodules.zip
    rm ovl-sysmodules.zip
fi

### 拉取wei2ard大佬汉化过的状态监控（带电压版本）
### Fetch StatusMonitor from https://github.com/wei2ard/AutoFetch/releases/download/latest/Status-Monitor-Overlay.zip
curl -sL https://github.com/wei2ard/AutoFetch/releases/download/latest/Status-Monitor-Overlay.zip -o Status-Monitor-Overlay.zip
if [ $? -ne 0 ]; then
    echo "Status-Monitor-Overlay download\033[31m failed\033[0m."
else
    echo "Status-Monitor-Overlay. download\033[32m success\033[0m."
    unzip -oq Status-Monitor-Overlay.zip
    rm Status-Monitor-Overlay.zip
fi

### z大底座模式插件
## Fetch lastest ReverseNX-RT from https://github.com/zdm65477730/ReverseNX-RT/releases/latest
curl -sL https://api.github.com/repos/zdm65477730/ReverseNX-RT/releases/latest \
  | jq '.name' \
  | xargs -I {} echo  {} >> ../description.txt
curl -sL https://api.github.com/repos/zdm65477730/ReverseNX-RT/releases/latest \
  | grep -oP '"browser_download_url": "\Khttps://[^"]*ReverseNX-RT[^"]*.zip"' \
  | sed 's/"//g' \
  | xargs -I {} curl -sL {} -o ReverseNX-RT.zip
if [ $? -ne 0 ]; then
    echo "ReverseNX-RT download\033[31m failed\033[0m."
else
    echo "ReverseNX-RT download\033[32m success\033[0m."
    unzip -oq ReverseNX-RT.zip
    rm ReverseNX-RT.zip
fi

### z大时间校准插件
## Fetch lastest QuickNTP from https://github.com/zdm65477730/QuickNTP/releases/latest
curl -sL https://api.github.com/repos/zdm65477730/QuickNTP/releases/latest \
  | jq '.name' \
  | xargs -I {} echo  {} >> ../description.txt
curl -sL https://api.github.com/repos/zdm65477730/QuickNTP/releases/latest \
  | jq -r '.assets[] | select(.name == "QuickNTP.zip") | .browser_download_url' \
  | xargs -I {} curl -sL {} -o QuickNTP.zip
if [ $? -ne 0 ]; then
    echo "QuickNTP download\033[31m failed\033[0m."
else
    echo "QuickNTP download\033[32m success\033[0m."
    # --- 添加文件类型检查 ---
    # 使用 file 命令检查文件类型，并用 grep -q 静默检查输出是否包含 "Zip archive"
    if ! file QuickNTP.zip | grep -q "Zip archive"; then
        echo -e "\033[31m错误：下载的文件 QuickNTP.zip 不是一个有效的 zip 归档文件。\033[0m"
        echo "文件信息："
        ls -l QuickNTP.zip # 显示文件大小和权限
        file QuickNTP.zip # 显示文件类型
        echo "文件内容前几行 (可能显示错误信息):"
        head QuickNTP.zip # 显示文件内容的前几行
        rm QuickNTP.zip # 清理下载的无效文件
        exit 1 # 退出脚本，表示下载内容有问题
    fi
    # --- 文件类型检查结束 ---

    # 如果文件类型检查通过，再尝试解压
    unzip -oq QuickNTP.zip
    # 检查解压是否成功 (可选，但推荐)
    if [ $? -ne 0 ]; then
        echo -e "解压\033[31m 失败\033[0m."
        # rm QuickNTP.zip # 原脚本在解压后无论成功失败都删除，保持一致
    else
        echo -e "解压\033[32m 成功\033[0m."
    fi
    rm QuickNTP.zip # 清理下载的 zip 文件
fi



### z大色彩校准插件
## Fetch lastest Fizeau from https://github.com/zdm65477730/Fizeau/releases/latest
curl -sL https://api.github.com/repos/zdm65477730/Fizeau/releases/latest \
  | jq '.name' \
  | xargs -I {} echo  {} >> ../description.txt
curl -sL https://api.github.com/repos/zdm65477730/Fizeau/releases/latest \
  | grep -oP '"browser_download_url": "\Khttps://[^"]*Fizeau[^"]*.zip"' \
  | sed 's/"//g' \
  | xargs -I {} curl -sL {} -o Fizeau.zip
if [ $? -ne 0 ]; then
    echo "Fizeau download\033[31m failed\033[0m."
else
    echo "Fizeau download\033[32m success\033[0m."
    unzip -oq Fizeau.zip
    rm Fizeau.zip
fi

### MasterVolume音量调节插件
### Fetch lastest MasterVolume from https://github.com/averne/MasterVolume/releases/latest
curl -sL https://api.github.com/repos/averne/MasterVolume/releases/latest \
  | jq '.tag_name' \
  | xargs -I {} echo MasterVolume {} >> ../description.txt
curl -sL https://api.github.com/repos/averne/MasterVolume/releases/latest \
  | grep -oP '"browser_download_url": "\Khttps://[^"]*MasterVolume.*\.zip[^"]*"' \
  | sed 's/"//g' \
  | xargs -I {} curl -sL {} -o MasterVolume.zip
if [ $? -ne 0 ]; then
    echo "MasterVolume.ovl\033[31m failed\033[0m."
else
    echo "MasterVolume.ovl\033[32m success\033[0m."

    unzip -oq MasterVolume.zip
    rm MasterVolume.zip
fi

### 特斯拉官方初始菜单Ultrahand
### Fetch lastest Ultrahand from https://github.com/ppkantorski/Ultrahand-Overlay/releases/latest
curl -sL https://api.github.com/repos/ppkantorski/Ultrahand-Overlay/releases/latest \
  | jq '.name' \
  | xargs -I {} echo {} >> ../description.txt
curl -sL https://api.github.com/repos/ppkantorski/Ultrahand-Overlay/releases/latest \
  | grep -oP '"browser_download_url": "\Khttps://[^"]*ovlmenu.ovl"' \
  | sed 's/"//g' \
  | xargs -I {} curl -sL {} -o ovlmenu.ovl
if [ $? -ne 0 ]; then
    echo "ovlmenu.ovl\033[31m failed\033[0m."
else
    echo "ovlmenu.ovl\033[32m success\033[0m."

    mv ovlmenu.ovl ./switch/.overlays
fi
### 特斯拉官方初始菜单Ultrahand的汉化包
curl -sL https://api.github.com/repos/ppkantorski/Ultrahand-Overlay/releases/latest \
  | jq '.name' \
  | xargs -I {} echo lang {} >> ../description.txt
curl -sL https://api.github.com/repos/ppkantorski/Ultrahand-Overlay/releases/latest \
  | grep -oP '"browser_download_url": "\Khttps://[^"]*lang.zip[^"]*"' \
  | sed 's/"//g' \
  | xargs -I {} curl -sL {} -o lang.zip
if [ $? -ne 0 ]; then
    echo "lang.zip\033[31m failed\033[0m."
else
    echo "lang.zip\033[32m success\033[0m."
    mkdir -p ./config/ultrahand/lang
    unzip -oq lang.zip
    rm lang.zip
    mv de.json ./config/ultrahand/lang
    mv pl.json ./config/ultrahand/lang
    mv en.json ./config/ultrahand/lang
    mv es.json ./config/ultrahand/lang
    mv fr.json ./config/ultrahand/lang
    mv it.json ./config/ultrahand/lang
    mv ja.json ./config/ultrahand/lang
    mv ko.json ./config/ultrahand/lang
    mv nl.json ./config/ultrahand/lang
    mv pt.json ./config/ultrahand/lang
    mv ru.json ./config/ultrahand/lang
    mv zh-tw.json ./config/ultrahand/lang
    mv zh-cn.json ./config/ultrahand/lang
fi

# -------------------------------------------
#cat >> ../description.txt << ENDOFFILE
#sys-patch-overlay
#ENDOFFILE

### Rename hekate_ctcaer_*.bin to payload.bin
find . -name "*hekate_ctcaer*" -exec mv {} payload.bin \;
if [ $? -ne 0 ]; then
    echo "Rename hekate_ctcaer_*.bin to payload.bin\033[31m failed\033[0m."
else
    echo "Rename hekate_ctcaer_*.bin to payload.bin\033[32m success\033[0m."
fi

### Write hekate_ipl.ini in /bootloader/
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
    echo "Writing hekate_ipl.ini in ./bootloader/ directory\033[31m failed\033[0m."
else
    echo "Writing hekate_ipl.ini in ./bootloader/ directory\033[32m success\033[0m."
fi

### write exosphere.ini in root of SD Card
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
    echo "Writing exosphere.ini in root of SD card\033[31m failed\033[0m."
else
    echo "Writing exosphere.ini in root of SD card\033[32m success\033[0m."
fi

### Write emummc.txt & sysmmc.txt in /atmosphere/hosts
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
    echo "Writing emummc.txt and sysmmc.txt in ./atmosphere/hosts\033[31m failed\033[0m."
else
    echo "Writing emummc.txt and sysmmc.txt in ./atmosphere/hosts\033[32m success\033[0m."
fi

### Write boot.ini in root of SD Card
cat > ./boot.ini << ENDOFFILE
[payload]
file=payload.bin
ENDOFFILE
if [ $? -ne 0 ]; then
    echo "Writing boot.ini in root of SD card\033[31m failed\033[0m."
else
    echo "Writing boot.ini in root of SD card\033[32m success\033[0m."
fi

### Write override_config.ini in /atmosphere/config
cat > ./atmosphere/config/override_config.ini << ENDOFFILE
[hbl_config] 
program_id_0=010000000000100D
override_address_space=39_bit
; 按住R键点击相册进入HBL自制软件界面。
override_key_0=R
ENDOFFILE
if [ $? -ne 0 ]; then
    echo "Writing override_config.ini in ./atmosphere/config\033[31m failed\033[0m."
else
    echo "Writing override_config.ini in ./atmosphere/config\033[32m success\033[0m."
fi

### Write system_settings.ini in /atmosphere/config
cat > ./atmosphere/config/system_settings.ini << ENDOFFILE
[eupld]
; 禁用将错误报告上传到任天堂
upload_enabled = u8!0x0

[ro]
; 控制 RO 是否应简化其对 NRO 的验证。
; （注意：这通常不是必需的，可以使用 IPS 补丁。
ease_nro_restriction = u8!0x1

[atmosphere]
; 是否自动开启所有金手指。0=关。1=开。
dmnt_cheats_enabled_by_default = u8!0x0

; 如果你希望大气记住你上次金手指状态，请删除下方；号
dmnt_always_save_cheat_toggles = u8!0x1

; 如果大气崩溃，10秒后自动重启
; 1秒=1000毫秒，转换16进制
fatal_auto_reboot_interval = u64!0x2710

; 使电源菜单的“重新启动”按钮重新启动到payload
; 设置"normal"正常重启l 设置"rcm"重启RCM，
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
tskin_rate_table_console = str!”[[-1000000, 28000, 0, 0], [28000, 42000, 0, 51], [42000, 48000, 51, 102], [48000, 55000, 102, 153], [55000, 60000, 153, 255], [60000, 68000, 255, 255]]”
tskin_rate_table_handheld = str!”[[-1000000, 28000, 0, 0], [28000, 42000, 0, 51], [42000, 48000, 51, 102], [48000, 55000, 102, 153], [55000, 60000, 153, 255], [60000, 68000, 255, 255]]”
ENDOFFILE
if [ $? -ne 0 ]; then
    echo "Writing system_settings.ini in ./atmosphere/config\033[31m failed\033[0m."
else
    echo "Writing system_settings.ini in ./atmosphere/config\033[32m success\033[0m."
fi

### Delete unneeded files
rm -f switch/haze.nro
rm -f switch/reboot_to_hekate.nro
rm -f switch/reboot_to_payload.nro

# -------------------------------------------

echo ""
echo "\033[32mYour Switch SD card is prepared!\033[0m"
