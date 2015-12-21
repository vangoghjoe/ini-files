### ~/.bash_profile

#
#  See /etc/profile for notes on shell rc file calling sequence
#

[ -n "$TRACERC" ] && echo "Starting ~/.bash_profile"

# * * * * *  DON'T CHANGE ABOVE HERE * * * * * * * * * * * *
############################################################
############################################################

#+ + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
#+ + + + +     CUSTOMIZABLE SECTION
#+ + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
# Add whatever you want here



############################################################
############################################################
# * * * * *  DON'T CHANGE BELOW HERE * * * * * * * * * * * *

#-----------------------------------------------------------
#----------    Load user's local profile
#-----------------------------------------------------------
if [ -r ~/.bash_profile.local ]; then . ~/.bash_profile.local ; fi

#-----------------------------------------------------------
#----------    Load user's bashrc
#-----------------------------------------------------------
if [ -r ~/.bashrc ]; then . ~/.bashrc ; fi

[ -n "$TRACERC" ] && echo "Leaving ~/.bash_profile"
