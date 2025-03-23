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



#### Fetch latest Hekate + Nyx from https://github.com/CTCaer/hekate/releases/latest
#curl -sL https://api.github.com/repos/CTCaer/hekate/releases/latest \
#  | jq '.name' \
#  | xargs -I {} echo {} >> ../description.txt
#curl -sL https://api.github.com/repos/CTCaer/hekate/releases/latest \
#  | grep -oP '"browser_download_url": "\Khttps://[^"]*hekate_ctcaer[^"]*.zip"' \
#  | sed 's/"//g' \
#  | xargs -I {} curl -sL {} -o hekate.zip
#if [ $? -ne 0 ]; then
#    echo "Hekate + Nyx download\033[31m failed\033[0m."
#else
#    echo "Hekate + Nyx download\033[32m success\033[0m."
#    unzip -oq hekate.zip
#    rm hekate.zip
#fi
#
#### Fetch Nyx CHS
#curl -sL https://raw.githubusercontent.com/huangqian8/SwitchPlugins/main/lang/nyx.zip -o nyx.zip
#if [ $? -ne 0 ]; then
#    echo "Nyx CHS download\033[31m failed\033[0m."
#else
#    echo "Nyx CHS download\033[32m success\033[0m."
#    mv ./bootloader/sys/nyx.bin ./bootloader/sys/nys-en.bin
#    unzip -oq nyx.zip
#    rm nyx.zip
#fi

### Fetch logo
curl -sL https://raw.githubusercontent.com/Zhuwenxue2002/SwitchPlugins/main/theme/logo.zip -o logo.zip
if [ $? -ne 0 ]; then
    echo "logo download\033[31m failed\033[0m."
else
    echo "logo download\033[32m success\033[0m."
    unzip -oq logo.zip
    rm logo.zip
fi

#### Fetch latest SigPatches.zip
#curl -sL https://sigmapatches.su/sigpatches.zip?03.29.2024 -o sigpatches.zip
#if [ $? -ne 0 ]; then
#    echo "SigPatches download\033[31m failed\033[0m."
#else
#    echo "SigPatches download\033[32m success\033[0m."
#    unzip -oq sigpatches.zip
#    rm sigpatches.zip
#fi

#### Fetch SigPatches.zip 此版本为gba论坛版本，更新支持18.1.0
#curl -sL https://raw.githubusercontent.com/Zhuwenxue2002/SwitchPlugins/main/plugins/sigpatches.zip -o sigpatches.zip
#if [ $? -ne 0 ]; then
#    echo "sigpatches download\033[31m failed\033[0m."
#else
#    echo "sigpatches download\033[32m success\033[0m."
#    unzip -oq sigpatches.zip
#    rm sigpatches.zip
#fi

#### Fetch latest Lockpick_RCM.bin from https://github.com/Decscots/Lockpick_RCM/releases/latest
#curl -sL https://api.github.com/repos/Decscots/Lockpick_RCM/releases/latest \
#  | jq '.tag_name' \
#  | xargs -I {} echo Lockpick_RCM {} >> ../description.txt
#curl -sL https://api.github.com/repos/Decscots/Lockpick_RCM/releases/latest \
#  | grep -oP '"browser_download_url": "\Khttps://[^"]*Lockpick_RCM.bin"' \
#  | sed 's/"//g' \
#  | xargs -I {} curl -sL {} -o Lockpick_RCM.bin
#if [ $? -ne 0 ]; then
#    echo "Lockpick_RCM download\033[31m failed\033[0m."
#else
#    echo "Lockpick_RCM download\033[32m success\033[0m."
#    mv Lockpick_RCM.bin ./bootloader/payloads
#fi

### 原版被删库，更换拉取huanqian8大佬插件包
### Fetch latest Lockpick_RCM.bin
curl -sL https://raw.githubusercontent.com/huangqian8/SwitchPlugins/main/plugins/Lockpick_RCM.zip -o Lockpick_RCM.zip
if [ $? -ne 0 ]; then
    echo "Lockpick_RCM download\033[31m failed\033[0m."
