#!/bin/bash
a=$(</etc/hosts)
 #for i in $a ; do 
	 #echo $i;
 #done

 for i in $(< /etc/hosts)
 do
	 echo "x:  $i"
 done

 #better
 while read -r i ; do
	 echo $i
 done < /etc/hosts

