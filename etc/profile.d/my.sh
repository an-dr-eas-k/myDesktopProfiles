#!/bin/sh

pathmunge () {
	if ! echo $PATH | /bin/egrep -q "(^|:)$1($|:)" ; then
	   if [ "$2" = "after" ] ; then
	      PATH=$PATH:$1
	   else
	      PATH=$1:$PATH
	   fi
	fi
}
function settitle1() { echo -ne "\e]0;$@\a"; }
function settitle2() { echo -ne "\e]2;$@\a\e]1;$@\a"; }

umask 0002
pathmunge /home/sys/bin
pathmunge /home/aki/bin

export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
export VISUAL=gvim
export TIME_STYLE=long-iso

# alias unison="unison -times";
alias fr="file-roller";
alias mt=multitail
alias gm=gnome-mount
alias bc="bc -lq"
alias today="date +%F"
alias cp="cp -i";
alias mv="mv -i";
alias top="top; clear"
alias cal='cal -m'
alias ls='ls --group-directories-first --color=auto' 2>/dev/null
alias ll='ls --group-directories-first --color=auto -lhog'
alias l.='ls --group-directories-first --color=auto -d .*' 2>/dev/null
alias l='ls --group-directories-first --color=auto -CF1'
alias umount='echo "use udisks instead"'
alias vi='vim'
#alias gvim='/cygdrive/c/Program\ Files\ \(x86\)/Vim/Vim74/gvim.exe'

export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTFILESIZE=10000
export HISTSIZE=${HISTFILESIZE}
shopt -s histappend
# export PS1='[\u@\h:\w] '

PS1='\[\033[01m\][\u@\h\[\033[00m\]:\[\033[01m\]\w]\[\033[00m\]\n\$ ';
PROMPT_COMMAND='printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'

stty stop undef
stty start undef

IGNOREEOF=5

export RETURN=$'\x0A';
export TAB=$'\x09';

#if [ -e $HOME/.bashrc ]; then
#	. $HOME/.bashrc;
#fi

unset pathmunge
