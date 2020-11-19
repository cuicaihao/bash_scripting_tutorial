#!/bin/bash
# Experimenting with variable scope
var_change () {
    local var1='local CCC'
    echo Inside function: var1 is $var1 : var2 is $var2
    var1='local AAA'
    var2='DDD (Changed in var_change())'
}
var1='global AAA'
var2='global BBB'
echo Before function call: var1 is $var1 : var2 is $var2
var_change
echo After function call: var1 is $var1 : var2 is $var2