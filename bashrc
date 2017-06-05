#######################
#!usr/local/bin/bash
#######################
# Custom bash interface

echo "Type helpme for a list of custom commands"

finder() {
	find . -name $1
}

dfinder() {
	grep -rnw "." -e $1
}

helpme() {
	echo export CUDA_SELECT=[choices include Tensorflow, 7.0, 7.5, Caffe]
	echo commands: cj, finder, dfinder, extract, helpme, ..,
}

alias ..="cd ..; ls"
alias ...="cd ../..; ls"
alias ....="cd ../../..; ls"
alias .....="cd ../../../..; ls"

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

function init () {
	python -c 'import sys; print sys.real_prefix;' 2>/dev/null && INVENV=1 || INVENV=0
	python -c 'print "\r"'
	if [ "$INVENV" = "1" ]; then
		echo Deactivating previous virtual environment
		deactivate
	fi
	echo $CUDA_SELECT
	echo Enabling my custom bash environment
        echo Error correction enabled
        shopt -s cdspell

        if [ ! "$(bash -c 'echo ${CUDA_SELECT}')" ]; then
		export CUDA_SELECT="Tensorflow"
		source /scratch/Dimitris/software/gpu-tensorflow/gtvenv/bin/activate
	fi

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

}

init

if [ "$CUDA_SELECT" = "Caffe" ]; then
	echo Exporting caffe environment
	export PYTHONPATH=/scratch/Dimitris/software/MNC/caffe-mnc/python:$PYTHONPATH
	export PYTHONPATH=/scratch/Dimitris/software/MNC/lib:$PYTHONPATH
	CAFFE_ROOT=/scratch/Dimitris/software/MNC/caffe-master/
	export CUDA_DIR=/usr/local/apps/cuda/cuda-7.0.28
        export CUDA_ROOT=/usr/local/apps/cuda/cuda-7.0.28
        export PATH=/usr/local/apps/cuda/cuda-7.0.28/bin:$PATH
        export LD_LIBRARY_PATH=/usr/local/apps/cuda/cuda-7.0.28/lib64:/usr/local/apps/cudnn/cudnn-7.0/lib64:/scratch/Dimitris/software/opencv/libs/lib


elif [ "$CUDA_SELECT" = "7.0" ]; then
	# This is what you want for MNC
	echo Exporting 7.0 cuda environment
	export CUDA_DIR=/usr/local/apps/cuda/cuda-7.0.28
	export CUDA_ROOT=/usr/local/apps/cuda/cuda-7.0.28
	export PATH=/usr/local/apps/cuda/cuda-7.0.28/bin:$PATH
	export LD_LIBRARY_PATH=/usr/local/apps/cuda/cuda-7.0.28/lib64:/usr/local/apps/cudnn/cudnn-7.0/lib64:/scratch/Dimitris/software/opencv/libs/lib

elif [ "$CUDA_SELECT" = "7.5" ]; then
	# This is what you want for NeuralModels
	echo Exporting 7.5 cuda environment
	export CUDA_DIR=/usr/local/apps/cuda/cuda-7.5.18
        export CUDA_ROOT=/usr/local/apps/cuda/cuda-7.5.18
        export PATH=/usr/local/apps/cuda/cuda-7.5.18/bin:$PATH
        export LD_LIBRARY_PATH=/usr/local/apps/cuda/cuda-7.5.18/lib64:/usr/local/apps/cudnn/cudnn-7.5/lib64:/scratch/Dimitris/software/opencv/libs/lib

elif [ "$CUDA_SELECT" = "Tensorflow" ]; then

	echo Exporting tensorflow environment
	export LD_LIBRARY_PATH=/scratch/Dimitris/software/cudnn/cudnn-5.1/lib64:/usr/local/apps/cuda/cuda-7.5.18/lib64:/scratch/Dimitris/software/opencv/libs/lib
	export CUDA_HOME=/usr/local/apps/cuda/cuda-7.5.18/

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

