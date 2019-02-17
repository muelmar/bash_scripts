#!/bin/bash
inputfile="$1"
if [[ ! -r $inputfile ]] ; then
	echo "$1 not readable."
	exit 4 
fi
#outputfilename="${inputfile%%.txt}.out"
outputfilename="${inputfile%%.txt}_new.txt"
echo $outputfilename
cp -i "$inputfile" "$outputfilename" ;
#g/^[0-9]\..*/s/^[0-9]\.[0-9\.]*\(.*\)/anfang\1ende/
ex -c 'g/^[^0-9]/d' -c '%s/^[0-9\. ]*\(.*\)$/Anfang\1ENDE/' -cx "$outputfilename"

