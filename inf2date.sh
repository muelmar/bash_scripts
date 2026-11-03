#!/bin/bash
for f in ~/Desktop/*inf; do
	echo "$f"
	datum=$(grep -E -m1 -e Date <(tr -d '\r' < "$f")  | sed 's/Date=//')
	printf "%s\n" ${datum} 
	printf "%s.%s.%s  %s:%s\n" ${datum:6:2} ${datum:4:2} ${datum:0:4} ${datum:8:2} ${datum:10:2}
done
