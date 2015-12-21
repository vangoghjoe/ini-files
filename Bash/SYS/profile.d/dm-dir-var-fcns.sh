#
# Set of shell functions to work with temporarily useful, 'scratch' variables
# across sessions.
# Typically, the values are directories that you'll be referring to a lot for a
# day or two, but not forever.  The main utility of these functions are: 
#    1) easily set variables to directory names
#    2) the value of the variables will persist across sessions, unlike vars
#       just set at the commandline.
#
# For help and usages, source this file and run 'dm-shell-dir-vars-help'
#
# -- jlh 8/2005

dm-shell-dir-vars-help() {
echo "This is a collection of shell functions for setting and listing a set of shell variables, "
echo "typically storing the names of directories.  There are other ways of doing this,"
echo "these are merely for convenience.  The variable names and functions are stored in "
echo "a file called '.dm-dir-vars-data' in the users's home dir.  Each line in the file "
echo "defines one variable and is of the form:"
echo ""
echo "varname|value"
echo ""
echo "Blank lines and lines starting with '#' or ';' are ignored.The functions are:"
echo ""
echo " * dm-shell-dir-vars-add "
echo "    Add a variable and its value to the stored list."
echo "    This can be called in 3 ways:"
echo "      1\) dm-shell-dir-vars-add"
echo "          - sets the variable 'x' to the name of current dir"
echo "       2) dm-shell-dir-vars-add  VARNAME"
echo "          - sets variable named varname to name of current dir"
echo "       3) dm-shell-dir-vars-add  VARNAME  VALUE"
echo "         - sets variable nameed VARNAME to VALUE"
echo "    Eg: if cur dir is '/h1/xfer' then"
echo "      1) dm-shell-dir-vars-add  ==> \$x = \"/h1/xfer\""
echo "      2) dm-shell-dir-vars-add  myxfer  ==> \$myxfer = \"/h1/xfer\""
echo "      3) dm-shell-dir-vars-add  where  \"over there\" ==> \$where = \"over there\" "
echo ""
echo " * dm-shell-dir-vars-list"
echo "    List the names and values stored in '.dm-dir-vars-data'. NOTE: this is only for variables"
echo "    added with these functions, not all shell variables.  "
echo " "
echo " * dm-shell-dir-vars-source-all"
echo "    Sources all the vars in '.dm-dir-vars-data'.  Typically just called at dm-shell startup."
echo " "
echo " * dm-shell-dir-vars-edit"
echo "    Edit list of variables."
echo " "
echo " * dm-shell-dir-vars-unset-all"
echo "    Kills all the dir vars.  NOTE: Any single var can be 'killed' or unset with the "
echo "    shell command:"
echo "      unset VAR"
echo " "
echo "To make these easier to use, recommend setting up aliases like:"
echo "  alias dva=dm-shell-dir-vars-add"
echo "  alias dvl=dm-shell-dir-vars-list"
echo "  alias dve=dm-shell-dir-vars-edit"
echo ""
 } 
 
 
dm-shell-dir-vars-list() {
    local v d dirfil=~/.dm-dir-vars-data
    if [ ! -r "$dirfil" ]; then
        echo
        echo "Your variable file '$dirfil' is empty."
        echo "You can add variables using 'dm-shell-dir-vars-add'."
        echo 
        return 1
    fi
    echo
    printf "%-10s| Value\n" "Variable"
    printf -- "----------------------------------------\n"
    while read lin; do
        _parse-dir-var-rec && [ -z "$v" ] && continue
        printf "%-10s| %s\n" "$v" "$d"
    done < "$dirfil"
    echo 

}
dm-shell-dir-vars-unset-all() {
    local v d dirfil=~/.dm-dir-vars-data
    while read lin; do
        _parse-dir-var-rec && [ -z "$v" ] && continue
        unset "$v"
    done < "$dirfil"

}
dm-shell-dir-vars-source-all() {
    local dirfil=~/.dm-dir-vars-data
    [ ! -r "$dirfil" ] && return
    while read lin; do
        _parse-dir-var-rec && [ -z "$v" ] && continue
        eval export "$v"="\"$d\""
    done < "$dirfil"
}

