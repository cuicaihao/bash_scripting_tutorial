# If Statements! Decisions, decisions

## Introduction

Bash if statements are very useful. In this section of our Bash Scripting Tutorial you will learn the ways you may use if statements in your Bash scripts to help automate tasks.

If statements (and, closely related, case statements) allow us to make decisions in our Bash scripts. They allow us to decide whether or not to run a piece of code based upon conditions that we may set. If statements, combined with loops (which we'll look at in the next section) allow us to make much more complex scripts which may solve larger tasks.

Like what we have looked at in previous sections, their syntax is very specific so stay on top of all the little details.

## Basic If Statements

A basic if statement effectively says, if a particular test is true, then perform a given set of actions. If it is not true then don't perform those actions. If follows the format below:

```
if [ <some test> ]
then
<commands>
fi
```

Anything between **then** and **fi** (if backwards) will be executed only if the test (between the square brackets) is true.

Let's look at a simple example:

> if_example.sh

```bash
#!/bin/bash
# Basic if statement
if [ $1 -gt 100 ]
then
echo Hey that\'s a large number.
pwd
fi
date
```

Let's break it down:

- Let's see if the first command line argument is greater than 100
- Will only get run if the test on line 4 returns true. You can have as many commands here as you like.
- The backslash ( \ ) in front of the single quote ( ' ) is needed as the single quote has a special meaning for bash and we don't want that special meaning. The backslash escapes the special meaning to make it a normal plain single quote again.
- fi signals the end of the if statement. All commands after this will be run as normal.
- Because this command is outside the if statement it will be run regardless of the outcome of the if statement.

```
bash-3.2$ ./if_example.sh 15
Thu Nov 19 17:24:13 AEDT 2020
bash-3.2$ ./if_example.sh 150
Hey that's a large number.
/Users/caihaocui/Documents/GitHub/bash_scripting_tutorial/05_If_Statements
Thu Nov 19 17:24:17 AEDT 2020
bash-3.2$
```

> Tip
>
> It is always good practice to test your scripts with input that covers the different scenarios that are possible.

## Test

The square brackets ( [ ] ) in the if statement above are actually a reference to the command test.
This means that all of the operators that test allows may be used here as well. Look up the man page for test to see all of the possible operators (there are quite a few) but some of the more common ones are listed below.

|              Operator | Description                                                           |
| --------------------: | --------------------------------------------------------------------- |
|          ! EXPRESSION | The EXPRESSION is false.                                              |
|             -n STRING | The length of STRING is greater than zero.                            |
|             -z STRING | The length of STRING is zero (ie it is empty).                        |
|     STRING1 = STRING2 | STRING1 is equal to STRING2                                           |
|    STRING1 != STRING2 | STRING1 is not equal to STRING2                                       |
| INTEGER1 -eq INTEGER2 | INTEGER1 is numerically equal to INTEGER2                             |
| INTEGER1 -gt INTEGER2 | INTEGER1 is numerically greater than INTEGER2                         |
| INTEGER1 -lt INTEGER2 | INTEGER1 is numerically less than INTEGER2                            |
|               -d FILE | FILE exists and is a directory.                                       |
|               -e FILE | FILE exists.                                                          |
|               -r FILE | FILE exists and the read permission is granted.                       |
|               -s FILE | FILE exists and it's size is greater than zero (ie. it is not empty). |
|               -w FILE | FILE exists and the write permission is granted.                      |
|               -x FILE | FILE exists and the execute permission is granted.                    |

|

A few points to note:

- = is slightly different to **-eq**. [ 001 = 1 ] will return false as = does a string comparison (ie. character for character the same) whereas -eq does a numerical comparison meaning [ 001 -eq 1 ] will return true.
- When we refer to FILE above we are actually meaning a path. Remember that a path may be absolute or relative and may refer to a file or a directory.
- Because [ ] is just a reference to the command test we may experiment and trouble shoot with test on the command line to make sure our understanding of its behavior is correct.

```bash
bash-3.2$ test 001 = 1
bash-3.2$ echo $?
1
bash-3.2$ test 001 -eq 1
bash-3.2$ echo $?
0
bash-3.2$ touch myfile
bash-3.2$ test -s myfile
bash-3.2$ echo $?
1
bash-3.2$ ls /etc > myfile
bash-3.2$ test -s myfile
bash-3.2$ echo $?
0
bash-3.2$
```

Let's break it down:

- Perform a string based comparison. Test doesn't print the result so instead we check it's exit status which is what we will do on the next line.
- The variable \$? holds the exit status of the previously run command (in this case test). 0 means TRUE (or success). 1 = FALSE (or failure).
- This time we are performing a numerical comparison.
- Create a new blank file `myfile` (assuming that `myfile` doesn't already exist).
- Is the size of `myfile` greater than zero?
- Redirect some content into `myfile` so it's size is greater than zero.
- Test the size of `myfile` again. This time it is TRUE.

## Indenting

You'll notice that in the if statement above we indented the commands that were run if the statement was true.
This is referred to as indenting and is an important part of writing good, clean code (in any language, not just Bash scripts).
The aim is to improve readability and make it harder for us to make simple, silly mistakes. There aren't any rules regarding indenting in Bash so you may indent or not indent however you like and your scripts will still run exactly the same.
I would highly recommend you do indent your code however (especially as your scripts get larger) otherwise you will find it increasingly difficult to see the structure in your scripts.

## Nested If statements

Talking of indenting. Here's a perfect example of when it makes life easier for you. You may have as many if statements as necessary inside your script. It is also possible to have an if statement inside of another if statement. For example, we may want to analyze a number given on the command line like so:

> nested_if.sh

```bash
#!/bin/bash
# Nested if statements
if [ $1 -gt 100 ]
then
    echo Hey that\'s a large number.
    if (( $1 % 2 == 0 ))
    then
        echo And is also an even number.
    fi
fi
```

Let's break it down:

- Perform the following, only if the first command line argument is greater than 100.
- This is a light variation on the if statement. If we would like to check an expression then we may use the double brackets just like we did for variables.
- Only gets run if both if statements are true.

> Tip
> You can nest as many if statements as you like but as a general rule of thumb if you need to nest more than 3 levels deep you should probably have a think about reorganizing your logic.

## If Else

Sometimes we want to perform a certain set of actions if a statement is true, and another set of actions if it is false. We can accommodate this with the else mechanism.

```
if [ <some test> ]
then
<commands>
else
<other commands>
fi
```

Now we could easily read from a file if it is supplied as a command line argument, else read from STDIN.

```bash
#!/bin/bash
# else example
if [ $# -eq 1 ]
then
    nl $1
else
    nl /dev/stdin
fi
```

## If Elif Else

Sometimes we may have a series of conditions that may lead to different paths.

```
if [ <some test> ]
then
  <commands>
elif [ <some test> ]
then
  <different commands>
else
 <other commands>
fi
```

For example it may be the case that if you are 18 or over you may go to the party. If you aren't but you have a letter from your parents you may go but must be back before midnight. Otherwise you cannot go.

```bash
#!/bin/bash
# elif statements
if [ $1 -ge 18 ]
then
echo You may go to the party.
elif [ $2 == 'yes' ]
then
echo You may go to the party but be back before midnight.
else
echo You may not go to the party.
fi
```

You can have as many elif branches as you like. The final else is also optional.

```bash
bash-3.2$ ./if_elif.sh 20
You may go to the party.

bash-3.2$ ./if_elif.sh 10 yes
You may go to the party but be back before midnight.

bash-3.2$
```

## Boolean Operations

Sometimes we only want to do something if multiple conditions are met. Other times we would like to perform the action if one of several condition is met. We can accommodate these with boolean operators.

- and - &&
- or - ||

For instance maybe we only want to perform an operation if the file is readable and has a size greater than zero.

```bash
#!/bin/bash
# and example: add.sh
if [ -r $1 ] && [ -s $1 ]
then
echo This file is useful.
fi
```

Maybe we would like to perform something slightly different if the user is either bob or andy.

```bash
#!/bin/bash
# or example: or.sh
if [ $USER == 'bob' ] || [ $USER == 'andy' ]
then
ls -alh
else
ls
fi
```

```
bash-3.2$ ./and.sh myfile
This file is useful.

bash-3.2$ ./or.sh myfile
total 80
drwxr-xr-x@ 10 caihaocui  staff   320B Nov 19 18:01 .
drwxr-xr-x@ 11 caihaocui  staff   352B Nov 19 18:01 ..
-rw-r--r--   1 caihaocui  staff   9.2K Nov 19 17:59 If_Statements.md
-rwxr-xr-x   1 caihaocui  staff    85B Nov 19 17:58 and.sh
-rwxr-xr-x   1 caihaocui  staff    75B Nov 19 17:49 else.sh
-rwxr-xr-x   1 caihaocui  staff   215B Nov 19 17:56 if_elif.sh
-rwxr-xr-x   1 caihaocui  staff   100B Nov 19 17:21 if_example.sh
-rw-r--r--   1 caihaocui  staff   840B Nov 19 17:35 myfile
-rwxr-xr-x   1 caihaocui  staff   179B Nov 19 17:40 nested_if.sh
-rwxr-xr-x   1 caihaocui  staff    91B Nov 19 18:01 or.sh
bash-3.2$
```

## Case Statements

Sometimes we may wish to take different paths based upon a variable matching a series of patterns.
We could use a series of if and elif statements but that would soon grow to be unwieldily.
Fortunately there is a case statement which can make things cleaner. It's a little hard to explain so here are some examples to illustrate:

```
case <variable> in
<pattern 1>)
    <commands>
    ;;
<pattern 2>)
    <other commands>
    ;;
esac
```

Here is a basic example:

```bash
#!/bin/bash
# case example
case $1 in
start)
echo starting
;;
stop)
echo stoping
;;
restart)
echo restarting
;;
*)
echo don\'t know
;;
esac
```

Let's break it down:

- This line begins the case-mechanism.
- If \$1 is equal to 'start' then perform the subsequent actions. the ) signifies the end of the pattern.
- We identify the end of this set of statements with a double semi-colon ( ;; ). Following this is the next case to consider.
- Remember that the test for each case is a pattern. The \* represents any number of any character. It is essentially a catch all if for if none of the other cases match. It is not necessary but is often used.
- esac is case backwards and indicates we are at the end of the case statement. Any other statements after this will be executed normally.

```
bash-3.2$ ./case.sh start
starting

bash-3.2$ ./case.sh stop
stoping

bash-3.2$ ./case.sh restart
restarting

bash-3.2$ ./case.sh lalala
don't know
bash-3.2$
```

Now let's look at a slightly more complex example where patterns are used a bit more.

```bash
#!/bin/bash
# Print a message about disk useage.
# disk_useage.sh
space_free=$( df -h | awk '{ print $5 }' | sort -n | tail -n 1 | sed 's/%//' )
case $space_free in
[1-5]*)
echo Plenty of disk space available
;;
[6-7]*)
echo There could be a problem in the near future
;;
8*)
echo Maybe we should look at clearing out old files
;;
9*)
echo We could have a serious problem on our hands soon
;;
*)
echo Something is not quite right here
;;
esac
```

## Summary

> Stuff we learnt

- if
  Perform a set of commands if a test is true.
- else
  If the test is not true then perform a different set of commands.
- elif
  If the previous test returned false then try this one.
- &&
  Perform the and operation.
- ||
  Perform the or operation.
- case
  Choose a set of commands to execute depending on a string matching a particular pattern.

> Important Concepts

- Indenting:
  Indenting makes your code much easier to read. It get's increasingly important as your Bash scripts get longer.
- Planning:
  Now that your scripts are getting a little more complex you will probably want to spend a little bit of time thinking about how you structure them before diving in.

## Activities

Now let's make some decisions.

- Create a Bash script which will take 2 numbers as command line arguments. It will print to the screen the larger of the two numbers.
- Create a Bash script which will accept a file as a command line argument and analyze it in certain ways. eg. you could check if the file is executable or writable. You should print a certain message if true and another if false.
- Create a Bash script which will print a message based upon which day of the week it is (eg. 'Happy hump day' for Wednesday, 'TGIF' for Friday etc).
