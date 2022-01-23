#!/bin/bash
pixelcade_detected=false
java_installed=false
connected=false
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

killall -9 pixelcadeLink 2>/dev/null
killall -9 announce 2>/dev/null
HERE="$(dirname "$(readlink -f "${0}")")"

pixelcade-ip-search() {
  echo "Looking for Pixelcade LCD..."
  i=1
  while [[ $i -lt 6 ]]
  do
    echo "Attempt: $i"
    ((i++))
    ${HERE}/pixelcadeFinder |grep Peer| tail -1| cut -d' ' -f2 > /media/fat/pixelcade/ip.txt
    saveIP=`cat /media/fat/pixelcade/ip.txt`
    if grep -q '[^[:space:]]' "/media/fat/pixelcade/ip.txt"; then
      echo "FOUND Pixelcade LCD at ${saveIP}"
      break
    fi
  done
}

pixelcade-connectivity-test() {
  echo "Testing Pixelcade LCD Connectivity..."
  if curl -m 10 ${saveIP}:8080/v2/info | grep -q 'hostname'; then
    echo "Pixelcade LCD Connectivity Test Succesful at ${saveIP}"
    connected=true
  else
    connected=false
  fi
}

if ! grep -q '[^[:space:]]' "/media/fat/pixelcade/ip.txt"; then  #ip.txt is not there or is empty
  pixelcade-ip-search
else  #ip.txt is there and has a numbe in it so let's use it
    echo "Using saved Pixelcade LCD IP Address: `cat /media/fat/pixelcade/ip.txt`"
    saveIP=`cat /media/fat/pixelcade/ip.txt`
fi

if grep -q '[^[:space:]]' "/media/fat/pixelcade/ip.txt"; then #if ip.txt is there, let's do a connectivity test
  echo "Testing Pixelcade LCD Connectivity..."
  if curl -m 10 ${saveIP}:8080/v2/info | grep -q 'hostname'; then
    echo "Pixelcade LCD Connectivity Test Succesful at ${saveIP}"
    connected=true
  else
    echo "[ERROR] Cannot communicate with Pixelcade LCD, let's try searching again..."
    pixelcade-ip-search
    pixelcade-connectivity-test
  fi
else
  echo "[ERROR] Skipping Pixelcade LCD connecity test as we can't find Pixelcade LCD's IP address"
  connected=false
fi

nohup sh ${HERE}./pixelcadeLink.sh 2>/dev/null &

if [ "${connected}" = true ]; then
  echo "Pixelcade LCD is Ready and Running..."
  echo "Pixelcade LCD should now be changing as you scroll and launch games from the MiSTer arcade front end"
else
  echo "[ERROR] Could not connect to your Pixelcade LCD..."
  echo "Please try running this command again:"
  echo "cd /media/fat/pixelcade && ./runpixelcade.sh"
fi
