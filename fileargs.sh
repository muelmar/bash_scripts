#!/bin/bash
for d in "$@" ; do 
	echo $d "<<<";
	fn=${d##*/} #remove directory information
	abt=${fn%%_*} #Character up to first "_"
	echo $fn;
	echo "abt=$abt"
	case $fn  in
		*Gruppe*) echo "DAs ist eine Gruppe"
			;;
		*Kurs*) echo HAnball;
			;;
		*) 	echo "unknown File (Gruppe or Kurs?)";
			;;
	esac
done
