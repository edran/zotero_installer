#!/bin/bash
#
# Zotero installer
# Copyright 2011-2013 Sebastiaan Mathot
# <http://www.cogsci.nl/>
#
# This file is part of qnotero.
#
# qnotero is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# qnotero is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with qnotero.  If not, see <http://www.gnu.org/licenses/>.

VERSION="5.0.23"
if [ `uname -m` == "x86_64" ]; then
	ARCH="x86_64"
else
	ARCH="i686"
fi
TMP="/tmp/zotero.tar.bz2"
DEST_FOLDER=zotero
EXEC=zotero

DEST="/opt"
MENU_PATH="/usr/share/applications/zotero.desktop"
MENU_DIR="/usr/share/applications"

URL="https://download.zotero.org/client/release/${VERSION}/Zotero-${VERSION}_linux-${ARCH}.tar.bz2"

echo ">>> Downloading Zotero standalone $VERSION for $ARCH"
echo ">>> URL: $URL"

wget $URL -O $TMP
if [ $? -ne 0 ]; then
	echo ">>> Failed to download Zotero"
	echo ">>> Aborting installation, sorry!"
	exit 1
fi

if [ -d $DEST/$DEST_FOLDER ]; then
  echo ">>> The destination folder ($DEST/$DEST_FOLDER) exists."
  echo ">>> Removing old Zotero installation"
  rm -Rf $DEST/$DEST_FOLDER
  if [ $? -ne 0 ]; then
			echo ">>> Failed to remove old Zotero installation"
			echo ">>> Aborting installation, sorry!"
			exit 1
  fi
fi

echo ">>> Extracting Zotero"
echo ">>> Target folder: $DEST/$DEST_FOLDER"

tar -xpf $TMP -C $DEST
if [ $? -ne 0 ]; then
	echo ">>> Failed to extract Zotero"
	echo ">>> Aborting installation, sorry!"
	exit 1
fi

mv $DEST/Zotero_linux-$ARCH $DEST/$DEST_FOLDER
if [ $? -ne 0 ]; then
	echo ">>> Failed to move Zotero to $DEST/$DEST_FOLDER"
	echo ">>> Aborting installation, sorry!"
	exit 1
fi

if [ -f $MENU_DIR ]; then
	echo ">>> Creating $MENU_DIR"
	mkdir $MENU_DIR
fi

echo ">>> Creating menu entry"
echo "[Desktop Entry]
Name=Zotero
Comment=Open-source reference manager (standalone version)
Exec=$DEST/$DEST_FOLDER/zotero
Icon=$DEST/$DEST_FOLDER/chrome/icons/default/default48.png
Type=Application
StartupNotify=true" > $MENU_PATH
if [ $? -ne 0 ]; then
  echo ">>> WARNING: Failed to create menu entry"
fi

echo ">>> Done!"
