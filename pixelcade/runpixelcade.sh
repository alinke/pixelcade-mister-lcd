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
HERE="$(dirname "$(readlink -f "${0}")")"

saveIP=`cat /media/fat/pixelcade/ip.txt`

echo "Pixelcade is Starting..."
killall -9 pixelcadeLink 2>/dev/null
killall -9 announce 2>/dev/null

if [ "${saveIP}" == "" ]; then
 echo "Finding Pixelcade"
 cd /media/fat/pixelcade
 #/media/fat/pixelcade/pixeljre/bin/java -jar pixelcadefindermister.jar
 ${HERE}/pixelcadeFinder |grep Peer| tail -1| cut -d' ' -f2 > /media/fat/pixelcade/ip.txt
 echo "Pixelcade IP: `cat /media/fat/pixelcade/ip.txt`"
 saveIP=`cat /media/fat/pixelcade/ip.txt`
else
 echo "Using saved Pixelcade LCD IP Address: `cat /media/fat/pixelcade/ip.txt`"
fi

# but let's do a connectivity test and make sure we are communicating

if curl ${saveIP}:8080/v2/info | grep -q 'hostname'; then
  echo "Pixelcade LCD Connectivity Test Succesful"
else
  echo "[ERROR] Cannot communicate with Pixelcade LCD, let's look for it again..."
  ${HERE}/pixelcadeFinder |grep Peer| tail -1| cut -d' ' -f2 > /media/fat/pixelcade/ip.txt
  saveIP=`cat /media/fat/pixelcade/ip.txt`
fi

nohup sh ${HERE}./pixelcadeLink.sh 2>/dev/null &

echo "Pixelcade LCD is Ready and Running..."
echo "Pixelcade LCD should now be changing as you scroll and launch games from the MiSTer arcade front end"

nohup $INSTALLDIR/announce 2>/dev/null & exit
