# What is a Bash Script?

## Introduction

This page is mostly foundation information. It's kinda boring but essential stuff that will help you to appreciate why and how certian things behave the way they do once we start playing about with the fun stuff (which I promise we'll do in the next section). Taking the time to read and understand the material in this section will make the other sections easier to digest so persevere and it'll be well worth your time.

### So what are they exactly?

Think of a script for a play, or a movie, or a TV show. The script tells the actors what they should say and do. A script for a computer tells the computer what it should do or say. In the context of Bash scripts we are telling the Bash shell what it should do.

A Bash script is a plain text file which contains a series of commands. These commands are a mixture of commands we would normally type ouselves on the command line (such as ls or cp for example) and commands we could type on the command line but generally wouldn't (you'll discover these over the next few pages). An important point to remember though is:

**Anything you can run normally on the command line can be put into a script and it will do exactly the same thing. Similarly, anything you can put into a script can also be run normally on the command line and it will do exactly the same thing.**

You don't need to change anything. Just type the commands as you would normally and they will behave as they would normally.
It's just that instead of typing them at the command line we are now entering them into a plain text file.
In this sense, if you know how to do stuff at the command line then you already know a fair bit in terms of Bash scripting.

It is convention to give files that are Bash scripts an extension of `.sh` (myscript.sh for example). As you would be aware, Linux is an extensionless system so a script doesn't necessarily have to have this characteristic in order to work.

### How do they work?

This is just a little bit of background knowledge. It's not necessary to understand this in order to write scripts but it can be useful to know once you start getting into more complex scripts (and scripts that call and rely on other scripts once you start getting really fancy).

In the realm of Linux (and computers in general) we have the concept of programs and processes.
A program is a blob of binary data consisting of a series of instructions for the CPU and possibly other resources (images, sound files and such) organised into a package and typically stored on your hard disk.

When we say we are running a program we are not really running the program but a copy of it which is called a process. What we do is copy those instructions and resources from the hard disk into working memory (or RAM).
We also allocate a bit of space in RAM for the process to store variables (to hold temporary working data) and a few flags to allow the operating system (OS) to manage and track the process during it's execution.

**Essentially a process is a running instance of a program.**

There could be several processes representing the same program running in memory at the same time. For example I could have two terminals open and be running the command cp in both of them. In this case there would be two cp processes currently existing on the system. Once they are finished running the system then destroys them and there are no longer any processes representing the program cp.

When we are at the terminal we have a Bash process running in order to give us the Bash shell.
If we start a script running it doesn't actually run in that process but instead starts a new process to run inside.
We'll demonstrate this in the next section on variables and it's implications should become clearer. For the most part you don't need to worry too much about this phenomenon however.

### How do we run them?

Running a Bash script is fairly easy. Another term you may come across is **executing** the script (which means the same thing).
Before we can execute a script it must have the execute permission set (for safety reasons this permission is generally not set by default).
If you forget to grant this permission before running the script you'll just get an error message telling you as such and no harm will be done.

```bash
bash-3.2$ cat myscript.sh
#!/bin/bash
# A sample Bash script, by Chris
echo Hello World!

bash-3.2$ ./myscript.sh
bash: ./myscript.sh: Permission denied

bash-3.2$ ls -l myscript.sh
-rw-r--r--  1 caihaocui  staff  61 Nov 18 11:13 myscript.sh

bash-3.2$ chmod 755 myscript.sh
bash-3.2$ ls -l myscript.sh
-rwxr-xr-x  1 caihaocui  staff  61 Nov 18 11:13 myscript.sh

bash-3.2$ ./myscript.sh
Hello World!
```

> **Tip**
>
> The shorthand 755 (-rwxr-xr-x) is often used for scripts as it allows you the owner to write or modify the script and for everyone to execute the script.

Here are the contents of myscript.sh

```bash
1. #!/bin/bash
2. # A sample Bash script, by Chris
3.
4. echo Hello World!
```

Let's break it down:

- Line 1 - Is what's referred to as the shebang. See below for what this is.
- Line 2 - This is a comment. Anything after # is not executed. It is for our reference only.
- Line 4 - Is the command echo which will print a message to the screen. You can type this command yourself on the command line and it will behave exactly the same.
- The syntax highlighting is there only to make it easier to read and is not something you need to do in your own files (remember they are just plain text files).

## Why the ./

