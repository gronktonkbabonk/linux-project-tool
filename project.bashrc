# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
alias vim='nvim'



function project() {

    DIR_CONFIG_FILE="$HOME/.project_config"
    TEXED_CONFIG_FILE="$HOME/.text_editor_config"

    # Check if a project name is passed as an argument
    if [ $# -eq 0 ]; then
        echo "Please provide arguments."
        return 1
    fi

    # Check if the project config file exists and create it if not
    if [ ! -f "$DIR_CONFIG_FILE" ]; then
        touch "$DIR_CONFIG_FILE"
    fi

    # Read the project directory from the config file or set default
    project_dir=$(head -n 1 "$DIR_CONFIG_FILE")
    if [ -z "$project_dir" ]; then
        project_dir="$HOME/Desktop/projects" # Set a default project directory
    fi

    # Check if the text editor config file exists and create it if not
    if [ ! -f "$TEXED_CONFIG_FILE" ]; then
        touch "$TEXED_CONFIG_FILE"
    fi

    # Read the text editor from the config file or set default
    text_editor=$(head -n 1 "$TEXED_CONFIG_FILE")
    if [ -z "$text_editor" ]; then
        text_editor="nvim" # Set a default text editor
    fi

    project_name="$1"
    project_path="$project_dir/$project_name"
    project_exists=1
    
    if [ $1 = "--help" ] || [ $1 = "-h" ]; then
        echo -e "GRONK'S PROJECT TOOL
 
Usage:

project [projectname]: this will cd to the project, open it in the file mgr and open it in your text editor (default nvim)
project [projectname] -b: this will do the same, but cd into the project's build directory

project [newprojectname] -c: this will create a new project in your project directory
project [newprojectname] -c -o: this will do the same as above, but also open it as if you had opened it with this tool

project [directory] -f: this will change the directory of where your projects are created and looked for.
project [texteditor] -t: this will alter the text editor to the one specified. It needs to be able to open folders in the console.

project -h/ --help: show this screen"

fi
    if [ ! -d "$project_path" ]; then
        project_exists=0
    fi
    
    case "$2" in
        "-b" )
            if [ "$project_exists" -eq 0 ]; then
                echo "$1 is not a recognized project in $project_dir"
                return 1
            else
                cd "$project_path/build" || echo "$1 is not a recognized project in $project_dir"
            fi
            ;;
        "-c" )
            mkdir "$project_dir/$project_name"
            echo "Project $project_name created"
            if [ "$3" == "-o" ]; then
                cd "$project_dir/$project_name"
                gnome-terminal --tab --working-directory="$project_path" -- "$text_editor"
                xdg-open "$project_path" &>/dev/null
            fi
            return 0
            ;;
        "-f" )
            if [ -d "$1" ]; then
                # Set the project directory in the config file
                echo "$1" > "$DIR_CONFIG_FILE"
                echo "Project directory changed to $1"
                return 0
            else
                echo "Directory $1 does not exist."
                return 1
            fi
            ;;
        "-t" )
            echo "$1" > "$TEXED_CONFIG_FILE"
            echo "Text editor changed to $1. reminder that it needs to be able to open folders in the console."
            return 1
            ;;
        "" )
            if [ "$project_exists" -eq 0 ]; then
                echo "$1 is not a recognized project in $project_dir"
                return 1
            else
                cd "$project_path"
            fi  
            ;;
        * )
            echo "Invalid option."
            return 1
            ;;
    esac
    gnome-terminal --tab --working-directory="$project_path" -- "$text_editor"
    xdg-open "$project_path" &>/dev/null
}


