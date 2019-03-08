#!/bin/bash
#declare -a veto=(Schlager Mager Fastnacht);
veto='Schlager|Mager|Fastnacht|Benny Goodman|Irish Tour';
rm /zfs/public/music/playlist/*
#find /zfs/public/music/wav -type f -name '*wav' -execdir ln {} /zfs/public/music/playlist/ \;
find /zfs/public/music/wav -type f -name '*wav' -print0 | while read -d '' f; 
do  
   if [[ $f =~ $veto ]] ; then 
      echo ignoring $f;
   else
      rnd=$(od -vAn -N4 -tu4 < /dev/urandom | tr -d ' ')
      newname="${rnd}$(echo "${f##*/}" | tr ' ' '_'| tr -cd '[A-Za-z_.]' )";
      ln "${f}" "/zfs/public/music/playlist/${newname}"
   fi
done
