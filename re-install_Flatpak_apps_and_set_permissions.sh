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