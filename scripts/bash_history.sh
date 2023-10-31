#!/bin/bash

#------------------------------------------------------------------------------
#
#     Record bash interactive command history in an sqlite database
#     Requires: https://github.com/rcaloras/bash-preexec
#
#------------------------------------------------------------------------------

import_bash_history()
{
   pushd "$BASH_HOME" || exit
   sqlite3 bash_history.db <<EOS

.read bash_history.sql

.headers off
.mode list
.output bash_history.txt

SELECT command FROM commands WHERE return_val=0 group by command;
EOS

   # remove blank lines and update the bash history file
   awk 'NF' bash_history.txt > .bash_history
   popd || exit
}

preexec()
{  
   last_command="$this_command"; this_command="$BASH_COMMAND"
}

precmd()
{  
   return_code=$?
   if [[ -n $last_command ]]; then

   printf -v datetime "%(%FT%T)T"
   # in sqlite, single quotes (') inside literal strings must be doubled ('')
   q="'"; printf -v cmd "%s\n" "${last_command//$q/$q$q}"
   printf -v values "(\'%s\',%d,%d,\'%s\')" "$datetime" $$ "$return_code" "$cmd"
   # printf "%s\n" "$values"
   sqlite3 "$BASH_HOME"/bash_history.db "INSERT INTO commands VALUES $values" 2> /dev/null
   last_command=""

   fi
}

# bash-preexec.sh installs a debug trap and updates PROMPT_COMMAND

[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh

if [[ -n "${bash_preexec_imported:-}" ]]; then
   echo "bash-preexec is loaded."
fi

# To start each interactive bash session with a clean history,
# re-populate the bash history flle and load the history list.
history -c
import_bash_history
history -r
