#!/bin/bash

if (nmcli d | grep wlan0 | grep -q connec); then
       	nmcli radio wifi off
elif (nmcli d | grep wlan0 | grep -q unavailable); then
	nmcli radio wifi on 
fi
