#@IgnoreInspection BashAddShebang
# by doing eval $(handle_funcname.inc.sh) we avoid the need to create another function
# which would be registered in $FUNCNAME (sh)
SH="$(readlink /proc/$$/exe)"
CURRENT_FUNCTION_NAME_INDEX=1;
case "$SH" in
  /usr/bin/zsh)
    FUNCTIONS=( ${funcstack[*]} );
    # it seems that in zsh the first item in an array starts with 1
    CURRENT_FUNCTION_NAME_INDEX=3;
    ;;
  /usr/bin/sh)
    # but in sh it starts with 0
    FUNCTIONS=( ${FUNCNAME[*]} );
    ;;
  /usr/bin/bash)
    FUNCTIONS=( ${FUNCNAME[*]} );
    ;;
  *)
    err "Please implement a handling function to use with $SH shell";
    ;;
esac
