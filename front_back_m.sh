#!/bin/bash
vorname=vorderseite.pdf
USAGE="$0 -f front -b back [-o output]"
outfilename="vundr.pdf";
vorname="front.pdf";
nachname="back.pdf";
while getopts "f:b:o:" c
    do
          case $c in
         +?)      echo	 "Invalid option $c" ; echo	 "$USAGE" ; exit 2;;
         o)       outfilename=$OPTARG;;
         f)       vorname=$OPTARG;;
         b)       rueckname=$OPTARG;;
         h)       echo $USAGE; exit;;
         \?)      echo	 "Invalid option $OPTARG" ; echo	 "$USAGE";  exit 2;;
         esac
    done
shift $(($OPTIND - 1))
# we donnot expect further parameters
if (( $# != 0 )) ;  then
   echo	  "Fatal: Invalid argument $* "
   echo	 " exiting."
   exit 1;
fi
for f in "$vorname" "$rueckname" ; do
   if [[ ! -r "$f" ]] ; then
      echo "$f not readable"
      exit 4
   fi
done
numpages_v=$(qpdf --show-npages $vorname)
numpages_r=$(qpdf --show-npages $rueckname)
#numpages_v=$( pdftk $vorname dump_data | grep NumberOfPages)
#numpages_v=${numpages_v/*:?/}
#numpages_r=$( pdftk $rueckname dump_data | grep NumberOfPages)
numpages_r=${numpages_r/*:?/}
if (( numpages_v != numpages_r )) ; then
   echo "Number of pages in $vorname not equal pages in $nachname"
   exit 4
fi
cmd="pdfjam"
last=$numpages_v
for (( i=1; i<=numpages_v; i++ )) ; do
     cmd+=" $vorname $i $rueckname $last"
	(( last-- ))
done
cmd+=" -o $outfilename"
$cmd

