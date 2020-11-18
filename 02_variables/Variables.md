# Variables: Temporary stores of information

## Introduction

For those of you that have dabbled in programming before, you'll be quite familiar with variables. For those of you that haven't, think of a variable as a temporary store for a simple piece of information.
These variables can be very useful for allowing us to manage and control the actions of our Bash Script.
We'll go through a variety of different ways that variables have their data set and ways we can then use them.

Variables are one of those things that are actually quite easy to use but are also quite easy to get yourself into trouble with if you don't properly understand how they work. As such there is a bit of reading in this section but if you take the time to go through and understand it you will be thankful you did later on when we start dabbling in more complex scripts.

## How do they Work

A variable is a temporary store for a piece of information. There are two actions we may perform for variables:

- Setting a value for a variable.
- Reading the value for a variable.

Variables may have their value set in a few different ways. The most common are to set the value directly and for its value to be set as the result of processing by a command or program. You will see examples of both below.

To read the variable we then place its name (preceded by a `$` sign) anywhere in the script we would like. Before Bash interprets (or runs) every line of our script it first checks to see if any variable names are present. For every variable it has identified, it replaces the variable name with its value. Then it runs that line of code and begins the process again on the next line.

Here are a few quick points on syntax. They will be elaborated on and demonstrated as we go into more detail below.

- When referring to or reading a variable we place a \$ sign before the variable name.
- When setting a variable we leave out the \$ sign.
- Some people like to always write variable names in uppercase so they stand out. It's your preference however. They can be all uppercase, all lowercase, or a mixture.
- A variable may be placed anywhere in a script (or on the command line for that matter) and, when run, Bash will replace it with the value of the variable. This is made possible as the substitution is done before the command is run.

## Command line arguments

Command line arguments are commonly used and easy to work with so they are a good place to start.

When we run a program on the command line you would be familiar with supplying arguments after it to control its behaviour. For instance we could run the command `ls -l /etc`. `-l` and `/etc` are both command line arguments to the command ls.

We can do similar with our bash scripts. To do this we use the variables `$1` to represent the first command line argument, `$2` to represent the second command line argument and so on. These are automatically set by the system when we run our script so all we need to do is refer to them.

Let's look at an example.

```bash
#!/bin/bash
# A simple copy script
cp $1 $2 # run the command cp with the first command line argument as the source and the second command line argument as the destination.
# Let's verify the copy worked
echo Details for $2 # run the command echo to print a message.
ls -lh $2 #After the copy has completed, run the command ls for the destination just to verify it worked. We have included the options `l` to show us extra information and `h` to make the size human readable so we may verify it copied correctly.
```

```bash
bash-3.2$ cat mycopy.sh
#!/bin/bash
# A simple copy script
cp $1 $2
# Let's verify the copy worked
echo Details for $2

bash-3.2$ chmod +x mycopy.sh # change file type
bash-3.2$ rm results.data; touch results.data # clean and create an empty file
bash-3.2$ cat results.data

# run bash scripts copy data from source to destination
bash-3.2$ ./mycopy.sh ./projects/file1.data ./results.data
Details for ./results.data
-rw-r--r--  1 caihaocui  staff    29B Nov 18 12:04 ./results.data
bash-3.2$ cat results.data # check the new data from projects/file1.data
year, month, day
2020, 11, 20
2019, 12, 31
```

We'll discuss their usage a little more in the next section ( 3. Input ).

## Other Special Variables

There are a few other variables that the system sets for you to use as well.

- \$0 - The name of the Bash script.
- \$1 - \$9 - The first 9 arguments to the Bash script. (As mentioned above.)
- \$# - How many arguments were passed to the Bash script.
- \$@ - All the arguments supplied to the Bash script.
- \$? - The exit status of the most recently run process.
- \$\$ - The process ID of the current script.
- \$USER - The username of the user running the script.
- \$HOSTNAME - The hostname of the machine the script is running on.
- \$SECONDS - The number of seconds since the script was started.
- \$RANDOM - Returns a different random number each time is it referred to.
- \$LINENO - Returns the current line number in the Bash script.

> **TIP**
>
> If you type the command env on the command line you will see a listing of other variables which you may also refer to.