else
    echo "Lockpick_RCM download\033[32m success\033[0m."
    echo Lockpick_RCM v1.9.12 >> ../description.txt
    unzip -oq Lockpick_RCM.zip
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

#### Fetch latest CommonProblemResolver.bin form https://github.com/zdm65477730/CommonProblemResolver/releases
#curl -sL https://api.github.com/repos/zdm65477730/CommonProblemResolver/releases/latest \
#  | jq '.tag_name' \
#  | xargs -I {} echo CommonProblemResolver {} >> ../description.txt
#curl -sL https://api.github.com/repos/zdm65477730/CommonProblemResolver/releases/latest \
#  | grep -oP '"browser_download_url": "\Khttps://[^"]*CommonProblemResolver.bin"' \
#  | sed 's/"//g' \
#  | xargs -I {} curl -sL {} -o CommonProblemResolver.bin
#if [ $? -ne 0 ]; then
#    echo "CommonProblemResolver download\033[31m failed\033[0m."
#else
#    echo "CommonProblemResolver download\033[32m success\033[0m."
#    mv CommonProblemResolver.bin ./bootloader/payloads
#fi

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

#### Fetch lastest Switch_90DNS_tester
#curl -sL https://raw.githubusercontent.com/Zhuwenxue2002/SwitchPlugins/main/plugins/Switch_90DNS_tester.zip -o Switch_90DNS_tester.zip
#if [ $? -ne 0 ]; then
#    echo "Switch_90DNS_tester download\033[31m failed\033[0m."
#else
#    echo "Switch_90DNS_tester download\033[32m success\033[0m."
#    unzip -oq Switch_90DNS_tester.zip
#    rm Switch_90DNS_tester.zip
#fi

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

### 更换原版NX-Activity-Log拉取地址
curl -sL https://api.github.com/repos/tallbl0nde/NX-Activity-Log/releases/latest \
  | jq '.name' \
  | xargs -I {} echo NX-Activity-Log {} >> ../description.txt
curl -sL https://api.github.com/repos/tallbl0nde/NX-Activity-Log/releases/latest \
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

#### Fetch lastest NX-Activity-Log
#curl -sL https://raw.githubusercontent.com/huangqian8/SwitchPlugins/main/plugins/NX-Activity-Log.zip -o NX-Activity-Log.zip
#if [ $? -ne 0 ]; then
#    echo "NX-Activity-Log download\033[31m failed\033[0m."
#else
#    echo "NX-Activity-Log download\033[32m success\033[0m."
#    unzip -oq NX-Activity-Log.zip
#    rm NX-Activity-Log.zip
#fi

#### Fetch lastest NXThemesInstaller from https://github.com/exelix11/SwitchThemeInjector/releases/latest
#curl -sL https://api.github.com/repos/exelix11/SwitchThemeInjector/releases/latest \
#  | jq '.tag_name' \
#  | xargs -I {} echo NXThemesInstaller {} >> ../description.txt
#curl -sL https://api.github.com/repos/exelix11/SwitchThemeInjector/releases/latest \
#  | grep -oP '"browser_download_url": "\Khttps://[^"]*NXThemesInstaller.nro"' \
#  | sed 's/"//g' \
#  | xargs -I {} curl -sL {} -o NXThemesInstaller.nro
#if [ $? -ne 0 ]; then
#    echo "NXThemesInstaller download\033[31m failed\033[0m."
#else
#    echo "NXThemesInstaller download\033[32m success\033[0m."
#    mkdir -p ./switch/NXThemesInstaller
#    mv NXThemesInstaller.nro ./switch/NXThemesInstaller
#fi

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