dm-shell-dir-vars-edit() {
    local dirfil=~/.dm-dir-vars-data
    if [ ! -f "$dirfil" ]; then
        echo "The file '$dirfil' is empty, so there are no variables to delete."
        return 1
    fi

    echo "Variables are deleted permanently by modifying the file $dirfil."
    echo 
    echo "Each line in that file defines one variable, and is of the form"
    echo "varname|value"
    echo
    echo "Blanks lines, and lines starting with '#' or ';' are ignored."
    echo
    echo "In the future, there may be more of an interface for this, but for now ..."
    echo
    echo "Hit <return> to vim that file now and have this session's variables updated, or"
    echo -n "<Ctrl-C> to exit" 
    read  garbouge

    vim $dirfil
    dm-shell-dir-vars-unset-all
    dm-shell-dir-vars-source-all
}

dm-shell-dir-vars-add() {
    local dirfil=~/.dm-dir-vars-data
    if [ $# -eq 0 ]; then
        v="x";
        d=`pwd`;
    else
        if [ $# -eq 1 ]; then
            v="$1";
            d=`pwd`;
        else
            if [ $# -eq 2 ]; then
                v="$1";
                d="$2";
            else
                echo "usage: dm-shell-dir-vars-add [var] [dir]";
                echo "Add a variable and its value to the stored list."
                echo "This can be called in 3 ways:"
                echo "   1) dm-shell-dir-vars-add"
                echo "      - sets the variable 'x' to the name of current dir"
                echo "   2) dm-shell-dir-vars-add  VARNAME"
                echo "      - sets variable named varname to name of current dir"
                echo "   3) dm-shell-dir-vars-add  VARNAME  VALUE"
                echo "      - sets variable nameed VARNAME to VALUE"
                echo "Eg: if cur dir is '/h1/xfer' then"
                echo "   1) dm-shell-dir-vars-add  ==> \$x = \"/h1/xfer\""
                echo "   2) dm-shell-dir-vars-add  myxfer  ==> \$myxfer = \"/h1/xfer\""
                echo "   3) dm-shell-dir-vars-add  where  \"over there\" ==> \$where = \"over there\" "
                echo ""
                return
            fi;
        fi;
    fi;
    if ! (echo "$v" | grep "^[_A-Za-z][_A-Za-z0-9]*$" &> /dev/null) ; then 
        echo "'$v' isn't a valid variable name ... sorry."
        return
    fi
    eval export "$v"="\"$d\""
    #echo -e "\$$v set to '$d'\n"
    #echo -e "\nOK: \$$v = '$d'\n"
    #echo -e "OK: \033[7m$v = $d\033[0m"
    echo -e "--> \$$v = $d"

    [ ! -f "$dirfil" ] && touch "$dirfil"
    \mv "$dirfil" "$dirfil"~
    awk -F\| -v v="$v" -v d="$d" '

BEGIN {
    firsttog=1
}

{
   if ($0 ~ /^#/ || $0 ~ /^;/ || $0 ~ /^[   ]*$/) {
      print $0
      next
   }
   else {
      if (firsttog) {
         firsttog=0
         printf("%s|%s\n",v,d)
      }
      if ($1 != v) {
         printf("%s|%s\n",$1,$2)
      }
   }
}

END {
   # handle empty file
   if (firsttog) { printf("%s|%s\n",v,d) }
} 

    ' "$dirfil"~  > "$dirfil" # end of awk

} # end of fcn


# this function isn't intended to be called direclty by the user,
# but by the "public" functions in this set
_parse-dir-var-rec() {
    v=${lin%%|*}
    d=${lin##*|}
    (echo "$v" | /bin/egrep "(^#|^;|^[ 	]*$)" > /dev/null 2>&1 )  && v=""
    #(echo "$v" | /bin/egrep "^(#|;)" > /dev/null 2>&1 )  && v=""
}

export -f dm-shell-dir-vars-unset-all dm-shell-dir-vars-source-all
export -f dm-shell-dir-vars-list dm-shell-dir-vars-add 
export -f dm-shell-dir-vars-edit _parse-dir-var-rec
