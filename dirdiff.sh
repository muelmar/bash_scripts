#!/bin/bash
d1=$1
d2=$2
for d in $d1/*/* ; do
	dbase=$(basename "$d")
	if [[ -f "$d2/*/$dbase" ]] ; then 
        	echo $dbase
	fi
done


