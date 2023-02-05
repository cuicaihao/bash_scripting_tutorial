# Function! Divide and Conquer

## Introduction

Functions in Bash Scripting are a great way to reuse code. In this section of our Bash scripting tutorial you'll learn how they work and what you can do with them.

Think of a function as a small script within a script. It's a small chunk of code which you may call multiple times within your script. They are particularly useful if you have certain tasks which need to be performed several times. Instead of writing out the same code over and over you may write it once in a function then call that function every time.

## Functions

Creating a function is fairly easy. They may be written in two different formats:

```bash
function_name () {
<commands>
}
```

or

```bash
function function_name {
<commands>
}
```

A few points to note:

- Either of the above methods of specifying a function is valid. Both operate the same and there is no advantage or disadvantage to one over the other. It's really just personal preference.
- In other programming languages it is common to have arguments passed to the function listed inside the brackets (). In Bash they are there only for decoration and you never put anything inside them.
- The function definition ( the actual function itself) must appear in the script before any calls to the function.

Let's look at a simple example:

```bash
#!/bin/bash
# Basic function
print_something () {
echo Hello I am a function
}

function print_something_2 {
    echo Hello I am another function
}

print_something
print_something_2
```

Let's break it down:

- We start defining the function by giving it a name.
- Within the curly brackets we may have as many commands as we like.
- Once the function has been defined, we may call it as many times as we like and it will execute those commands.

```bash
bash-3.2$ ./function_example.sh
Hello I am a function
Hello I am another function
bash-3.2$
```

> Best Practice
>
> You should pick function names that are descriptive. That way it is obvious what task the function serves.

## Passing Arguments

It is often the case that we would like the function to process some data for us. We may send data to the function in a similar way to passing command line arguments to a script. We supply the arguments directly after the function name. Within the function they are accessible as **$1, $2, etc**.

> arguments_example.sh

```bash
#!/bin/bash
# Passing arguments to a function
print_something () {
echo Hello $1
}
print_something Mars
print_something Jupiter
```

> Terminal

```bash
bash-3.2$ ./arguments_example.sh
Hello Mars
Hello Jupiter
bash-3.2$
```

## Return Values

Most other programming languages have the concept of a return value for functions, a means for the function to send data back to the original calling location. Bash functions don't allow us to do this.
They do however allow us to set a return status. Similar to how a program or command exits with an exit status which indicates whether it succeeded or not. We use the keyword return to indicate a return status.

> return_status_example.sh

```bash
#!/bin/bash
# Setting a return status for a function
print_something () {
    echo Hello $1
    return 5
}
print_something Mars
print_something Jupiter
echo The previous function has a return value of $?
```

Let's break it down

- The return status doesn't have to be hardcoded.
- Remember that the variable \$? contains the return status of the previously run command or function.

```
bash-3.2$ ./return_status_example.sh
Hello Mars
Hello Jupiter
The previous function has a return value of 5
bash-3.2$
```

> Tip
>
> Typically a return status of 0 indicates that everything went successfully. A non zero value indicates an error occurred.

If all you want to do is return a number (eg. the result of a calculation) then you can consider using the return status to achieve this. It is not it's intended purpose but it will work.

One way to get around this is to use **Command Substitution** and have the function print the result (and only the result).

```bash
#!/bin/bash
# return_hack.sh
# Setting a return value to a function
lines_in_file () {
cat $1 | wc -l
}
num_lines=$( lines_in_file $1 )
echo The file $1 has $num_lines lines in it.
```

Let's break it down:

- This command will print the number of lines in the file referred to by \$1.
- We use command substitution to take what would normally be printed to the screen and assign it to the variable num_lines

```
bash-3.2$ cat myfile.txt
Tomato
Lettuce
Capsicum

bash-3.2$ ./return_hack.sh myfile.txt
The file myfile.txt has 3 lines in it.
bash-3.2$
```

Just be wary if you take this approach as if you don't call the function with command substitution then it will print the result to the screen.
Sometimes that is ok because that is what you want. Other times that may be undesirable.

## Variable Scope

Scope refers to which parts of a script can see which variables. By default a variable is global.
This means that it is visible everywhere in the script. We may also create a variable as a local variable. When we create a local variable within a function, it is only visible within that function. To do that we use the keyword local in front of the variable the first time we set it's value.

```
local var_name=<var_value>
```

