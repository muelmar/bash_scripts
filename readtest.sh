#!/bin/bash
declare -a array

#read -a array name age email
readarray -t    array <<EOF
1 2 3
3 4 5 
EOF
echo “Your name, age, and email address are: ${array[1]} name age email”


