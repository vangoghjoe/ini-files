### ~/.bashrc

#
#  See /etc/profile for notes on shell rc file calling sequence
#

[ -n "$TRACERC" ] && echo "Starting ~/.bashrc"

#-----------------------------------------------------------
#----------    Load SYSTEM bashrc     
#----------      (this goes at beg of ~/.bashrc)
#-----------------------------------------------------------
if [ -r /etc/bashrc ]; then . /etc/bashrc ; fi

#-----------------------------------------------------------
#----------    Load SYSTEM local bashrc     
#----------      (this goes at beg of ~/.bashrc)
#-----------------------------------------------------------
if [ -r /etc/bashrc.local ]; then . /etc/bashrc.local ; fi

# * * * * *  DON'T CHANGE ABOVE HERE * * * * * * * * * * * *
############################################################
############################################################

#+ + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
#+ + + + +     CUSTOMIZABLE SECTION
#+ + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
# Add whatever you want here

#++  Aliases for the using dm-shell-dir-vars functions
#++  Do dm-shell-dir-vars-help (or dvh) for help
unalias dve &>/dev/null ; alias dve=dm-shell-dir-vars-edit
unalias dva &>/dev/null ; alias dva=dm-shell-dir-vars-add
unalias dvl &>/dev/null ; alias dvl=dm-shell-dir-vars-list
unalias dvh &>/dev/null ; alias dvh=dm-shell-dir-vars-help

#~~~  Some suggested functions and aliases.  ~~~
#~~~  Just uncomment to use                  ~~~

#++  Edit and source users's various .bashrc and .bash_profile files
#++   NOTE: 'dm-shell-edit-and-source' is defined in /etc/bashrc
edb() { dm-shell-edit-and-source ~/.bashrc ; }
edbl() { dm-shell-edit-and-source ~/.bashrc.local ; }
edp() { dm-shell-edit-and-source ~/.bash_profile ; }
edpl() { dm-shell-edit-and-source ~/.bash_profile.local ; }

alias   path="echo \$PATH | tr ':' '\012'"
#++  Miscellaneous

############################################################
############################################################
# * * * * *  DON'T CHANGE BELOW HERE * * * * * * * * * * * *

#-----------------------------------------------------------
#----------    Load USER LOCAL bashrc
#----------     (this goes at end of ~/.bashrc)
#-----------------------------------------------------------
ee-login
if [ -r ~/.bashrc.local ]; then . ~/.bashrc.local ; fi

[ -n "$TRACERC" ] && echo "Leaving ~/.bashrc"
