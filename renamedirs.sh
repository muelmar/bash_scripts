#!/bin/bash
#functions
function newname(){
   local tmp="";
   local s=()
   s=$(basename "$1")
   s=(${s,,})
#string=($string); #string is now lowercase and an array
   if [[ $swap_arg == "1" ]] ; then #user requested swap
      if (( ${#s[@]} == 2 )) ; then # we have two words
        tmp=${s[1]}
        s[1]="${s[0]}"
        s[0]="${tmp}"
      fi
   fi
   s="${s[@]^}" # capitalise words
   echo $s
}
#main
swap_arg="0";
USAGE="rendir.sh -h -c -s"
while getopts "vshde:l:m:" c
    do
          case $c in
         +?)      print "Invalid option $c" ; print "$USAGE" ; exit 2;;
         d)       DDT="Y";;
         s)       swap_arg="1";;
         v)       verbose="T";;
         m)       MMGCMD=$OPTARG;;
         l)       misslist=(${=OPTARG});;
         h)       echo $USAGE; exit;;
         \?)      print "Invalid option $OPTARG" ; print "$USAGE";  exit 2;;
         esac
    done
shift $(($OPTIND - 1))
# we donnot expect further parameters
if (( $# != 0 )) ;  then
   print  "Fatal: Invalid argument $* "
   print " exiting."
   exit 1;
fi
[[ "$verbose" == "T" ]] && printf "info: Start $(date): swap is: %s\n" "$swap_arg";

dirs=(wavtest);
for d in "$dirs"; do
   for f in $d/* ; do
      if [[ -d "$f" ]] ; then
         string=$(newname "$f");
         #[[ "$verbose" == "T" ]] && printf "info: dir: %s to %s\n" "$f" "$string";
         if [[ $string  == "" ]] ; then exit; fi
         if [[ "$f" != "$d"/"$string" ]] ; then
            test -d "$d/$string" ||  mkdir "$d/$string"
            if [[ ! -d  "$d/$string" ]] ; then # something went wrong
               echo  "$d/$string not a directory. Exiting"
               exit 1;
            fi
         [[ "$verbose" == "T" ]] && printf "info: moving: %s to %s\n" "$f" "$d/$string";
               mv "$f"/* "$d/$string" || echo "failed to move"
               #olddir should be empty but dotfiles may still be there
               rmdir "$f" || echo "failed to remove olddir $f";
         fi
      else
         echo "$b" is gar kein directory
      fi
   done
done

