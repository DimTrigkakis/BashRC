#######################
#!usr/local/bin/bash
#######################
# Custom bash interface

echo "Type helpme for a list of custom commands"

# Set up different bash file for desktop and server

export LOCATION="HOME"
# export LOCATION="SERVER"

if [ "$LOCATION" = "HOME" ]; then

helpme() {
	echo export DEEP_FRAMEWORK=[choices include Pytorch]
	echo commands: open_pdf, restart_bisque, kill_port, timeme, connect, ssh_connect, relocate,  finder, dir_finder, r, cj, extract, activate
}

open_pdf()
{ 
	if [ -d $1 ]
	then
		echo "directory"
		cj $1
	else
		if [[ $1 == *.pdf ]]
		then
			echo "ocular"
			okular $1
		else
			echo "Cannot open"
		fi
	fi

}

restart_bisque() {
	
	cd ~/Sandbox/bisque
	source bqenv/bin/activate
	bq-admin server stop
	rm ./bisque_8080.pid
	rm ./bisque_27000.pid
	kill_port 27000
	kill_port 8080
	bq-admin server start
}

kill_port() {
	PORT_NUMBER=$1
	
	lsof -i tcp:${PORT_NUMBER} | awk 'NR!=1 {print $2}' | xargs kill 
}

timeme() {
	python ~/Sandbox/Timer/timer.py
}

connect() {
	sudo openconnect sds.oregonstate.edu
}

relocate() {
	cj ~/
}

else

helpme() {
	echo export DEEP_FRAMEWORK=[choices include Pytorch]
	echo commands: ssh_connect, relocate,  finder, dir_finder, r, cj , extract, activate
}

relocate() {
	cd /scratch/Dimitris/
}

fi

finder() {
	find . -name $1
}

dir_finder() {
	grep -rnw "." -e $1
}

r () {
	source ~/.bashrc
}


sshconnect() {
	ssh -X trigkakd@gpu-bart.eecs.oregonstate.edu
}


alias ..="cd ..; ls"
alias ...="cd ../..; ls"
alias ....="cd ../../..; ls"
alias .....="cd ../../../..; ls"

alias cj=cd_alias
        function cd_alias() {

                if [ "$1" = "" ]; then
                        cd ..
                        ls
                else
                        cd $1
                        ls
                fi
        }

extract () {
   if [ -f $1 ] ; then
       case $1 in
           *.tar.bz2)   tar xvjf $1    ;;
           *.tar.gz)    tar xvzf $1    ;;
           *.bz2)       bunzip2 $1     ;;
           *.rar)       unrar x $1       ;;
           *.gz)        gunzip $1      ;;
           *.tar)       tar xvf $1     ;;
           *.tbz2)      tar xvjf $1    ;;
           *.tgz)       tar xvzf $1    ;;
           *.zip)       unzip $1       ;;
           *.Z)         uncompress $1  ;;
           *.7z)        7z x $1        ;;
           *)           echo "don't know how to extract '$1'..." ;;
       esac
   else
       echo "'$1' is not a valid file!"
   fi
}

activate ()
{
	source $1/bin/activate
}


function init () {
    
    if [ ! "$(bash -c 'echo ${DEEP_FRAMEWORK}')" ]; then
		export DEEP_FRAMEWORK="Pytorch"
	fi

	echo Using: $DEEP_FRAMEWORK, enabling my custom bash environment, error correction enabled
    shopt -s cdspell

}

init

if [ "$LOCATION" = "HOME" ]; then

    if [ "$DEEP_FRAMEWORK" = "Pytorch" ]; then

	    activate ~/Research/pytorch/penv
	    export LD_LIBRARY_PATH=~/Research/cuda/lib64
	    export CUDA_HOME=~/Research/cuda

    fi

else
    if [ "$DEEP_FRAMEWORK" = "Pytorch" ]; then

	    activate /scratch/Dimitris/software/pytorch/pytorchenv
	    export LD_LIBRARY_PATH=/scratch/Dimitris/libs/cudnn/cudnn-5.1/lib64:/usr/local/apps/cuda/cuda-8.0/lib64:
        #export LD_LIBRARY_PATH=/scratch/test/lib/python2.7/site-packages
        #export LD_LIBRARY_PATH=/scratch/datasets/NFLvid/pycv/usr/local/lib
	    export CUDA_HOME=/usr/local/apps/cuda/cuda-8.0/

    fi
fi

##
###############################################################
# Standard bash interface
# version 2005.07.01

# .bashrc -- initialization for each bash shell invoked.
# nothing here should output anything to the screen.
# if it does, things like sftp (secure ftp) will fail with some weird errors

# this is a pretty bare-bones .bashrc.  We don't really support bash;
# we mainly want to make sure the shell is halfway functional.  You can
# make it spiffy and pretty. :-)  If you have suggestions for some fundamental
# settings here, mail support@engr.orst.edu.   thx


############################################################
# First we set a pretty basic path that should work on all
# OS's.  We will be pre and post-pending to it below, with
# OS-specific paths.
############################################################
export PATH=$PATH:/bin:/sbin:/usr/local/bin:/usr/bin:/usr/local/apps/bin:/usr/bin/X11
export MANPATH=/usr/local/man:/usr/man
export LESS="QMcde"
export MORE="-c"
export PAGER=less
umask 007

#### Special - remove backspace editing error
stty erase '^?'

############################################################
# here we figure out which OS we're running on and make
# appropriate settings.  Our goal here is to keep the
# environment consistent.
# no real reason to export TEMP_OS; only used briefly
############################################################
TEMP_OS=`/bin/uname`
if [ "$TEMP_OS" == "Linux" ]; then
    export MANPATH=$MANPATH:/usr/share/man
fi
if [ "$TEMP_OS" == "SunOS" ]; then
    export PATH=/usr/ccs/bin:$PATH:/opt/SUNWspro/bin:/usr/sfw/bin:/usr/ucb:/usr/local/X11R6/bin
    export MANPATH=$MANPATH:/usr/dt/man:/opt/SUNWspro/man:/usr/sfw/man:/usr/local/X11R6/man
fi
if [ "$TEMP_OS" == "HP-UX" ]; then
    export PATH=/usr/ccs/bin:$PATH:/opt/fortran90/bin:/usr/local/X11R6/bin
    export MANPATH=$MANPATH:/usr/dt/man:/opt/ansic/share/man:/opt/fortran90/share/man:/usr/local/X11R6/man
    alias who='/bin/who -R'
    alias df='/bin/bdf'
fi

############################################################
# Now we add a personal bin directory and '.', which is the
# current directory.  This would be a good place to add
# any other special directories to your path or MANPATH
############################################################
export PATH=$PATH:~/bin:.
#export MANPATH=$MANPATH:

alias cp="cp -i"
alias rm="rm -i"
alias mv="mv -i"
alias z="suspend"
alias la="ls -aF"
alias lf="ls -F"
alias lfa="ls -AF"
alias ll="ls -gl"
alias lla="ls -agl"

