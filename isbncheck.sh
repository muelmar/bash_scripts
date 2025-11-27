#!/bin/bash
if [[ ! -r $1 ]] ; then
   echo "$1 failed to open"
fi
paste <(qsv select --delimiter ';'  isbn,Titel $1 | qsv behead) <(qsv foreach --delimiter ';' isbn './isbn_test.py {}'  --dry-run false  $1 ) | qsv luau --no-headers  filter --no-globals 'not string.match(col[2],col[3])'