#### Fetch lastest tencent-switcher-gui from https://github.com/CaiMiao/Tencent-switcher-GUI/releases/latest
#curl -sL https://api.github.com/repos/CaiMiao/Tencent-switcher-GUI/releases/latest \
#  | jq '.tag_name' \
#  | xargs -I {} echo tencent-switcher-gui {} >> ../description.txt
#curl -sL https://api.github.com/repos/CaiMiao/Tencent-switcher-GUI/releases/latest \
#  | grep -oP '"browser_download_url": "\Khttps://[^"]*tencent-switcher-gui.nro"' \
#  | sed 's/"//g' \
#  | xargs -I {} curl -sL {} -o tencent-switcher-gui.nro
#if [ $? -ne 0 ]; then
#    echo "tencent-switcher-gui download\033[31m failed\033[0m."
#else
#    echo "tencent-switcher-gui download\033[32m success\033[0m."
#    mkdir -p ./switch/tencent-switcher-gui
#    mv tencent-switcher-gui.nro ./switch/tencent-switcher-gui
#fi

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

#### Fetch lastest Switchfin from https://github.com/dragonflylee/switchfin/releases/latest
#curl -sL https://api.github.com/repos/dragonflylee/switchfin/releases/latest \
#  | jq '.tag_name' \
#  | xargs -I {} echo Switchfin {} >> ../description.txt
#curl -sL https://api.github.com/repos/dragonflylee/switchfin/releases/latest \
#  | grep -oP '"browser_download_url": "\Khttps://[^"]*Switchfin.nro"' \
#  | sed 's/"//g' \
#  | xargs -I {} curl -sL {} -o Switchfin.nro
#if [ $? -ne 0 ]; then
#    echo "Switchfin download\033[31m failed\033[0m."
#else
#    echo "Switchfin download\033[32m success\033[0m."
#    mkdir -p ./switch/Switchfin
#    mv Switchfin.nro ./switch/Switchfin
#fi

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

#### Fetch lastest theme-patches from https://github.com/exelix11/theme-patches
#git clone https://github.com/exelix11/theme-patches
#if [ $? -ne 0 ]; then
#    echo "theme-patches download\033[31m failed\033[0m."
#else
#    echo "theme-patches download\033[32m success\033[0m."
#    mkdir themes
#    mv -f theme-patches/systemPatches ./themes/
#    rm -rf theme-patches
#fi

### 删除NX-Shell插件
#### Fetch lastest NX-Shell from https://github.com/joel16/NX-Shell/releases/latest
#curl -sL https://api.github.com/repos/joel16/NX-Shell/releases/latest \
#  | jq '.tag_name' \
#  | xargs -I {} echo NX-Shell {} >> ../description.txt
#curl -sL https://api.github.com/repos/joel16/NX-Shell/releases/latest \
#  | grep -oP '"browser_download_url": "\Khttps://[^"]*NX-Shell.nro"' \
#  | sed 's/"//g' \
#  | xargs -I {} curl -sL {} -o NX-Shell.nro
#if [ $? -ne 0 ]; then
#    echo "NX-Shell download\033[31m failed\033[0m."
#else
#    echo "NX-Shell download\033[32m success\033[0m."
#    mkdir -p ./switch/NX-Shell
#    mv NX-Shell.nro ./switch/NX-Shell
#fi

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


### Fetch nx-ovlloader
### Tesla加载器，目前只能用仓库方案，没联系上zdm大佬
curl -sL https://raw.githubusercontent.com/Zhuwenxue2002/SwitchPlugins/main/plugins/nx-ovlloader.zip -o nx-ovlloader.zip
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


#### Fetch Ultrahand
#### Tesla初始菜单，目前只能用仓库方案用以极限超频，没联系上zdm大佬
#curl -sL https://raw.githubusercontent.com/Zhuwenxue2002/SwitchPlugins/main/plugins/Ultrahand.zip -o Ultrahand.zip
#if [ $? -ne 0 ]; then
#    echo "Ultrahand download\033[31m failed\033[0m."
#else
#    echo "Ultrahand download\033[32m success\033[0m."
#    unzip -oq Ultrahand.zip
#    rm Ultrahand.zip
#fi

