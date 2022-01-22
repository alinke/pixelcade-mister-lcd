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

#echo "launching MiSTer front end integration"
./MiSTerCade  #-s is for no ip
HERE="$(dirname "$(readlink -f "${0}")")"

saveIP=`cat /media/fat/pixelcade/ip.txt`

echo "Pixelcade is Starting..."
killall -9 pixelcadeLink 2>/dev/null
killall -9 announce 2>/dev/null

if [ "${saveIP}" == "" ]; then
 echo "Finding Pixelcade"
 ${HERE}/pixelcadeFinder |grep Peer| tail -1| cut -d' ' -f2 > /media/fat/pixelcade/ip.txt
 echo "Pixelcade IP: `cat /media/fat/pixelcade/ip.txt`"
else
 echo "Using saved Pixelcade: `cat /media/fat/pixelcade/ip.txt`"
fi

#killall -9 MiSTerKai20210615 2>/dev/null;
#nohup $INSTALLDIR/MiSTerKai20210615 2>/dev/null &
#nohup $INSTALLDIR/pixelcadeLink 2>/dev/null &
nohup sh ${HERE}./pixelcadeLink.sh 2>/dev/null &

echo "Pixelcade is Ready and Running."

echo "You can connect to the MiSTer @ MiSTer.local..."
nohup $INSTALLDIR/announce 2>/dev/null & exit
