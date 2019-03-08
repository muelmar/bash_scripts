#!/bin/bash
cd /public/ || exit 1
find hans4free -type f  -print0 | while IFS= read -r -d $'\0' f; do 
  n="${f/hans4free/nas}"
   if [[ -f "$n" ]] ; then
       rm "$f"
     else
     echo "$f $n" 
   fi
done