#### Fetch Ultrahand
#### Tesla初始菜单，目前只能用仓库方案用以极限超频，没联系上zdm大佬
#curl -sL https://raw.githubusercontent.com/Zhuwenxue2002/SwitchPlugins/main/plugins/Ultrahand.zip -o Ultrahand.zip
#if [ $? -ne 0 ]; then
#    echo "Ultrahand download\033[31m failed\033[0m."
#else
#    echo "Ultrahand download\033[32m success\033[0m."
#    unzip -oq Ultrahand.zip
#    rm Ultrahand.zip
#fi

#### Fetch Tesla-Menu
#### Tesla初始菜单，目前只能用仓库方案，没联系上zdm大佬
#curl -sL https://raw.githubusercontent.com/Zhuwenxue2002/SwitchPlugins/main/plugins/Tesla-Menu.zip -o Tesla-Menu.zip
#if [ $? -ne 0 ]; then
#    echo "Tesla-Menu download\033[31m failed\033[0m."
#else
#    echo "Tesla-Menu download\033[32m success\033[0m."
#    unzip -oq Tesla-Menu.zip
#    rm Tesla-Menu.zip
#fi

#### Write sort.cfg in /config/Tesla-Menu/sort.cfg
#cat > ./config/Tesla-Menu/sort.cfg << ENDOFFILE
#EdiZon
#ovl-sysmodules
#StatusMonitor
#sys-clk-overlay
#ReverseNX-RT
#QuickNTP
#sys-patch-overlay
#ENDOFFILE


### Fetch EdiZon
curl -sL https://raw.githubusercontent.com/Zhuwenxue2002/SwitchPlugins/main/plugins/EdiZon.zip -o EdiZon.zip
if [ $? -ne 0 ]; then
    echo "EdiZon download\033[31m failed\033[0m."
else
    echo "EdiZon download\033[32m success\033[0m."
    unzip -oq EdiZon.zip
    rm EdiZon.zip
fi

### Fetch ovl-sysmodules
curl -sL https://raw.githubusercontent.com/Zhuwenxue2002/SwitchPlugins/main/plugins/ovl-sysmodules.zip -o ovl-sysmodules.zip
if [ $? -ne 0 ]; then
    echo "ovl-sysmodules download\033[31m failed\033[0m."
else
    echo "ovl-sysmodules download\033[32m success\033[0m."
    unzip -oq ovl-sysmodules.zip
    rm ovl-sysmodules.zip
fi

#### 直接拉取原版StatusMonitor
#### Fetch StatusMonitor
#curl -sL https://raw.githubusercontent.com/Zhuwenxue2002/SwitchPlugins/main/plugins/StatusMonitor.zip -o StatusMonitor.zip
#if [ $? -ne 0 ]; then
#    echo "StatusMonitor download\033[31m failed\033[0m."
#else
#    echo "StatusMonitor download\033[32m success\033[0m."
#    unzip -oq StatusMonitor.zip
#    rm StatusMonitor.zip
#fi

#### Fetch StatusMonitor from https://github.com/masagrator/Status-Monitor-Overlay/releases/latest
#curl -sL https://api.github.com/repos/masagrator/Status-Monitor-Overlay/releases/latest \
#  | jq '.name' \
#  | xargs -I {} echo {} >> ../description.txt
#curl -sL https://api.github.com/repos/masagrator/Status-Monitor-Overlay/releases/latest \
#  | grep -oP '"browser_download_url": "\Khttps://[^"]*Status-Monitor-Overlay.zip"' \
#  | sed 's/"//g' \
#  | xargs -I {} curl -sL {} -o Status-Monitor-Overlay.zip
#if [ $? -ne 0 ]; then
#    echo "Status-Monitor-Overlay download\033[31m failed\033[0m."
#else
#    echo "Status-Monitor-Overlay download\033[32m success\033[0m."
#    unzip -oq Status-Monitor-Overlay.zip
#    rm Status-Monitor-Overlay.zip
#fi

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