It is generally considered good practice to use local variables within functions so as to keep everything within the function contained.
This way variables are safer from being inadvertently modified by another part of the script which happens to have a variable with the same name (or vice versa).

> local_variables.sh

```bash
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
```

```
bash-3.2$ ./local_variables.sh
Before function call: var1 is global AAA : var2 is global BBB
Inside function: var1 is local CCC : var2 is global BBB
After function call: var1 is global AAA : var2 is DDD (Changed in var_change())
bash-3.2$
```

> Best Practice
>
> Always use local variables within functions. Use global variables as a last resort and consider if there is a better way to do it before using them.

Scope can sometimes be hard to get your head around at first. If it seems a bit confusing, the best approach is to create a Bash script similar to the one above and tweak it several times setting and changing variables in different places then observing the behaviour when you run it.

## Overriding Commands

It is possible to name a function as the same name as a command you would normally use on the command line. This allows us to create a wrapper. eg.
Maybe every time we call the command ls in our script, what we actually want is **ls -lh**. We could do the following:

```bash
#!/bin/bash
# override.sh
# Create a wrapper around the command ls
ls () {
    command ls -lh
}
ls
```

Let's break it down:

- When we have a function with the same name as a command we need to put the keyword command in front of the the name when we want the command as opposed to the function as the function normally takes precedence.

```
bash-3.2$ ./override.sh
total 72
-rw-r--r--  1 caihaocui  staff   7.1K Nov 19 23:05 Functions.md
-rwxr-xr-x  1 caihaocui  staff   127B Nov 19 22:45 arguments_example.sh
-rwxr-xr-x  1 caihaocui  staff   182B Nov 19 22:42 function_example.sh
-rwxr-xr-x  1 caihaocui  staff   370B Nov 19 23:04 local_variables.sh
-rw-r--r--  1 caihaocui  staff    24B Nov 19 22:54 myfile.txt
-rwxr-xr-x  1 caihaocui  staff    80B Nov 19 23:06 override.sh
-rwxr-xr-x  1 caihaocui  staff   163B Nov 19 22:52 return_hack.sh
-rwxr-xr-x  1 caihaocui  staff   195B Nov 19 22:46 return_status_example.sh
bash-3.2$ ls
Functions.md                    function_example.sh             myfile.txt                      return_hack.sh
arguments_example.sh            local_variables.sh              override.sh                     return_status_example.sh
bash-3.2$
```

**In the example above, if we didn't put the keyword command in front of ls on line 5 we would end up in an endless loop.** Even though we are inside the function ls when we call ls it would have called another instance of the function ls which in turn would have done the same and so on.

> Tip
>
> It's easy to forget the command keyword and end up in an endless loop. If you encounter this then you can cancel the script from running by pressing the keys **CTRL c** at the same time on your keyboard. **CTRL c** is a good way to cancel your script (or a program) whenever you get into trouble on the command line.

## Design

Creating functions in your Bash scripts is easy. Creating good functions that make your scripts easier to write and maintain takes time and experience however. As with most things with computers when you get to this level of complexity, there will be several ways you could achieve the desired outcome. Some will be better than others so take the time to think about different ways you could write your code and which way may be better.

Sometimes better is least lines of code, sometimes better is easiest to modify later if requirements change. Sometimes better is the approach which is least prone to errors.

If a particular task needs to be performed several times then it is a good candidate for placing within a function.

Sometimes it is good to put ancillary tasks within functions too so that they are logically separate from the main part of the script. A common example is validating input (eg. making sure a specified file exists and is readable).

A function is most reusable when it performs a single task and a single task only. Instead of having a large function, consider breaking it up into several functions and breaking the task up.

You need to find the right balance however. If the functions are too large and take on too much processing then you don't get the full benefit. If you divide up into too many functions then your code can easily grow and become silly. With experience you will find that sweet spot in the middle.

## Summary

> stuff We Learnt

- function <name> or <name> ()

  Create a function called name.

- return <value>

  Exit the function with a return status of value.

- local <name>=<value>

  Create a local variable within a function.

- command <command>

  Run the command with that name as opposed to the function with the same name.

> Important Concepts

- Re-use

  Functions allow us to easily re-use code making the code easier to manage and read.

- Planning

  Now that your scripts are getting a little more complex you will probably want to spend a little bit of time thinking about how you structure them before diving in.

## Activities

For this section there aren't any activities. What I suggest you do is go back to the activities from the previous section and redo them using functions.
