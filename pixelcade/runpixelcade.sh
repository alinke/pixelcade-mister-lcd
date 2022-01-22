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
 /media/fat/pixelcade/pixeljre/bin/java -jar pixelcadefindermister.jar
 #${HERE}/pixelcadeFinder |grep Peer| tail -1| cut -d' ' -f2 > /media/fat/pixelcade/ip.txt
 echo "Pixelcade IP: `cat /media/fat/pixelcade/ip.txt`"
else
 echo "Using saved Pixelcade LCD IP Address: `cat /media/fat/pixelcade/ip.txt`"
fi

# but let's do a ping and make sure the Pixelcade IP address is valid

if ping -c 1 $saveIP &> /dev/null
then
  echo 1
  echo "Pixelcade LCD Ping Test Succesfull"
else
  echo 0
  echo "[ERROR] Cannot ping Pixelcade LCD, let's look for it again"
  cd /media/fat/pixelcade
  /media/fat/pixelcade/pixeljre/bin/java -jar pixelcadefindermister.jar
fi

nohup sh ${HERE}./pixelcadeLink.sh 2>/dev/null &

echo "Pixelcade is Ready and Running."

echo "You can connect to the MiSTer @ MiSTer.local..."
nohup $INSTALLDIR/announce 2>/dev/null & exit
