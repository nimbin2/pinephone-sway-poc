#!/usr/bin/env sh
notify() {
	VOL="$(
		amixer get "$(sxmo_audiocurrentdevice.sh)" | 
		grep -oE '([0-9]+)%' |
		tr -d ' %' |
		awk '{ s += $1; c++ } END { print s/c }'  |
		xargs printf %.0f
	)"
	dunstify --timeout=800 -i 0 -u normal -r 998 "♫ $VOL"
}

up() {
	amixer set "$(sxmo_audiocurrentdevice.sh)" 1+
	notify
}
down() {
	amixer set "$(sxmo_audiocurrentdevice.sh)" 1-
	notify
}
setvol() {
	amixer set "$(sxmo_audiocurrentdevice.sh)" "$1"
	notify
}
mute() {
	amixer set "$(sxmo_audiocurrentdevice.sh)" mute
	notify
}
unmute() {
	amixer set "$(sxmo_audiocurrentdevice.sh)" unmute
	notify
}

togglemute() {
   touch /tmp/audiocurrentdevice
   STATE=$(sxmo_audiocurrentdevice.sh)
   LASTSTATE=$(cat /tmp/audiocurrentdevice)

   echo $STATE
   if [[ -n $STATE ]] && [[ "$STATE" != "None" ]]; then
      echo "111"
      echo "$(sxmo_audiocurrentdevice.sh)" > /tmp/audiocurrentdevice
      mute 
   elif [[ -z "$LASTSTATE" ]]; then
      echo "222"
         notify-send -t 1600 "Select output device" 
   elif [[ "$STATE" == "None" ]]; then
      echo "333"
      cat /tmp/audiocurrentdevice | grep -wq "None" &&
         sxmo_audioout.sh $(cat /tmp/audiocurrentdevice) && unmute
   fi
   notify-send -t 1200 "Audio: $(sxmo_audiocurrentdevice.sh)"
}

"$@"
