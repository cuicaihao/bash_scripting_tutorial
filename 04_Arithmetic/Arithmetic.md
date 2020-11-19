# Arithmetic: It all adds up

## Introduction

Depending on what type of work you want your scripts to do you may end up using arithmetic a lot or not much at all. It's a reasonable certainty however that you will need to use arithmetic at some point. Like variables, they are reasonably easy to implement and knowing how to do so is an essential skill in Bash scripting mastery.

There are several ways to go about arithmetic in Bash scripting. We'll cover them for completeness but the recommended approach is arithmetic expansion (covered last).

## Let

let is a builtin function of Bash that allows us to do simple arithmetic. It follows the basic format:

> let \<arithmetic expression\>

The arithmetic expression can take a variety of formats which we'll outline below. The first part is generally always a variable which the result is saved into however.

Let's look at a simple example:

> let_example.sh

```bash
#!/bin/bash
# Basic arithmetic using let
let a=5+4
echo $a # 9
let "a = 5 + 4"
echo $a # 9
let a++
echo $a # 10
let "a = 4 * 5"
echo $a # 20
let "a = $1 + 30"
echo $a # 30 + first command line argument
```

Let's break it down:

- This is the basic format. Note that if we don't put quotes around the expression then it must be written with no spaces.
- This time we have used quotes which allow us to space out the expression to make it more readable.
- This is a shorthand for increment the value of the variable a by 1. It is the same as writing "a = a + 1".
- We may also include other variables in the expression.

```bash
bash-3.2$ ./let_example.sh
9
9
10
20
30
bash-3.2$
```

Here is a table with some of the basic expressions you may perform. There are others but these are the most commonly used.
| Operator | Operation |
|------------: |----------------------------------------------- |
| +, -, \*, / | addition, subtraction, multiply, divide |
| var++ | Increase the variable var by 1 |
| var-- | Decrease the variable var by 1 |
| % | Modulus (Return the remainder after division) |

These operators may be used in the other mechanisms described below as well.

## Expr

expr is similar to let except instead of saving the result to a variable it instead prints the answer.
Unlike let you don't need to enclose the expression in quotes. You also must have spaces between the items of the expression. It is also common to use expr within command substitution to save the output to a variable.

> expr item1 operator item2

Let's look at a simple example:

> expr_example.sh

```bash
#!/bin/bash
# Basic arithmetic using expr
expr 5 + 4
expr "5 + 4"
expr 5+4
expr 5 \* $1
expr 11 % 2
a=$( expr 10 - 3 )
echo $a # 7
```

Let's break it down:

- This is the basic format. Note that there must be spaces between the items and no quotes.
- If we do put quotes around the expression then the expression will not be evaluated but printed instead.
- If we do not put spaces between the items of the expression then the expression will not be evaluated but printed instead.
- Some characters have a special meaning to Bash so we must escape them (put a backslash in front of) to remove their special meaning.
- Here we demonstrate the operator modulus. The modulus is the remainder when the first item is divided by the second item.
- This time we're using expr within command substitution in order to save the result to the variab

```bash
bash-3.2$ ./expr_example.sh
9
5 + 4
5+4
expr: syntax error # this one need fix
1
7
bash-3.2$
```

## Double Parentheses

In the section on Variables we saw that we could save the output of a command easily to a variable. It turns out that this mechanism is also able to do basic arithmetic for us if we tweak the syntax a little. We do so by using double brackets like so:

> ((expression))

Here's an example to illustrate:

> expansion_example.sh

```bash
#!/bin/bash
# Basic arithmetic using double parentheses
a=$(( 4 + 5 ))
echo $a # 9
a=$((3+5))
echo $a # 8
b=$(( a + 3 ))
echo $b # 11
b=$(( $a + 4 ))
echo $b # 12
(( b++ ))
echo $b # 13
(( b += 3 ))
echo $b # 16
a=$(( 4 * 5 ))
echo $a # 20
```

Let's break it down:

- This is the basic format. As you can see we may space it out nicely for readability without the need for quotes.
- As you can see, it works just the same if we take spacing out.
- We may include variables without the preceding \$ sign.
- Variables can be included with the \$ sign if you prefer.
- This is a slightly different form. Here the value of the variable b is incremented by 1 (using the same mechanism illustrated under let). When we do this we don't need the \$ sign preceding the brackets.
- This is a slightly different form of the previous example. Here the value of the variable b is incremented by 3. It is a shorthand for b = b + 3.
- Unlike other methods, when we do multiplication we don't need to escape the \* sign.

```bash
bash-3.2$ ./expansion_example.sh
9
8
11
12
13
16
20
bash-3.2$
```

So as you can see double parenthese is quite flexible in how you format it's expression. This is part of why we prefer this method.

As double parentheses is builtin to Bash it also runs slighly more efficiently (though to be honest, with the raw computing power of machines these days the difference in performance is really insignificant).

## Length of a Variable

This isn't really arithmetic but it can be quite useful. If you want to find out the lengh of a variable (how many characters) you can do the following:

> \$(#variable)

Here's an example:

> length_example.sh

```bash
#!/bin/bash
# Show the length of a variable.
a='Hello World'
echo ${#a} # 11
b=4953
echo ${#b} # 4
```

```bash
bash-3.2$ ./length_example.sh
11
4
bash-3.2$
```

## Summary

> Stuff We Learnt

- **let expression**
  Make a variable equal to an expression.
- **expr expression**
  print out the result of the expression.
- **\$(( expression ))**
  Return the result of the expression.
- **\${#var}**
  Return the length of the variable var.

> Important Concepts

- **Arithmetic**
  There are several ways in which to do arithmetic in Bash scripts. Double parentheses is the preferred method.
- **Formatting**
  When doing arithmetic, the presence or absence of spaces (and quotes) is often important.

## Activities

Let's dive in with arithmetic.

- Create a simple script which will take two command line arguments and then multiply them together using each of the methods detailed above.
- Write a Bash script which will print tomorrows date. (Hint: use the command date)
- Remember when we looked at variables we discovered `\$RANDOM` will return a random number. This number is between 0 and 32767 which is not always the most useful. Let's write a script which will use this variable and some arithmetic (hint: play with modulus) to return a random number between 0 and 100.
- Now let's play with the previous script. Modify it so that you can specify as a command line argument the upper limit of the random number. Can you make it so that a lower limit can be specified also? eg. if I ran `./random.sh` 10 45 it would only return random numbers between 10 and 45.
