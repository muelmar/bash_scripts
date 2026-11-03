#!/bin/bash
pipe=$(mktemp -u)
wc -l /etc/services
mkfifo "$pipe"
cat /etc/services > "$pipe" &
wc -l < "$pipe"&
wc -l < "$pipe"&
wc -l < "$pipe"&
wait
rm "$pipe"
