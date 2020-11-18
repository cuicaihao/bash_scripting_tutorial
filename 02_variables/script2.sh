#!/bin/bash
# demonstrate variable scope 2
# Let's verify their current value
echo $0 :: var1 : $var1, var2 : $var2
# Let's change their values
var1=CCC
var2=DDD
# Let's verify their current value
echo $0 :: var1 : $var1, var2 : $var2