#!/bin/sh

touch /tmp/CURRENTPATH
touch /tmp/CORENAME
touch /tmp/FULLPATH

function urlencode {
#These are enabled by my changes to MiSTer
name=`cat /tmp/CURRENTPATH`
fullPath=`cat /tmp/FULLPATH`

#This is provided by MiSTer by default
system=`cat /tmp/CORENAME`

lastCall=""
REPLY=""
HOST=$1

#From SO or a gist...
function encode {
 local string="${1}"
 local strlen=${#string}
 local encoded=""
#  pos c o

  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:${pos}:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * )               printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
  echo "${encoded}" 
}

#If we are in here, we should request the 'mame name' and not what is on the OSD
if [ "$fullPath" == "_Arcade"  ]; then
  core=`cat /tmp/CORENAME`
  name="${core}.zip"
  system="mame"  
  echo "Synthesized: ${system}/${name}"
fi

#If the ile does not have an extension for he rom, add ".zip" to the call
ext="${current##*.}"
          base="${current##*/}"
          echo "We have: ${base}.${ext}"
          if [[ "$ext" == "$base" ]]; then
            REPLY=".zip"
            echo "adding zip"
          fi


#urlencode everything
encn=`encode "${name}"`

encs=`encode "${system}"`
enct=`encode "${base}"`

if [ "${system}" == "mame"  ]; then
 REPLY=""
fi

if [ "$lastCall" != "${enct}"  ] && [ "${enct}" != ".."  ] ; then
 curl "http://${HOST}:8080/arcade/stream/${encs}/${encn}${REPLY}"
# curl "http://${HOST}:8080/text?t=`encode "  "`"
curl "http://${HOST}:8080/text?t=${enct}&ss=1&c=orange&l=1&game=${encn}&system=${encs}"

 lastCall="${enct}"
 else
  echo "REJECTING: Last call was the same as ${enct} or we have a .." 
fi

}


lastPath="@MARU"

pixelcadeIP=`cat /media/fat/pixelcade/ip.txt 2>/dev/null`



  if [ "${1}" == "" ] && [ "${pixelcadeIP}" == "" ]; then
    echo "version: 1.3"
    echo "Usage: pixecadeLink <pixelcade_ip_address>"
    echo "Shows the currently selected title on a Pixelcade, or a generic marquee if unavailable/no match."
    exit
  fi
  
  if [ "${1}" != "" ] && [ "${pixelcadeIP}" == "" ]; then 
    pixelcadeIP=$1
  fi

echo ":::::::::::::::::::"
echo "::               ::"
echo ":: PixelcadeLink ::"
echo ":: v1.3          ::"
echo "::               ::"
echo ":::::::::::::::::::"
echo "/IP: ${pixelcadeIP}"
echo "Ready."
echo

inotifywait -qm  --timefmt '%Y-%m-%dT%H:%M:%S' --event close_write --format '%T %w %f %e' /tmp/CURRENTPATH | while read datetime dir filename event; do

  if [[ $dir != _* ]]; then
  	current=`cat /tmp/CURRENTPATH`
        fullPath=`cat /tmp/FULLPATH`

  	if [ "${current}" != "${lastPath}" ] && [ "${current}" != "" ]; then
          REPLY=""
   	  urlencode $pixelcadeIP
   	  echo 
   	  lastPath=`cat /tmp/CURRENTPATH`
  	  echo "Last: ${lastPath}"
	  fullPath=`cat /tmp/FULLPATH`
      echo "Full: ${fullPath}"
  	fi
fi

done
