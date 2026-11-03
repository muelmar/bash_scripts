#!/bin/bash
#use ocrmypdf
if (( $# !=  3 )) ; 
	    then echo "illegal number of parameters: $#"
fi
docname=$(printf "%06i_%5s.pdf" "$1" "${2:0:5}")
echo $docname
