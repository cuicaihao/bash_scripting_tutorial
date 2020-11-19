# User Interface!

Beauty is more than skin deep.

## Introduction

This is the final section in the tutorial and I'd like to use it to discuss a very important topic (which is often neglected) the user interface. I've touched on various points regarding the user interface throughout the tutorial but here I'll bring them all together and introduce a few other concepts as well.

When most people think about the user interface they think about the bits the end user sees and how they interact with the tool. For Bash scripts I like to think about the layout and structure of the commands inside the script as well. Bash scripts are often small tools used to automate tedious and repetitive tasks. They are always readable by the end user and often modified to suit changing requirements. Therefore the ease with which the user (often yourself) may modify and extend the script is also very important.

## TPut

**tput** is a command which allows you to control the cursor on the terminal and the format of content that is printed. It is quite a powerful and complex tool so I'll introduce some of the basics here but leave it up to you to do further research.

Here is an example printing a message in the center of the screen.

> center_message.sh

```bash
#!/bin/bash
# Print message in center of terminal

cols=$( tput cols )
rows=$( tput lines )

message=$@

input_length=${#message}

half_input_length=$(( $input_length / 2 ))

middle_row=$(( $rows / 2 ))
middle_col=$(( ($cols / 2) - $half_input_length ))

tput clear

tput cup $middle_row $middle_col
tput bold
echo $@
tput sgr0
tput cup $( tput lines ) 0
```

Let's break it down:

- Line 4 - tput cols will tell us how many columns the terminal has.
- Line 5 - tput lines will tell us how many lines (or rows) the terminal has.
- Line 7 - Take all the command line arguments and assign them to a single variable message.
- Line 9 - Find out how many characters are in the string message. We had to assign all the input values to the variable message first as \${#@} would tell us how many command line arguments there were instead of the number of characters combined.
- Line 11 - We need to know what 1/2 the length of the string message is in order to center it.
- Lines 13 and 14 - Calculate where to place the message for it to be centered.
- Line 16 - tput clear will clear the terminal.
- Line 18 - tput cup will place the cursor at the given row and column.
- Line 19 - tput bold will make everything printed to the screen bold.
- Line 20 - Now we have everything set up let's print our message.
- Line 21 - tput sgr0 will turn bold off (and any other changes we may have made).
- Line 22 - Place the prompt at the bottom of the screen.

```
bash-3.2$ ./center_message.sh Hello Bash

                                Hello Bash

bash-3.2$
```

**Note**: Normally the first prompt (where we run the script) would be removed with the clear command. We have left it here only so you can see that it was run to get the script started.

With `tput` and a bit of creativity you can create some really interesting effects. Especially so if you delay actions using the command `sleep`.
Only use it when appropriate however. Most of the time just printing the processed data (without formatting) is more convenient for the user.

## Supplying Data

Remember there are 3 ways in which you may supply data to a Bash script:

- As command line arguments
- Redirected in as STDIN
- Read interactively during script execution

Your script may use one or a combination of these but should always aim to be the most convenient for the user.

Command line arguments are good as they will be retained in the users history making it easy for them to rerun commands. Command line arguments are also convenient when the script is not run directly by the user (eg, as part of another script or a cron task etc).

Redirected from **STDIN** is good when your script is behaving like a filter and just modifying or reformatting data that is fed to it.

Reading interactively is good when you don't know what data may be required until the script is already running. eg. You may need to clarify some suspicious or erroneous input. Passwords are also ideally asked for this way so they aren't kept as plain text in the users history.

## Input Flexibility

Think about how strict you are going to be with supplied data as well. The more flexible you can be the happier the end user is going to be. Think of someone supplying a date as an argument. They could supply the date as:

**19-11-2020**

or

**19/11/2020**

or

**19:11:2020**

We could write our script to insist on input in only one particular format. This would be easiest for us but potentially not convenient for the end user. What if they want to feed the date in as provided from another command or source that provides it in a different format?

We should always aim to be most convenient for the end user as opposed to ourselves. After all, we'll write it once but they will run it many times.

The command sed can easily allow us to accommodate many formats for input data.

> flexible_date.sh

```bash
#!/bin/bash
# A date is the first command line argument
clean_date=$( echo $1 | sed 's/[ /:\^#]/-/g' )
echo $clean_date
```

```
bash-3.2$ ./flexible_data.sh 123
123
bash-3.2$
```

## Presenting Data

Remember that the terminal and the nature of the commands you use there are typically a little different to your normal interaction with computers in a graphical user interface. Again we want what is most convenient for the user. Often this is just to print the output as a plain result, without any formatting or fancy messages surrounding it. Then it is easiest for the user to redirect the output into other commands for further processing or to a file for saving.

## Organising Your Code

Presentation of your code is very important and you should take pride in it. Good structure makes it easier for you to see what the code is doing and harder to make silly mistakes (which can easily waste a lot of time or potentially worse if you don't realise the mistake).

It's common to take the approach of 'yeah yeah, that's other people though, I don't make those silly mistakes so I can be lazy and write sloppy code and it'll be fine.' Everyone can make mistakes, even NASA. Take the time to structure your code well and later on you'll be thankful you did.

- Indent your code and space it out well so that different sections are easily distinguished.
- Name variables and functions with descriptive names so it is clear what they represent and do.
- Use comments where appropriate to explain a bit of code who's operation is not immediately obvious.

## Final Word

Ok so you've worked through my Bash tutorial. Congratulations, you've now acquired some very powerful and useful skills and knowledge. Next you need to gain experience. Your Bash scripting foo is no doubt reasonably good now but it will only get better with practice.

> Tip
>
> Speaking of practice, why not try some of our [programming challenges](https://ryanstutorials.net/programming-challenges/).

Remember too that this tutorial is not a complete reference on Bash scripting. I've tried to cover the most important and essential bits.
For a lot of you this will be more than enough to automate tasks and make your interaction with Linux much happier. For others, you will want to take things further and there is much more to Bash that you can learn.
You now have a solid foundation to launch from and should have no troubles extending your abilities. Either way, I hope your experiences with Linux are, and continue to be, awesome and I wish you the best of luck.

Also, if you have any feedback on this tutorial (or any of my others) I would be happy to hear from you.
It could be a typo you have spotted, or some other error, a bit you feel could be written more clearly, or just that you found it useful.
While I can't guarantee to act upon all feedback I do very much appreciate it.
