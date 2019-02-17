#!/bin/bash
declare -a exts=(ogg mp3 flac);

for ext in "${exts[@]}" ; do
   find /zfs/public/music/wav -type f \( -name "*$ext" -o -name "*$ext.m3u" \) -print0 | while read -d '' f; 
   do  
      basn=$(basename "$f")
      dirn=$(dirname "$f")
      newdirn="${dirn/wav/$ext}"
       if [[ ! -d "$newdirn" ]] ; then
          mkdir -p  "$newdirn"
       fi 
       mv  "$f" "$newdirn"
   done
done
#      newname="${rnd}$(echo "${f##*/}" | tr ' ' '_'| tr -cd '[A-Za-z_.]' )";
#      basn=${f##*/}
#      dirn=${f%/*}
