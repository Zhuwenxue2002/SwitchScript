# 大气层个人整合包生成脚本

**_支持系统版本：18.1.0_**

**_支持大气层版本：1.7.1_**

**_支持hekate版本：6.2.1_**

- 此项目脚本fork自[huangqian8/SwitchScript: 大气层个人整合包生成脚本 (github.com)](https://github.com/huangqian8/SwitchScript)，由xiaobai进行精简

- 整合包明天四点会自动生成并发布，萌新玩家可直接下载使用

- 使用linu系统运行则需要jq依赖，可fork到自己仓库重新开发

- 虽然表面上精简了超级多的插件，但是整合包内置了hb-appstore，可以进入此插件自行下载所需插件

## 功能如下

- 下载最新
  - 大气层三件套
    - [x] `Atmosphere + Fusee` [From Here](https://github.com/Atmosphere-NX/Atmosphere/releases/latest)
    - [x] `EasyWrold汉化整合版`[From Here](https://github.com/easyworld/hekate/releases)
    - [ ] `SigPatches` [From Here](https://gbatemp.net/threads/sigpatches-for-atmosphere-hekate-fss0-fusee-package3.571543/)
  - Payload插件
    - [x] 主机系统的密钥提取工具 `Lockpick_RCM` [From Here](https://github.com/Decscots/Lockpick_RCM/releases/latest)
    - [x] Hekate下的文件管理工具 `TegraExplorer` [From Here](https://github.com/zdm65477730/TegraExplorer/releases/latest)
  - Nro插件
    - [x] 联网检测是否屏蔽任天堂服务器 `Switch_90DNS_tester.nro` [From Here](https://github.com/meganukebmp/Switch_90DNS_tester/releases/latest)
    - [x] 游戏安装，存档管理和文件传输工具 `DBI` [From Here](https://github.com/rashevskyv/dbi/releases/latest)
    - [x] 游戏安装和文件传输工具 `Awoo Installer` [From Here](https://github.com/dragonflylee/Awoo-Installer/releases/latest)
    - [x] 深海工具箱 `Hekate-toolbox` [From Here](https://github.com/WerWolv/Hekate-Toolbox/releases/latest)
    - [x] 游戏游玩时间记录工具 `NX-Activity-Log` [From Here](https://github.com/zdm65477730/NX-Activity-Log/releases/latest)
    - [x] 游戏存档管理工具 `JKSV` [From Here](https://github.com/J-D-K/JKSV/releases/latest)
    - [x] 系统切换工具 `tencent-switcher-gui` [From Here](https://github.com/CaiMiao/Tencent-switcher-GUI/releases/latest)
    - [x] 多工具合一任天堂Switch更新器 `aio-switch-updater` [From Here](https://github.com/HamletDuFromage/aio-switch-updater/releases/latest)
    - [x] 第三方B站客户端 `wiliwili` [From Here](https://github.com/xfangfang/wiliwili/releases/latest)
    - [x] Mod下载器 `SimpleModDownloader` [From Here](https://github.com/PoloNX/SimpleModDownloader/releases/latest)
    - [x] Mod管理器`SimpleModManager`[From Here](https://github.com/nadrino/SimpleModManager)
    - [x] 串流工具 `Moonlight` [From Here](https://github.com/XITRIX/Moonlight-Switch/releases/latest)
    - [x] 文件管理工具 `NX-Shell`[From Here](https://github.com/joel16/NX-Shell)
    - [x] 手柄支持工具 `MissionControl`[From Here](https://github.com/ndeadly/MissionControl)
    - [x] 有线手柄支持工具 `sys-con` [From Here](https://github.com/o0Zz/sys-con)
    - [x] nro插件商店 `hb-appstore` [From Here](https://github.com/fortheusers/hb-appstore)
  - Tesla
    - [x] 加载器 `nx-ovlloader` [From Here](https://www.tekqart.com/thread-222735-1-1.html)
    - [x] 初始菜单 `Ultrahand` [From Here](https://www.tekqart.com/thread-222735-1-1.html)
  - Ovl插件
    - [x] 金手指工具 `EdiZon` [From Here](https://www.tekqart.com/thread-222735-1-1.html)
    - [x] 系统模块 `ovl-sysmodules` [From Here](https://www.tekqart.com/thread-222735-1-1.html)
    - [x] 系统监视 `StatusMonitor` [From Here](https://www.tekqart.com/thread-222735-1-1.html)
    - [x] 系统超频  `sys-clk`[From Here](https://www.tekqart.com/thread-222735-1-1.html)
    - [x] 掌机底座模式切换 `ReverseNX-RT` [From Here](https://www.tekqart.com/thread-222735-1-1.html)
    - [x] 时间同步 `QuickNTP` [From Here](https://www.tekqart.com/thread-222735-1-1.html)
    - [x] 系统补丁 `sys-patch` [From Here](https://gbatemp.net/threads/sigpatches-for-atmosphere-hekate-fss0-fusee-package3.571543/)
- 文件操作：
  - [x] 移动 `fusee.bin` 至 `bootloader/payloads` 文件夹
  - [x] 将 `hekate_ctcaer_*.bin` 重命名为 `payload.bin`
  - [x] 在 `bootloader` 文件夹中创建 `hekate_ipl.ini`
  - [x] 在根目录中创建 `exosphere.ini`
  - [x] 在 `atmosphere/hosts` 文件夹中创建 `emummc.txt` 和 `sysmmc.txt`
  - [x] 在根目录中创建 `boot.ini`
  - [x] 在 `atmosphere/config` 文件夹中创建 `override_config.ini`
  - [x] 在 `atmosphere/config` 文件夹中创建 `system_settings.ini`
  - [x] 删除 `switch` 文件夹中 `haze.nro`
  - [x] 删除 `switch` 文件夹中 `reboot_to_hekate.nro`
  - [x] 删除 `switch` 文件夹中 `reboot_to_payload.nro`

## 精简说明

- 更换switchScript的GithubToken和手动触发，现在可以直接fork后手动触发生成整合包
- 开启dmnt_always_save_cheat_toggles = u8!0x1 让大气层帮忙记住金手指状态
- 不再使用原版hekate+汉化文件的方式，直接使用EasyWorld大佬整合
- 替换90dns原版拉取地址
- 替换NX-Activity-Log原版拉取地址
- 精简tencent-switcher-gui插件（使用zdm大佬的ovl插件ovl-sysmodules即可完成国行 <-> 国际的切换）
- 精简Jellyfin客户端（真把switch当电视机顶盒用啊）
- 精简主题安装工具（我不喜欢用别的主题，听说还会影响机器性能）
- 精简主题破解补丁（理由同上）
- 精简emuiibo（不玩宝可梦好像用不太上这破玩意）
- 精简ldn_mitm（一般是远程联机配合lanplay用）
- 精简sys-tune（一般我听游戏音乐，用不上背景音乐）
- 精简CommonProblemResolver插件（这个插件真的是坑惨我了！！！！）

- 增加nro插件Mod管理器
- 增加nro插件NX-Shell（可以不用连接电脑去删文件了！！！）
- 增加ovl插件sysDvr（又精简了，这玩意除了直播没啥用）
- 增加插件MissionControl（蓝牙手柄连接）
- 增加nro插件sys-con（usb手柄链接） *这个插件不是官方原版，而是一个新分支！！*、
- 增加nro插件商店hb-appstore

## 更新日志

- 2024-06-12：fork脚本建立项目，由小白二次开发
- 2024-06-13：新增插件MissionControl，sys-con
- 2024-06-13：新增插件hb-appstore
- 2024-06-19：精简插件sys-con（因为更新不及时无法支持1.7.1版本启动）
- 2024-06-20：恢复sys-con集成，更改sys-patch和sigpatchs为gba论坛版本
- 2024-06-20：尝试精简掉sigpatches，因为每一个版本都更新太费劲了，开系统还容易提示错误（紧跟huangqian8大佬的脚步）
- 2024-06-20：删除hekate_ipl.ini in /bootloader/文件中的 kip1patch=nosigchk字段，因为精简了sigpatches，不删除这个字段开机会报一个小错误
- 2024-07-05：更新hekate版本号
- 2024-07-10：替换tesla-menu，替换sys-clk，更新极限超频套件
- 2024-07-20：zdm大佬的TegraExplorer插件删除发布，更改由原版地址拉取插件
- 2024-08-23：更新极限超频套件版本为1.4.0，更换拉取地址
- 2024-08-23：更新Ultrahand版本为官方版本，适配EOS1.4.0
- 2024-09-11：修复OC.Toolkit
- 2024-09-11：更换sys-clk为eos作者提供版本
- 2024-09-11：更换Status-Monitor-Overlay为官方提供版本

# Tesla

~~huangqian8大佬使用的Tesla方案是zdm大佬的tesla方案终极版~~

~~好用是真的好用，但是我联系不上zdm大佬要他的github的发行链接~~

所以只能在论坛上下载，然后手动push到github上，属于是手动更更新了

部分插件更换为原版，最大保证兼容性，少部分插件仍然使用Z大编译后的，汉化插件仍然好用

*当然，这个解决方法也是huangqian8大佬想出来的嘿嘿*

[品技论坛（上不去得挂梯子）](https://www.tekqart.com/thread-222735-1-1.html?_dsign=c72d4895)

- **QuickNTP**
- **ovl-sysmodules**
- **ReverseNX-RT和FPSLocker**
- **EdiZon-SE和EdiZon-Overlay**
- **sys-clk**
- **sys-patch** 

# sigpatch + sys patch

[AK478BB/Sigpatches: 大气层签名补丁Sigpatches (github.com)](https://github.com/AK478BB/Sigpatches)

A大曾经讲过从1.7.0开始，sigpatch签名补丁的三种解决方案

此整合包采用了前两种方案：

- 大气层三件套：atmosphere+hekate+sigpatch，且通过Hekate的fss0引导的真实（破解）系统，虚拟（破解）系统的KIP是通过bootloader/patch.ini实现
- 大气层四件套：atmosphere+hekate+sys-patch+tesla，Tesla用于调用sys-patch的菜单通过sys-patch的插件签名补丁的方法

这两种方案同时存在，确保了玩家一定能正常运行游戏

*看不懂没关系，不需要知道原理* 😊

# 关于超频

我明白很多萌新玩家对于超频这个词汇感到陌生和恐慌，但其实稍微了解就明白其中原理了

~~这个up讲的就很清楚~~

~~https://www.bilibili.com/video/BV1V7421Z71A/?spm_id_from=333.337.search-card.all.click~~

不知道什么原因，这个UP把我t出群里了，但他的文章也只是翻译和搬运国外大佬的研究，所以，I don't care

https://rentry.co/ocsc 这个网站则是国外大佬出版的超频教程，随便用浏览器的翻译插件都可以明白其大致意思

在这里我做一个总结：

**switch系统本身对机器的频率限制非常非常大，而普通超频就相当于是解开这个性能墙，对机器本身损害为零，只会影响续航**

很多人玩串流和ppsspp模拟器，都推荐直接刷了安卓和Ubuntu运行，我猜底层优化是其中一个原因，更重要的一个原因是因为这两个系统没有性能墙，直接动态释放了所有的性能

~~极限超频到一定程度才是传统意义上的超频，是对原有的硬件做出一定的破格提升~~

配合FPSLocker插件，实现大部分游戏掌机60帧率不成问题（代价是续航减半）😓

~~在使用普通超频拉满的时候，发现ppsspp的战神跑满也很费劲~~

跟着up主针对自己的机器进行降压调频之后，发现能稳定60帧运行战神，相反功耗并没有提升很多

整合包在2024.7.10的更新中，内置了eos调频套件，其原理是通过eos调整kip文件的频率，让sysclk超频工具能够应用调整好的kip文件参数

调整好kip文件后，推荐做一次backup备份，然后每次更新整合包覆盖更新后，使用备份的kip应用即可

不会调频的小伙伴也没关系，直接使用他默认的kip，也能比普通超频使用更完美的功率（续航版和oled版）

# 关于moonlight串流

上面也提到了，switch本身系统玩串流不如安卓和Ubuntu，但原因之一还是性能释放的问题，*串流对网络，pc性能都有很大影响*

现在moonlight-switch也日益完善，如果萌新不想折腾安装其他系统的话，大可尝试一下

[LizardByte/Sunshine: Self-hosted game stream host for Moonlight. (github.com)](https://github.com/LizardByte/Sunshine)

sunshine的安装也都是一键式安装，优化也越来越好了

打开普通超频，把三大件拉满，谁不想尝试在switch上面玩一下原神呢？

---

# 关于PPSSPP

psp中不乏有很多好游戏，例如：战神、啪嗒砰、乐克乐克、还有switch没有复刻的空之轨迹三部曲

[ppspp ns版本1.5.4Nintendo Switch 综合讨论区 - Powered by Discuz! (tekqart.com)](https://www.tekqart.com/forum.php?mod=viewthread&tid=359053&highlight=ppspp&_dsign=ce3fd0b2)

这个大佬给提供了1.15.4版本，应该是玩家接受更新版本的ppsspp模拟器

实测普通超频拉满的情况下，战神开三倍大部分场景也可以满帧运行

这已经是一个及格的答卷了，也推荐大家去尝试一下

# 关于网络和2123-0011