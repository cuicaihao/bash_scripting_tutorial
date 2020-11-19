#!/bin/bash
# Generate random number between min and max
 

range=$(($2 - $1 + 1 ))
a=$RANDOM
echo $(( $a % range + $1 ))