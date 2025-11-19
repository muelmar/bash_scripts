#!/bin/bash
#"ISBN";"Anzahl";"Titel";"publisher";"E-Preis";;
#Needs Einkauf_Kunde_book_store.csv and
#Kunde_*.csv all delivery notes
#in the current working directory
[[ -d tmp ]] || mkdir tmp
#first step is to remove ";" and other unwanted chars in Titel
gawk -F ';' 'BEGIN{print "isbn,Anzahl,Titel"}\
 /^"?[0-9]/ {outline="";
      printf "%s,%s,",$1,$2
      for (i = 3; i <= NF-4; i++)
        outline = outline $i
	gsub(/[^0-9A-Za-züöäÜÖÄ -]/, "",outline)
       print outline
}' Einkauf_Kunde_book_store.csv > tmp/Einkauf_bereinigt.csv
qsv cat rows --delimiter ';' Kunde_*csv |\
qsv enum --constant 1 --new-column Anzahl| \
qsv select isbn,Anzahl,Titel |\
qsv replace -u -s Titel '[^0-9a-zA-ZäöüÄÖÜß ]' '' |\
qsv replace -s isbn '[^0-9]' '' |\
qsv behead -o tmp/all_deliveries.csv
########
qsv select  --delimiter ';' ISBN,Anzahl,Titel Einkauf_Kunde_book_store.csv |\
qsv replace -s ISBN '[^0-9]' '' |\
qsv replace -s Titel ',' '' |\
qsv behead -o tmp/all_orders.csv
gawk -F ',' 'BEGIN{ x=0}\
      	{gsub(/[^0-9]/, "",$1);gsub(/[^0-9]/, "",$2);t[$1] += $2;\
		Titel[$1]=$3\
	}\
		END {print "Anzahl,isbn,Titel";\
		for (key in t) { print t[key] "," key "," Titel[key] }\
	}' tmp/all_deliveries.csv > tmp/all_deliveries_netted.csv
gawk -F ',' 'BEGIN{ x=0}\
      	{gsub(/[^0-9]/, "",$1);gsub(/[^0-9]/, "",$2);t[$1] += $2; \
		        Titel[$1]=$3\
        }\
		END {print "Anzahl,isbn,Titel";\
		for  (key in t) { print t[key] "," key "," Titel[key] }\
	}' tmp/all_orders.csv > tmp/all_orders_netted.csv 

qsv join --left-anti isbn tmp/all_deliveries_netted.csv isbn tmp/all_orders_netted.csv  -o left.csv
qsv join --right-anti isbn tmp/all_deliveries_netted.csv isbn tmp/all_orders_netted.csv  -o right.csv
