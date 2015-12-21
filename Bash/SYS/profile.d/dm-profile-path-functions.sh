# call: dm-shell-add-to-path <dir> ["before" | "after" | "aftersbin" | "forcebefore"]
# If not su, default is to add before
# But if su, default is after sbin  unless set forcebefore
dm-shell-add-to-path() {
    idexe="/bin/id"
    grepexe="/bin/grep"
    egrepexe="/bin/egrep"
    sedexe="/bin/sed"
    (echo $PATH | $egrepexe  "(^|:)$1($|:)" &> /dev/null ) && return

    where="$2"
    [ -z "$where" ] && where="before"
    if $idexe | $grepexe "^uid=0(root)" > /dev/null ; then
        [ "$where" = "before" ] && where="aftersbin"
    fi

    #maybe, just maybe root doesn't actually have any sbin's in path
    if [ "$where" = "aftersbin" ] ; then
       if  ! `echo "$PATH" | $grepexe sbin &> /dev/null` ; then
          where="before"
       fi
    fi

   if [ "$where" = "after" ]; then
      PATH="$PATH:$1"
   elif [ "$where" = "aftersbin" ]; then
      local dir
      dir=$(echo $1 | $sedexe 's/\//\\\//g')
      # notice escaped all the /'s in dir so following command will work 
      PATH=$(echo "$PATH" | $sedexe "s/\(.*sbin\)\(:\{0,1\}\)/\1:$dir\2/")
   elif [ "$where" = "before" -o "$where" = "forcebefore" ]; then
      PATH=$1:$PATH
   fi
}

# call: DelFromPath <dir>
dm-shell-del-from-path() {
    local dir
    dir=$(echo $1 | sed 's/\//\\\//g;s/\./\\./g')
    PATH=$(echo "$PATH" | sed "s/^$dir:\{0,1\}//;s/:\{0,1\}$dir\$//;s/:$dir:/:/")
}
