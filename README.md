# Flatpakアプリケーション：再インストール時の便利なスクリプト

## はじめに
OSの再インストール時に使い慣れた環境を自動で再現するスクリプトを以前紹介しました。

[システム再インストールを楽にする手順: 専用BashScriptのすすめ](https://zenn.dev/ykesamaru/articles/1ab1297354d3c2)

その投稿ではFlatpakアプリケーションのインストールについては
- システムレベルでのインストール限定
- パーミッションの変更なし
という状態でした。

この投稿ではそれを改良し、
- ユーザーレベルでのインストール
- 日本語入力を可能にしたパーミッション設定
を導入します。

先述の投稿にある`int.sh`から呼び出すFlatpakアプリケーション用のスクリプト`re-install_Flatpak_apps_and_set_permissions.sh`を紹介します。

![](https://raw.githubusercontent.com/yKesamaru/re-install_flatpak_app_and_set_permissions/master/assets/eye-catch.webp)

1. [Flatpakアプリケーション：再インストール時の便利なスクリプト](#flatpakアプリケーション再インストール時の便利なスクリプト)
   1. [はじめに](#はじめに)
   2. [参考文献](#参考文献)
   3. [環境](#環境)
   4. [前提](#前提)
   5. [再インストール時のbashスクリプト](#再インストール時のbashスクリプト)
   6. [スクリプト内容解説](#スクリプト内容解説)
      1. [アプリケーションID](#アプリケーションid)
      2. [Flatpakアプリケーションインストール](#flatpakアプリケーションインストール)
      3. [権限（パーミッション）の上書き(override)](#権限パーミッションの上書きoverride)
         1. [上書きした権限の詳細](#上書きした権限の詳細)
            1. [`kdenlive`](#kdenlive)
            2. [`blender`](#blender)


## 参考文献
- [Flatpak vs. Snap. 違いと特性](https://zenn.dev/ykesamaru/articles/a9586cc52a376e)
- [システム再インストールを楽にする手順: 専用BashScriptのすすめ](https://zenn.dev/ykesamaru/articles/1ab1297354d3c2)
- [日本語入力周りの整理・まとめ](https://zenn.dev/ykesamaru/articles/95ad7355c9bbba)
- [Flatpakインストール周りの整理・まとめ](https://zenn.dev/ykesamaru/articles/c3afb6097ca48a)

## 環境
```bash
inxi -S
System:
  Host: **user** Kernel: 6.5.0-35-generic x86_64 bits: 64 Desktop: GNOME 42.9
    Distro: Ubuntu 22.04.4 LTS (Jammy Jellyfish)
```

## 前提
- コード中の`**user**`はユーザー名に置換してください

## 再インストール時のbashスクリプト
```bash
#!/bin/bash

# アプリケーションID
BLENDER_APP_ID="org.blender.Blender"
KDENLIVE_APP_ID="org.kde.kdenlive"
PDFARRANGER_APP_ID="com.github.jeromerobert.pdfarranger"
COPYQ_APP_ID="com.github.hluk.copyq"
FLATSEAL_APP_ID="com.github.tchx84.Flatseal"

# BlenderとKdenliveをインストール
flatpak install --user -y flathub $BLENDER_APP_ID
flatpak install --user -y flathub $KDENLIVE_APP_ID

# PDF Arranger, CopyQ, Flatsealをインストール
flatpak install --user -y flathub $PDFARRANGER_APP_ID
flatpak install --user -y flathub $COPYQ_APP_ID
flatpak install --user -y flathub $FLATSEAL_APP_ID

# Blenderの権限設定
flatpak override --user --filesystem=/run/spnav.sock:ro $BLENDER_APP_ID
flatpak override --user --filesystem=/home/**user** $BLENDER_APP_ID
flatpak override --user --filesystem=host $BLENDER_APP_ID
flatpak override --user --socket=x11 --socket=wayland --socket=pulseaudio --socket=session-bus --socket=system-bus --socket=fallback-x11 $BLENDER_APP_ID
flatpak override --user --device=dri $BLENDER_APP_ID
flatpak override --user --talk-name=org.freedesktop.IBus $BLENDER_APP_ID
flatpak override --user --env=QT_IM_MODULE=ibus $BLENDER_APP_ID
flatpak override --user --env=SPNAV_SOCKET=/run/spnav.sock $BLENDER_APP_ID
flatpak override --user --env=LD_LIBRARY_PATH=/app/lib $BLENDER_APP_ID
flatpak override --user --env=XMODIFIERS=@im=ibus $BLENDER_APP_ID
flatpak override --user --env=GTK_IM_MODULE=ibus $BLENDER_APP_ID
flatpak override --user --env=TMP_DIR=/tmp $BLENDER_APP_ID
flatpak override --user --env=TMP=/tmp $BLENDER_APP_ID

# Kdenliveの権限設定
flatpak override --user --filesystem=/run/media $KDENLIVE_APP_ID
flatpak override --user --filesystem=xdg-run/gvfs $KDENLIVE_APP_ID
flatpak override --user --filesystem=xdg-pictures $KDENLIVE_APP_ID
flatpak override --user --filesystem=xdg-videos $KDENLIVE_APP_ID
flatpak override --user --socket=x11 --socket=wayland --socket=pulseaudio --socket=session-bus --socket=system-bus --socket=fallback-x11 $KDENLIVE_APP_ID
flatpak override --user --device=dri $KDENLIVE_APP_ID
flatpak override --user --talk-name=org.freedesktop.IBus $KDENLIVE_APP_ID
flatpak override --user --env=QT_IM_MODULE=ibus $KDENLIVE_APP_ID
flatpak override --user --env=GTK_IM_MODULE=ibus $KDENLIVE_APP_ID
flatpak override --user --env=XMODIFIERS=@im=ibus $KDENLIVE_APP_ID
```

## スクリプト内容解説
ここでは簡単に解説します。詳細は「参考文献」をご参照ください。
### アプリケーションID
```bash
# アプリケーションID
BLENDER_APP_ID="org.blender.Blender"
KDENLIVE_APP_ID="org.kde.kdenlive"
PDFARRANGER_APP_ID="com.github.jeromerobert.pdfarranger"
COPYQ_APP_ID="com.github.hluk.copyq"
FLATSEAL_APP_ID="com.github.tchx84.Flatseal"
```
これらは再インストールするFlatpakアプリケーションです。アプリケーションIDは`flatpak list`で調べられます。
### Flatpakアプリケーションインストール
```bash
# BlenderとKdenliveをインストール
flatpak install --user -y flathub $BLENDER_APP_ID
flatpak install --user -y flathub $KDENLIVE_APP_ID

# PDF Arranger, CopyQ, Flatsealをインストール
flatpak install --user -y flathub $PDFARRANGER_APP_ID
flatpak install --user -y flathub $COPYQ_APP_ID
flatpak install --user -y flathub $FLATSEAL_APP_ID
```
`--user`をつけ、ユーザーレベルでのインストールを行います。
ユーザーレベルとシステムレベルの違いやメリット・デメリットについては参考文献の「[Flatpakインストール周りの整理・まとめ](https://zenn.dev/ykesamaru/articles/c3afb6097ca48a)」をご参照ください。
### 権限（パーミッション）の上書き(override)
`kdenlive`と`blender`において日本語入力に問題が存在します。
`kdenlive`では日本語の直接入力ができないこと、`blender`においては（日本語直接入力は元からできず）日本語のコピーペーストが行えないことが課題でした。
下記のコマンドラインはそれらを解決するものです。
権限の上書きだけなら`Flatseal`からGUIでできますが、再インストール時には自動で行わせたいのでスクリプトにしました。
```bash
# Blenderの権限設定
flatpak override --user --filesystem=/run/spnav.sock:ro $BLENDER_APP_ID
flatpak override --user --filesystem=/home/**user** $BLENDER_APP_ID
flatpak override --user --filesystem=host $BLENDER_APP_ID
flatpak override --user --socket=x11 --socket=wayland --socket=pulseaudio --socket=session-bus --socket=system-bus --socket=fallback-x11 $BLENDER_APP_ID
flatpak override --user --device=dri $BLENDER_APP_ID
flatpak override --user --talk-name=org.freedesktop.IBus $BLENDER_APP_ID
flatpak override --user --env=QT_IM_MODULE=ibus $BLENDER_APP_ID
flatpak override --user --env=SPNAV_SOCKET=/run/spnav.sock $BLENDER_APP_ID
flatpak override --user --env=LD_LIBRARY_PATH=/app/lib $BLENDER_APP_ID
flatpak override --user --env=XMODIFIERS=@im=ibus $BLENDER_APP_ID
flatpak override --user --env=GTK_IM_MODULE=ibus $BLENDER_APP_ID
flatpak override --user --env=TMP_DIR=/tmp $BLENDER_APP_ID
flatpak override --user --env=TMP=/tmp $BLENDER_APP_ID

# Kdenliveの権限設定
flatpak override --user --filesystem=/run/media $KDENLIVE_APP_ID
flatpak override --user --filesystem=xdg-run/gvfs $KDENLIVE_APP_ID
flatpak override --user --filesystem=xdg-pictures $KDENLIVE_APP_ID
flatpak override --user --filesystem=xdg-videos $KDENLIVE_APP_ID
flatpak override --user --socket=x11 --socket=wayland --socket=pulseaudio --socket=session-bus --socket=system-bus --socket=fallback-x11 $KDENLIVE_APP_ID
flatpak override --user --device=dri $KDENLIVE_APP_ID
flatpak override --user --talk-name=org.freedesktop.IBus $KDENLIVE_APP_ID
flatpak override --user --env=QT_IM_MODULE=ibus $KDENLIVE_APP_ID
flatpak override --user --env=GTK_IM_MODULE=ibus $KDENLIVE_APP_ID
flatpak override --user --env=XMODIFIERS=@im=ibus $KDENLIVE_APP_ID
```
#### 上書きした権限の詳細
これらは基本的に以下のコマンドラインで得られます。
```bash
flatpak info --show-permissions <app-ID>
```
例えば`Blender`ならば以下のようになります。
```bash
flatpak info --show-permissions org.blender.Blender
[Context]
shared=network;ipc;
sockets=x11;wayland;pulseaudio;session-bus;system-bus;fallback-x11;
devices=dri;
filesystems=/run/spnav.sock:ro;/home/**user**;host;

[Session Bus Policy]
org.freedesktop.IBus=talk

[System Bus Policy]
org.freedesktop.IBus=talk

[Environment]
QT_IM_MODULE=ibus
SPNAV_SOCKET=/run/spnav.sock
LD_LIBRARY_PATH=/app/lib
XMODIFIERS=@im=ibus
GTK_IM_MODULE=ibus
TMP_DIR=/tmp
TMP=/tmp
```

##### `kdenlive`
- Device
  - GPU acceleration
- Environment
  - QT_IM_MODULE=ibus
  - GTK_IM_MODULE=ibus
  - XMODIFIERS=@im=ibus
##### `blender`
- Socket
  - D-Bus session bus
  - DBus system bus
- Filesystem
  - Other files
    - `/home/**user**
- Environment
  - QT_IM_MODULE=ibus
  - GTK_IM_MODULE=ibus
  - XMODIFIERS=@im=ibus

以上です。ありがとうございました。