# 直接从EOS作者的GitHub上拉取他提供的sys-clk
#### Fetch sys-clk-oc
#curl -sL https://raw.githubusercontent.com/Zhuwenxue2002/SwitchPlugins/main/plugins/sys-clk-oc.zip -o sys-clk-oc.zip
#if [ $? -ne 0 ]; then
#    echo "sys-clk-oc download\033[31m failed\033[0m."
#else
#    echo "sys-clk-oc download\033[32m success\033[0m."
#    unzip -oq sys-clk-oc.zip
#    rm sys-clk-oc.zip
#fi

### Fetch ReverseNX-RT
curl -sL https://raw.githubusercontent.com/Zhuwenxue2002/SwitchPlugins/main/plugins/ReverseNX-RT.zip -o ReverseNX-RT.zip
if [ $? -ne 0 ]; then
    echo "ReverseNX-RT download\033[31m failed\033[0m."
else
    echo "ReverseNX-RT download\033[32m success\033[0m."
    unzip -oq ReverseNX-RT.zip
    rm ReverseNX-RT.zip
fi

#### Fetch ldn_mitm
#curl -sL https://raw.githubusercontent.com/Zhuwenxue2002/SwitchPlugins/main/plugins/ldn_mitm.zip -o ldn_mitm.zip
#if [ $? -ne 0 ]; then
#    echo "ldn_mitm download\033[31m failed\033[0m."
#else
#    echo "ldn_mitm download\033[32m success\033[0m."
#    unzip -oq ldn_mitm.zip
#    rm ldn_mitm.zip
#fi

#### Fetch emuiibo
#curl -sL https://raw.githubusercontent.com/Zhuwenxue2002/SwitchPlugins/main/plugins/emuiibo.zip -o emuiibo.zip
#if [ $? -ne 0 ]; then
#    echo "emuiibo download\033[31m failed\033[0m."
#else
#    echo "emuiibo download\033[32m success\033[0m."
#    unzip -oq emuiibo.zip
#    rm emuiibo.zip
#fi

### Fetch QuickNTP
curl -sL https://raw.githubusercontent.com/Zhuwenxue2002/SwitchPlugins/main/plugins/QuickNTP.zip -o QuickNTP.zip
if [ $? -ne 0 ]; then
    echo "QuickNTP download\033[31m failed\033[0m."
else
    echo "QuickNTP download\033[32m success\033[0m."
    unzip -oq QuickNTP.zip
    rm QuickNTP.zip
fi


#### Fetch sys-tune
#curl -sL https://raw.githubusercontent.com/Zhuwenxue2002/SwitchPlugins/main/plugins/sys-tune.zip -o sys-tune.zip
#if [ $? -ne 0 ]; then
#    echo "sys-tune download\033[31m failed\033[0m."
#else
#    echo "sys-tune download\033[32m success\033[0m."
#    unzip -oq sys-tune.zip
#    rm sys-tune.zip
#fi

#### Fetch sys-patch
#### 更新版本为gba仓库版本呢，不用东方的包了
#curl -sL https://raw.githubusercontent.com/Zhuwenxue2002/SwitchPlugins/main/plugins/sys-patch.zip -o sys-patch.zip
#if [ $? -ne 0 ]; then
#    echo "sys-patch download\033[31m failed\033[0m."
#else
#    echo "sys-patch download\033[32m success\033[0m."
#    unzip -oq sys-patch.zip
#    rm sys-patch.zip
#fi

#### 新增sysDvr
#curl -sL https://raw.githubusercontent.com/Zhuwenxue2002/SwitchPlugins/main/plugins/SysDVR.zip -o SysDVR.zip
#if [ $? -ne 0 ]; then
#    echo "SysDVR download\033[31m failed\033[0m."
#else
#    echo "SysDVR download\033[32m success\033[0m."
#    unzip -oq SysDVR.zip
#    rm SysDVR.zip
#fi

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
cat >> ../description.txt << ENDOFFILE
nx-ovlloader
EdiZon
ovl-sysmodules
ReverseNX-RT
QuickNTP
sys-patch-overlay
ENDOFFILE

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