You've possibly noticed that when we run a normal command (such as ls) we just type its name but when running the script above I put a ./ in front of it.
When you just type a name on the command line Bash tries to find it in a series of directories stored in a variable called `\$PATH`. We can see the current value of this variable using the command echo (you'll learn more about variables in the next section).

```bash
bash-3.2$ echo $PATH
/Users/caihaocui/opt/miniconda3/bin:/Users/caihaocui/opt/miniconda3/condabin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/TeX/texbin:/Library/Apple/usr/bin
bash-3.2$
```

The directories are separated by " : "
Bash only looks in those specific directories and doesn't consider sub directories or your current directory.
It will look through those directories in order and execute the first instance of the program or script that it finds.

The `$PATH` variable is an individual user variable so each user on a system may set it to suit themselves.

This is done for a few different reasons.

- It allows us to have several different versions of a program installed. We can control which one gets executed based on where it sits in our `$PATH`.
- It allows for convenience. As you saw above, the first directory for myself is a bin directory in my home directory. This allows me to put my own scripts and programs there and then I can use them no matter where I am in the system by just typing their name. I could even create a script with the same name as a program (to act as a wrapper) if I wanted slightly different behaviour.
- It increases safety - For example a malicious user could create a script called ls which actually deletes everything in your home directory. You wouldn't want to inadvertantly run that script. But as long as it's not in your \$PATH that won't happen.

If a program or script is not in one of the directories in your `$PATH` then you can run it by telling Bash where it should look to find it. You do so by including either an absolute or relative path in front of the program or script name.
You'll remember that dot ( `.` ) is actually a reference to your current directory.
Assuming you are in the root directory of this repo you could also have run it by using an relative path.

```bash
bash-3.2$ ./01_what_is_a_bash_script/myscript.sh
Hello World!
```

## The Shebang (#!)

**`#!/bin/bash`**

This is the first line of the script above. The hash exclamation mark ( `#!` ) character sequence is referred to as the Shebang.
Following it is the path to the interpreter (or program) that should be used to run (or interpret) the rest of the lines in the text file. (For Bash scripts it will be the path to Bash, but there are many other types of scripts and they each have their own interpreter.)

Formatting is important here. The shebang must be on the very first line of the file (line 2 won't do, even if the first line is blank). There must also be **no** spaces before the # or between the ! and the path to the interpreter.

Whilst you could use a relative path for the interpreter, most of the time you are going to want to use an absolute path. You will probably be running the script from a variety of locations so absolute is the safest (and often shorter than a relative path too in this particular case).

It is possible to leave out the line with the shebang and still run the script but it is unwise. If you are at a terminal and running the Bash shell and you execute a script without a shebang then Bash will assume it is a Bash script. So this will only work assuming the user running the script is running it in a Bash shell and there are a variety of reasons why this may not be the case, which is dangerous.

You can also run Bash, passing the script as an argument.

```zsh
(base) ➜  01_what_is_a_bash_script git:(master) ✗ bash myscript.sh
Hello World!
(base) ➜  01_what_is_a_bash_script git:(master) ✗
```

Whilst this is safe it also involves unnecessary typing every time you want to run the script.

> **Best Practice**
>
> Given the observations above it is best to always include the shebang ( #! ). It is the most reliable and convenient approach.

## Formatting

As we saw above, formatting for the shebang was important (ie no spaces, must be on first line). There are many areas in Bash scripts where formatting is important.
Typically it involves spaces and either the presence or absence of a space can be the difference between the command working or not.
I'll point these out as we encounter them. Also get in the habit of being mindful of the presence or absence of spaces when looking at code.

The main reason for this is that Bash was originally developed as an interface for Users to interact with the system and later extended to have more powerful scripting capabilities.
Many decisions regarding it's behaviour were made considering only the needs of the user and then scripting capabilities had to be worked in, later, around those decisions. People generally don't mind this however as Bash scripts are still an awesome tool for quickly and easily joining existing programs into more powerful solutions.

I have seen students spend quite a bit of time in frustration that a piece of code that looks perfectly fine isn't working. They get quite embarassed when they find out the culprit (a space that either should or shouldn't be there). You will probably make this mistake a few times yourself before it sinks in so don't worry too much but the sooner you get the hang of it the happier you will be :)

Indenting of code is another area of formatting that is important. We'll look at indenting of code in section 5 (`If Statements`) when it becomes relevant. Indenting is not required but it does make your code easier to read and make it harder to make simple errors.
