---
marp: true
size: half
style: |
  section {
    --page-padding-chars: 4;
    --code-white-space: pre-wrap;
    --code-max-width: 100cqw;
    --code-max-lines: 25;
  }
---

# microexcursion / The Way of the Comannd Line Interface (CLI)

---

prelude -> [https://hackertyper.com](https://hackertyper.com)

> prelude -> [https://hackertyper.com](https://hackertyper.com)

---

prelude -> `figlet -f slant "WEHEARTCLI" | lolcat`

---

## Rite of Passage

```
the CLI is the engine room
the CLI is friction
i hereby promise to respect the CLI
i will embrace the CLI
i will help others to embrace the CLI 
i will improve my tools
i am not a user, i am an operator
```

---

## PART_00 :: The Command Line Interface (CLI)

the command line interface (CLI), sometimes also called *shell*, *console* or *terminal*, is a text-based interface to your operating system.

PS ( *shell*, *console* or *terminal* are not the same thing but are often used interchangeably. common shells are `zsh` ( on macOS ) and `bash` ( on linux ). )

---

### anatomy of a command

a command (CMD) in the shell can have these components:

```sh
name -option "argument"
```

… it also sometimes returns or prints something ( e.g `echo "hello"` prints `hello` ).

---

## PART_01 :: basic commands

```sh
# comment

# change directory
cd
# '/tmp' is an argument
cd /tmp
# change multiple directories,
# separated by slash `/`
cd /tmp/foo
# `..` is a special token and
# leaves the current directory
cd ..

# list files and folders
ls
# cmd with option
ls -a

# show manual for cmd. on the man page
# type `q` to exit and `/` to search for a term
man
# manual for 'ls' cmd
man ls
```

->

---

```sh
# print working directory
pwd

# make directory
mkdir
# also makes all directories in between
mkdir -p path/to/directory

# simple text editor
nano
# catalog / concatenate
cat
# print
echo

# ⚠️ACHTUNG: THIS IS DANGEROUS,
# NO CONFIRMATION!!!⚠️
# remove files or directories
# e.g `sudo rm -rf /` deletes the entire main
# harddrive without asking
rm
# '-r' is required to remove directories
rm -r path/to/directory

# copy files or directories
cp
# '-r' is required to copy directories
cp -r path/to/directory path/to/dst

# move or rename file or directory
mv
```

---

## PART_02 :: helpful shortcuts

```sh
CTRL+C   # (C)ancel process
CTRL+E   # jump to (E)nd of line
CTRL+A   # jump to (A)nfang of line
CTRL+L   # c(L)ear screen buffer
TAB      # tries to auto-complete commands,
         # files or directories and
         # sometimes options
UP+DOWN  # cycle through command history
CTRL+R   # search history
```

---

## PART_03 :: packages extend the CLI

on macOS a package manager must be installed first. we use [Homebrew](https://brew.sh/). run this command in a shell to install Homebrew and follow the instructions:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

linux (usually) ships with a pre-installed package manager ( e.g `apt` or `pacman` ).

```sh
# package manager on macOS
brew
brew install tree

# package manager on linux
apt
sudo apt install tree

# list files and directories
# ( -> brew install tree )
tree
# what does it do?!? :)
# ( -> brew install asciiquarium )
asciiquarium
```

---

## PART_04 :: shell scripts

```sh
# create a file, add e.g 'echo "hello world"'
nano hello_world.sh

# make script executable
chmod +x hello_world.sh

# execute local script file
./hello_world.sh

# execute same local script file with shell
sh hello_world.sh

# add this shebang to head of script
# ( defines interpreter )
echo "#!/bin/sh" > hello_world.sh
```

---

## PART_05 :: environment variables

```sh
# system variables (selection)
HOME        # home directory, same as `~`
USER        # current user ( i.e operator ;) )
PATH        # directories with executable files
echo $HOME  # '$' gets value of variable

# custom variables
# (only exist in current shell session)
export FOO="foo"  # global variable
BAR="bar"         # local variable
echo $FOO $BAR
```

---

## PART_06 :: helpful things

some tools or commands might need to be installed with a package manager.

```sh
# '~' is short for '$HOME'
ls ~/
# startup script at new session
nano ~/.zshrc

# 'cd' without arguments -> cd $HOME
cd
# temporary folder, gets wiped occasionally
cd /tmp

# search for pattern in file
grep "pattern" file.txt
# search in multiple files and folders '-r'
grep -r "pattern" /path/to/folder/
# ... same as above but with line numbers '-n'
# and case-insensitive '-i'
grep -r -n -i "pattern" /path/to/f/
# ... same as above, but shorter
grep -rni "pattern" /path/to/f/
```

->

---

```sh
# create custom shortcut
alias
# 'woman' now executes 'man' ( <- ?!? )
alias woman=man
# extra: remove custom shortcut
unalias woman

# print user name
whoami

# list last commands
history
# extra: execute command number '1234' with '!'
!1234
# clear history
history -c
```

->

---

```sh
# output redirection operators '>' and '>>'
# replace content
echo "hello world" > file.txt
# append content
echo "42" >> file.txt

# pipe operator '|'
# example: just list files with 'Umfeld'
ls $UMFELD_PATH/include | grep -i "Umfeld"

# in a script this contains the arguments
echo $0 $1 $2
# pass arguments to script:
# $1 is '23' and $2 is '42'
./hello_world.sh 23 42
```

->

---

```sh
# (macOS) clipboard
# copy input ( from '|' ) to clipboard
pbcopy
# copy current directory to clipboard
pwd | pbcopy
# print clipboard content
pbpaste

# command substitution: captures the output
$(some_cmd)
# print output of date ( second )
echo $(date +"%S")

# repeat a command periodically
watch
# run script once a second
watch -n 1 ./script.sh
```

->

---

```sh
# command chaining

# execute cmds regardless of failure
;
# execute 'echo' and then 'ls'
echo "CONTENT:" ; ls

# stop when a cmd fails
&&
# fail executing 'echX' and then stop, no 'ls'
echX "CONTENT:" && ls

# only execute when previous cmd fails
||
# fail executing 'echX' and then execute 'ls'
echX "CONTENT:" || ls

# ⚠️ACHTUNG: THIS IS VERY DANGEROUS!!!⚠️
# run command with *superuser* privileges
# ( i.e system administrator )
sudo
# list hidden system files
sudo ls /system/folder/
```

->

---

```sh
# (macOS) package manager
# search for a package
brew search some_package
# get info for a package
brew info some_package
# install a package
brew install some_package
# uninstall a package
brew uninstall some_package

# records and plays CLI interactions into file
asciinema
```

on macOS in *Finder* right-clicking on a file or folder while also pressing `ALT` key allows to copy the *pathname* to clipboard.

---

## TUI

there are also a lot of *Text-based User Interface* (TUI) applications …
- [rothgar/awesome-tuis: List of projects that provide terminal user interfaces](https://github.com/rothgar/awesome-tuis)

---

## Terminal Applications

- [iTerm2](https://iterm2.com/) -> `brew install iterm2` #macOS
- [Ghostty](https://ghostty.org/) -> `brew search ghostty` #linux
- [Kitty](https://sw.kovidgoyal.net/kitty/) -> `brew install kitty` #macOS #linux
- [cool-retro-term](https://github.com/Swordfish90/cool-retro-term)  #macOS
- [Tabby - a terminal for a more modern age](https://tabby.sh/) --> #windows #macOS #linux
- [st - st is a simple terminal implementation for X](https://st.suckless.org/) --> #linux

---

## Shells
- [fish shell](https://fishshell.com/) -> `brew install fish` #macOS #Linux
- [Zsh](https://www.zsh.org/) -> `brew install zsh` #macOS #linux
- [PowerShell](https://learn.microsoft.com/de-de/powershell/) -> #windows

---

## Where to Go From Here

- https://terminaltrove.com
- https://www.climagic.org
- https://hackertyper.com
