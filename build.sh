#!/bin/bash

bison -d LGLO.y && flex LGLO.l && gcc -o compilateur LGLO.tab.c lex.yy.c
