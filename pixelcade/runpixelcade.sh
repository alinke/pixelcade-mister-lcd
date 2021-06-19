#!/bin/bash
pixelcade_detected=false
java_installed=false
INSTALLDIR=$(readlink -f $(dirname "$0"))

cat << "EOF"
       _          _               _
 _ __ (_)_  _____| | ___ __ _  __| | ___
| '_ \| \ \/ / _ \ |/ __/ _` |/ _` |/ _ \
| |_) | |>  <  __/ | (_| (_| | (_| |  __/
| .__/|_/_/\_\___|_|\___\__,_|\__,_|\___|
|_|
EOF

echo "${magenta}       Pixelcade LCD Launcher for MiSTer $version    ${white}"
echo ""
echo "Ensure your Pixelcade LCD is on the same network as your MiSTer"
#let's check if pixelweb is already running and if so, kill it

./MiSTerCade