Some of these variables may seem useful to you now. Others may not. As we progress to more complex scripts in later sections you will see examples of how they can be useful.

## Setting Our Own Variables

As well as variables that are preset by the system, we may also set our own variables. This can be useful for keeping track of results of commands and being able to refer to and process them later.

There are a few ways in which variables may be set (such as part of the execution of a command) but the basic form follows this pattern:

> variable=value

This is one of those areas where formatting is important.

**Note there is no space on either side of the equals ( = ) sign.**

We also leave off the \$ sign from the beginning of the variable name when setting it.

Variable names may be uppercase or lowercase or a mixture of both but Bash is a case sensitive environment so whenever you refer to a variable you must be consistent in your use of uppercase and lowercase letters. You should always make sure variable names are descriptive. This makes their purpose easier for you to remember.

Here is a simple example to illustrate their usage.

```bash
#!/bin/bash
# A simple variable example
myvariable=Hello
anothervar=Fred
echo $myvariable $anothervar
echo
sampledir=/etc
ls $sampledir
```

Let's break it down:

- set the value of the two variables `myvariable` and `anothervar`.
- run the command echo to check the variables have been set as intended.
- run the command echo this time with no arguments. This is a good way to get a blank line on the screen to help space things out.
- set another variable, this time as the path to a particular directory.
- run the command ls substituting the value of the variable sampledir as its first command line argument.

```bash
# remember: chmod +x simplevariables.sh
bash-3.2$ ./simplevariables.sh
Hello Fred

afpovertcp.cfg
...
...
```

