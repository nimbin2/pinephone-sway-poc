#!/usr/bin/env sh

NOTIFFILE=/tmp/sxmo_notifications.tsv

#TODO: put calls here as well.
while true; do
	CHOICES="$(printf %b "$(cat $NOTIFFILE | cut -f1)"'\nClose Menu')"
	PICKED="$(echo "$CHOICES" | vis-menu -p "Notifs" -l 10)"
	ENTRY="$(grep -n "$PICKED" $NOTIFFILE | cut -f1 -d:)"

	echo "$PICKED" | grep "Close Menu" && exit 0
	
	#st -e tail -n9999 -f "$(sed -n $(echo $ENTRY)p $NOTIFFILE | cut -f2)"
	termite -e "less +G $(sed -n $(echo $ENTRY)p $NOTIFFILE | cut -f2)"
	exit 0
done
