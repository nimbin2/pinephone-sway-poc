#!/bin/bash

if (nmcli d | grep gsm | grep -q disconnected); then
	nmcli radio wifi off &&
	nmcli connection up mobileconnection
elif (nmcli d | grep gsm | grep -q connect); then
	nmcli connection down mobileconnection
fi
