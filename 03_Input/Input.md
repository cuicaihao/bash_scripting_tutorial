# User Input : Let's make our scripts interactive

## Introduction

We looked at one form of user input ([command line arguments](02_variables/Variables.md)) in the previous section. Now we would like to introduce other ways the user may provide input to the Bash script. Following this we'll have a discussion on when and where is best to use each method.

After the mammoth previous section this one is much easier to get through.

## Ask the User for Input

If we would like to ask the user for input then we use a command called `read`. This command takes the input and will save it into a variable.

> read var1

Let's look at a simple example:

> introduction.sh

```bash
#!/bin/bash
# Ask the user for their name
echo Hello, who am I talking to?
read varname
echo It\'s nice to meet you $varname
```

Let's break it down:

- Print a message asking the user for input.
- Run the command `read` and save the users response into the variable `varname`
- echo another message just to verify the read command worked. Note: I had to put a backslash ( `\` ) in front of the `'` so that it was escaped.

```bash
bash-3.2$ ./introduction.sh
Hello, who am I talking to?
chris cui
It's nice to meet you chris cui
bash-3.2$
```

## More with Read

You are able to alter the behavior of read with a variety of command line options. (See the man page for read to see all of them.)

Two commonly used options however are `-p` which allows you to specify a prompt and `-s` which makes the input silent. This can make it easy to ask for a `username` and `password` combination like the example below:

> login.sh

```bash
#!/bin/bash
# Ask the user for login details
read -p 'Username: ' uservar
read -sp 'Password: ' passvar
echo
echo Thankyou $uservar we now have your login details
```

we include the prompt within quotes so we can have a space included with it. Otherwise the user input will start straight after the last character of the prompt which isn't ideal from a readability point of view.

```bash
bash-3.2$ ./login.sh
Username: Chris Cui
Password:
Thankyou Chris Cui we now have your login details
bash-3.2$
```

## More variables

So far we have looked at a single word as input. We can do more than that however.

> cars.sh

```bash
#!/bin/bash
# Demonstrate how read actually works
echo What cars do you like?
read car1 car2 car3
echo Your first car was: $car1
echo Your second car was: $car2
echo Your third car was: $car3
```

```bash
bash-3.2$ ./cars.sh
What cars do you like?
Jaguar Maserati Bentley
Your first car was: Jaguar
Your second car was: Maserati
Your third car was: Bentley
bash-3.2$ ./cars.sh
What cars do you like?
Jaguar Maserati Bently Lotus
Your first car was: Jaguar
Your second car was: Maserati
Your third car was: Bently Lotus
bash-3.2$
```

The general mechanism is that you can supply several variable names to read. Read will then take your input and split it on whitespace (` `).

The first item will then be assigned to the first variable name, the second item to the second variable name and so on. If there are more items than variable names then the remaining items will all be added to the last variable name. If there are less items than variable names then the remaining variable names will be set to `blank` or `null`.

## Reading from STDIN

It's common in Linux to pipe a series of simple, single purpose commands together to create a larger solution tailored to our exact needs. The ability to do this is one of the real strengths of Linux.
It turns out that we can easily accommodate this mechanism with our scripts also. By doing so we can create scripts that act as filters to modify data in specific ways for us.

Bash accommodates piping and redirection by way of special files. Each process gets it's own set of files (one for STDIN, STDOUT and STDERR respectively) and they are linked when piping or redirection is invoked. Each process gets the following files:

- STDIN - /proc/<processID>/fd/0
- STDOUT - /proc/<processID>/fd/1
- STDERR - /proc/<processID>/fd/2

To make life more convenient the system creates some shortcuts for us:

- STDIN - /dev/stdin or /proc/self/fd/0
- STDOUT - /dev/stdout or /proc/self/fd/1
- STDERR - /dev/stderr or /proc/self/fd/2

`fd` in the paths above stands for file descriptor.

So if we would like to make our script able to process data that is piped to it all we need to do is read the relevant file. All of the files mentioned above behave like normal files.

> summary.sh

```bash
#!/bin/bash
# A basic summary of my sales report
echo Here is a summary of the sales data:
echo ====================================
echo
cat /dev/stdin | cut -d' ' -f 2,3 | sort
```

Let's break it down:

- Print a title for the output
- cat the file representing STDIN, cut setting the delimiter to a space, fields 2 and 3 then sort the output.

```bash
# check the data file.
bash-3.2$ cat salesdata.txt
Fred apples 20 November 4
Susy oranges 5 November 7
Mark watermelons 12 November 10
Terry peaches 7

# run summary.sh with data input.
bash-3.2$ cat salesdata.txt | ./summary.sh
Here is a summary of the sales data:
====================================

apples 20
oranges 5
peaches 7
watermelons 12
bash-3.2$

```

## So which should I use?

So we now have 3 methods for getting input from the user:

- Command line arguments
- Read input during script execution
- Accept data that has been redirected into the Bash script via STDIN

Which method is best depends on the situation.

You should normally favor command line arguments wherever possible. They are the most convenient for users as the data will be stored in their command history so they can easily return to it. It is also the best approach if your script may be called by other scripts or processes (eg. maybe you want it to run periodically using CRON).

Sometimes the nature of the data is such that it would not be ideal for it to be stored in peoples command histories etc.
A good example of this is login credentials (username and password). In these circumstances it is best to read the data during script execution.

If all the script is doing is processing data in a certain way then it is probably best to work with STDIN. This way it can easily be added into a pipeline.

Sometimes you may find that a combination is ideal. The user may supply a filename as a command line argument and if not then the script will process what it finds on STDIN (when we look at If statements we'll see how this may be achieved). Or maybe command line arguments define certain behavior but read is also used to ask for more information if required.

Ultimately you should think about 3 factors when deciding how users will supply data to your Bash script:

- **Ease of use** - which of these methods will make it easiest for users to use my script?
- **Security** - Is there sensitive data which I should handle appropriately?
- **Robustness** - Can I make it so that my scripts operation is intuitive and flexible and also make it harder to make simple mistakes?

## Summary

> Stuff we learnt

- **read varName**
  Read input from the user and store it in the variable varName.
- **/dev/stdin**
  A file you can read to get the STDIN for the Bash script

> Important Concepts

- **Usability**
  Your choice of input methods will have an impact on how useable your script is.

## Activities

Let's dabble with input.

- Create a simple script which will ask the user for a few pieces of information then combine this into a message which is echo'd to the screen.
- Add to the previous script to add in some data coming from command line arguments and maybe some of the other system variables.
- Create a script which will take data from STDIN and print the 3rd line only.
- Now play about with creating a script which will behave as a filter. Create a script which will rearrange the output of the command `ls -l` in a useful way (eg maybe you only print the filename, size and owner) (Hint: [awk](https://ryanstutorials.net/linuxtutorial/bonus.php#awk) can be useful here).
