#!/bin/bash
# Generate random number between 0 and 100

a=$RANDOM
echo $(( $a % 100 ))