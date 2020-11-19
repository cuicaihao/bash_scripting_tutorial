#!/bin/bash
# Basic arithmetic using expr
expr 5 + 4

expr "5 + 4"

expr 5+4

expr 5 \* $1

expr 11 % 2

a=$( expr 10 - 3 )

echo $a # 7