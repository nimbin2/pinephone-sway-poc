#!/usr/bin/env sh

# TERMMODE=$([ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] && echo "true")
TERMMODE="true"
if [ "$TERMMODE" = "true" ]; then
	exec vis-menu -i -l 10
fi

# wasopen="$(sxmo_keyboard.sh isopen && echo "yes")"

# squeekboard
#OUTPUT="$(cat | bemenu "$@")"
#exitcode=$?
# [ -z "$wasopen" ] && pkill -9 squeekboard
# pkill -9 squeekboard
#echo "$OUTPUT"
#exit $exitcode