It is important to note that in the example above we used the command echo simply because it is a convenient way to demonstrate that the variables have actually been set. echo is not needed to make use of variables and is only used when you wish to print a specific message to the screen. (Pretty much all commands print output to the screen as default so you don't need to put echo in front of them.)

> Best Practice
>
> Variables can be useful for making our scripts easier to manage. Maybe our script is going to run several commands, several of which will refer to a particular directory. Rather than type that directory out each time we can set it once in a variable then refer to that variable. Then if the required directory changes in the future we only need to update one variable rather than every instance within the script.

## Quotes

In the example above we kept things nice and simple. The variables only had to store a single word. When we want variables store more complex values however, we need to make sure of quotes. This is because under normal circumstances **Bash uses a space to determine separate items**.

```bash
bash-3.2$ myvar=Hello World
bash: World: command not found
bash-3.2$
```

- Remember, commands work exactly the same on the command line as they do within a script.

> **Tip**
>
> Because commands work exactly the same on the command line as in a script it can sometimes be easier to experiment on the command line.

When we enclose our content in quotes we are indicating to Bash that the contents should be considered as a single item. You may use single quotes (') or double (").

- Single quotes will treat every character literally.
- Double quotes will allow you to do substitution (that is include variables within the setting of the values).

```bash
bash-3.2$ myvar='Hello World'
bash-3.2$ echo $myvar
Hello World

bash-3.2$ newvar="More $myvar"
bash-3.2$ echo $newvar
More Hello World

bash-3.2$ newvar2='More $myvar'
bash-3.2$ echo $newvar2
More $myvar
bash-3.2$

```

## Command Substitution

Command substitution allows us to take the output of a command or program (what would normally be printed to the screen) and save it as the value of a variable. To do this we place it within brackets, preceded by a \$ sign.

```bash
bash-3.2$ myvar=$( ls /etc | wc -l )
bash-3.2$ echo There are $myvar entries in the directory /etc
There are 83 entries in the directory /etc
bash-3.2$
```

Command substitution is nice and simple if the output of the command is a single word or line. If the output goes over several lines then the newlines are simply removed and all the output ends up on a single line.

```bash
bash-3.2$ myvar=$( ls )
bash-3.2$ echo $myvar
Variables.md mycopy.sh projects results.data simplevariables.sh
bash-3.2$
```

Let's break it down:

- We run the command ls. Normally its output would be over several lines. I have shortened it a bit in the example above just to save space.
- When we save the command to the variable `myvar` all the newlines are stripped out and the output is now all on a single line.

> **TIP**
>
> When playing about with command substitution it's a good idea to test your output rather than just assuming it will behave in a certain way. The easiest way to do that is simply to echo the variable and see what has happened. (You can then remove the echo command once you are happy.)

## Exporting Variables

Remember how in the previous section we talked about scripts being run in their own process? This introduces a phenomenon known as scope which affects variables amongst other things. The idea is that variables are limited to the process they were created in.

Normally this isn't an issue but sometimes, for instance, a script may run another script as one of its commands. If we want the variable to be available to the second script then we need to export the variable.

> script1.sh

```bash
#!/bin/bash
# demonstrate variable scope 1.
var1=AAA
var2=BBB
# Let's verify their current value
echo $0 :: var1 : $var1, var2 : $var2
export var1
./script2.sh
# Let's see what they are now
echo $0 :: var1 : $var1, var2 : $var2
```

> script2.sh

```bash
#!/bin/bash
# demonstrate variable scope 2
# Let's verify their current value
echo $0 :: var1 : $var1, var2 : $var2
# Let's change their values
var1=CCC
var2=DDD
# Let's verify their current value
echo $0 :: var1 : $var1, var2 : $var2

```

Now lets run it and see what happens.

```bash
bash-3.2$ ./script1.sh
./script1.sh :: var1 : AAA, var2 : BBB
./script2.sh :: var1 : AAA, var2 :
./script2.sh :: var1 : CCC, var2 : DDD
./script1.sh :: var1 : AAA, var2 : BBB
bash-3.2$

```

The output above may seem unexpected. What actually happens when we export a variable is that we are telling Bash that every time a new process is created (to run another script or such) then make a copy of the variable and hand it over to the new process. So although the variables will have the same name they exist in separate processes and so are unrelated to each other.

Exporting variables is a one way process. The original process may pass variables over to the new process but anything that process does with the copy of the variables has no impact on the original variables.

Exporting variables is something you probably won't need to worry about for most Bash scripts you'll create. Sometimes you may wish to break a particular task down into several separate scripts however to make it easier to manage or to allow for reusability (which is always good).

For instance you could create a script which will make a dated (ie todays date pretended to the filename) copy of all filenames exported on a certain variable. Then you could easily call that script from within other scripts you create whenever you would like to take a snapshot of a set of files.

## Summary

> Stuff We Learnt

- $1, $2, ...
  The first, second, etc command line arguments to the script.
- variable=value
  To set a value for a variable. Remember, no spaces on either side of =
- Quotes " '
  Double will do variable substitution, single will not.
- variable=\$( command )
  Save the output of a command into a variable
- export var1
  Make the variable var1 available to child processes.

> Important Concept

- Formatting
  The presence or absence of spaces is important.
- Manageability
  If a particular value is used several times within a script (eg a file or directory name) then using a variable can make it easier to manage.

## Activities

Let's explore variables.

- A good place to start is to create a simple script which will accept some command line arguments and echo out some details about them (eg, how many are there, what is the second one etc).
- Create a script which will print a random word. There is a file containing a list of words on your system (usually /usr/share/dict/words or /usr/dict/words). Hint: [`Piping`](https://ryanstutorials.net/linuxtutorial/piping.php#piping) will be useful here.
- Expand the previous activity so that if a number is supplied as the first command line argument then it will select from only words with that many characters. Hint: [`Grep`](https://ryanstutorials.net/linuxtutorial/grep.php) may be useful here.
- Take a copy of the two files script1.sh and script2.sh above then experiment by tweaking them and running them and observing the output. This will help you get a feel for how exporting variables works.
- Now let's create a script which will take a filename as its first argument and create a dated copy of the file. eg. if our file was named file1.txt it would create a copy such as 2020-11-17_file1.txt. (To achieve this you will probably want to play with command substitution and the command [`date`](https://www.geeksforgeeks.org/date-command-linux-examples/#:~:text=date%20command%20is%20used%20to,change%20the%20date%20and%20time.))
- Challenge: To make it a bit harder, see if you can get it so that the date is after the name of the file (eg. file1_2020-11-17.txt (The command [`basename`](https://www.geeksforgeeks.org/basename-command-in-linux-with-examples/) can be useful here.)
- Challenge: Now see if you can expand the previous question to accept a list of files on the command line and it will create a named copy of all of them. (The command [`xargs`](https://ryanstutorials.net/linuxtutorial/bonus.php#xargs) may be useful here.)
