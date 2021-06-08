#!/usr/bin/env sh

#wasopen="$(sxmo_keyboard.sh isopen && echo "yes")"
wasopen="yes"

#swayphone_keyboard_show
OUTPUT="$(cat | wofi --width="90%" --height="54%" -S dmenu "$@")"
#[ -z "$wasopen" ] && swayphone_keyboard_hide
echo "$OUTPUT"
