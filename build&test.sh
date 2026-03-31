#!/bin/bash

bison -d LGLO.y && flex LGLO.l && gcc -o compilateur LGLO.tab.c lex.yy.c
repertoire=$1
echo " "
for fichier in "$repertoire"/*; do
	if [ -f "$fichier" ]; then
		echo "Test du fichier : $fichier ..."
		echo " "
		cat $fichier | ./compilateur
		echo " "
	fi
done
