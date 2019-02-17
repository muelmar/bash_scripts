#!/bin/bash
for idoc in [[:digit:]][[:digit:]][[:digit:]][[:digit:]][[:digit:]][[:digit:]]*_front.pdf ; do
	echo $idoc
	idoc_back=${idoc%%_front.pdf}_back.pdf
	odoc=${idoc%%_front.pdf}.pdf
	if [[ -r "$idoc_back" ]] ; then
		echo  " $idoc_back "
		~/bin/front_back_m.sh -f "$idoc" -b "$idoc_back" -o output/"$odoc"
		echo "$odoc created"
		mv "$idoc" "$idoc_back" archive/

	else
		echo "$idoc_back not found"
	fi
done
