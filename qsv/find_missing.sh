#!/bin/bash
#Needs Einkauf_Kunde_book_store.csv and
#Kunde_*.csv all delivery notes
#in te current working directory
qsv cat rows --delimiter ';' Kunde_*csv |\
qsv enum --constant 1 --new-column Anzahl| \
qsv select isbn,Anzahl,Titel |\
qsv behead -o all_deliveries.csv
########
qsv select --delimiter ';' ISBN,Anzahl,Titel Einkauf_Kunde_book_store.csv |\
qsv behead -o all_orders.csv
gawk -F ',' 'BEGIN{ x=0}\
      	{gsub(/[^0-9]/, "",$1);gsub(/[^0-9]/, "",$2);t[$1] += $2;\
		Titel[$1]=$3\
	}\
		END {print "Anzahl,isbn,Titel";\
		for (key in t) { print t[key] "," key "," Titel[key] }\
	}' all_deliveries.csv > all_deliveries_netted.csv
gawk -F ',' 'BEGIN{ x=0}\
      	{gsub(/[^0-9]/, "",$1);gsub(/[^0-9]/, "",$2);t[$1] += $2; \
		        Titel[$1]=$3\
        }\
		END {print "Anzahl,isbn,Titel";\
		for  (key in t) { print t[key] "," key "," Titel[key] }\
	}' all_orders.csv > all_orders_netted.csv 


