### /etc/profile.local

# SPECIAL NOTE:
#  - This file, 'ee-profile.sh', should be put in /etc/profile.d.
#
#  - sets EE_PATH and defines functions 'ee-login' and 'ee-logout'
#

[ -n "$TRACERC" ] && echo "Starting /etc/profile.d/ee-profile.sh"

# * * * * *  DON'T CHANGE ABOVE HERE * * * * * * * * * * * *
############################################################
############################################################

#+ + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
#+ + + + +     CUSTOMIZABLE SECTION
#+ + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
# Add whatever you want here
export EE_PATH="/usr/local/DM/eebin"

# Call when finished doing ee-stuff to reset the path
ee-logout() {
    if [ $DVB_PATH ]; then	
        PATH=$DVB_PATH	
        hash -r   # re-lookup paths
        PS1="$DVB_PS1"
        unset DVB_PATH DVB_PROJ MYEE
        _set-PS1
        printf "\nOriginal user settings have been restored\n\n"
        echo "PATH=$PATH"
    else
        echo "You were not logged in to any project."
    fi
}


ee-login() {
    local MUMPS
    if [ $DVB_PATH ]; then
        ee-logout
    fi

    if [ -d $EE_PATH ]; then
        cd $EE_PATH
        PS3='Choose project by number (? for help, / to quit): '
        printf "\n *** Electronic Evidence Login on $HOSTNAME ***\n\n"
        #select DVB_PROJ in [A-Z0-9]*[A-Z]; do #THIS WORKED BUT REGEXP NOT QUITE SMART ENOUGH
        #select DVB_PROJ in $(ls * | grep '^[A-Z0-9]*$'); do THIS IS BROKEN -- PROVIDES SUBDIR
        select DVB_PROJ in $(find -maxdepth 1 -mindepth 1 -type d -printf "%f\n" | grep '^[A-Z0-9]*$'); do
            if [ $DVB_PROJ ] && [ -d ${DVB_PROJ} ]; then
                printf "\nLoading settings...\n\n"
                DVB_PATH=$PATH
                DVB_PS1=$PS1
                MYEE="${EE_PATH}/${DVB_PROJ}"
                PATH="${MYEE}:${PATH}"
                _set-PS1
                export DVB_PATH DVB_PS1 PATH PS1 EE_PATH DVB_PROJ
                printf "PROJECT - $DVB_PROJ\n"
                printf "\$PATH - $PATH\n\n"
                printf "\$MYEE - $MYEE\n\n"
                printf "Be sure to run ee-out when you are done with this project.\n"
                printf "Using these project settings on another project is highly dangerous!\n\n"
                break
            elif [ $REPLY == "?" ]; then
                printf "\n\t\tEnter\n"
                printf "\t\t\t ?   -  help\n"
                printf "\t\t\t /l  -  list all projects\n"
                printf "\t\t\t /   -  quit without logging in\n\n"	
            elif [ $REPLY == "/l" ]; then
                printf "\n\tActive Projects:\n"
                for proj in [A-Z]*[A-Z]; do
                    if [ -d $proj ]; then
                        printf "\t  *  $proj\n"
                    fi
                done
                printf "\n\tMothball Projects:\n"
                for proj in [a-z]*[a-z]; do
                    if [ -d $proj ]; then
                        printf "\t  *  $proj\n"
                    fi
                done
                unset proj
                echo 
            else
                printf "\nNo project was chosen.  Out to the UNIX wilderness you go!\n\n"
                #unset EE_PATH
                break
            fi
        done
        cd -
    else
        echo "$EE_PATH directory does not exist."
    fi
    export MYEE DVB_PATH DVB_PS1 
}  # end ee-login() function

# PRIVATE FUNCTION
_set-PS1() {
    if [ "`tty`" != "not a tty" ]; then
        dm-shelled-from-mumps -X 2> /dev/null && MUMPS="MUMPS"   || MUMPS=""
        [ -n "$DVB_PROJ" ] && DVB_PROJ2="[$DVB_PROJ]"            || DVB_PROJ2=""
        PS1='\h \033[7m$PWD\033[0m\012${DVB_PROJ2}${MUMPS}'
    fi
}


# some people expect ee-in, some ee-login
ee-in() { ee-login ; }
ee-out() { ee-logout ; }

export -f ee-login ee-logout _set-PS1 ee-in ee-out

############################################################
############################################################
# * * * * *  DON'T CHANGE BELOW HERE * * * * * * * * * * * *

[ -n "$TRACERC" ] && echo "Leaving /etc/profile.d/ee-profile.sh"
