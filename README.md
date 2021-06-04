Original Readme: https://github.com/Dejvino/pinephone-sway-poc/blob/master/README.md


# pinephone-sway-nimbin
some sxmo scripts badly modded to work with sway on the PinePhone
https://sr.ht/~mil/Sxmo/

I never learned how to write good code. Whatever you do you do on your own risk. Please read through all scripts before using them. Never execute a command you don't know what it's doing.


I'm using Dejvino's sway poc: https://github.com/Dejvino/pinephone-sway-poc

And dreemurrs Arch linux distro: https://github.com/dreemurrs-embedded/Pine64-Arch/releases
So maybe some scripts just work with thoose in the backpack..

Actually the dialer and sms script work with vis-menu, sou you'll get a terminal window with a list of your contacts (~/.config/sxmo/contacts.tsv) to choose.

### Make file
Please read through the Make file and change it to your needs.
Make sure to install Dejvino's sway poc first.

<table>
   <thead><th>Command</th><th>Hint</th></thead>
   <tbody>
	   <tr><td>make install</td><td>1. Install required packages for arch build</br>2. Copy all required scripts to system.</br>3. Create a diff file if the file existed on system in "diff/$(DATE_YYMMDD)/"</br>4. Enable required services</td></tr>
	   <tr><td>make fetch</td><td>1. Copy all required scripts from system to this directory.</br>2. Create a diff file if the file exist "diff/$(DATE_YYMMDD)/"</td></tr>
   </tbody>
</table>



### Required packages
If you just install whats listed here it's your problem^^
```
sudo pacman --needed -Sy alsa-utils bc rsync bash-completion dbus-glib dunst  evemu ffmpeg firefox qutebrowser inotify-tools jq libnotify mako python termite vis vlc font-noto noto-fonts-emoji noto-fonts-extra
sudo pacman --needed -Sy noto-fonts-emoji poppler pulseaudio megapixels calcurse cmus telegram-desktop
```
You should edit your sway config:
```
# ~/.config/sway/config

...
exec mako
```

### Auto login
If you use the encrypted arch version you can use an auto login tty and start sway from the .bash_profile over the sxmo_xinit.sh script, that should also config some maybe needed main stuff..

```
# /etc/systemd/system/getty@tty1.service.d/override.conf
# replace username with your username

[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin username --noclear %I $TERM
```


```
# ~/.bash_profile 

if [ -z $DISPLAY ] && [ "$(tty)" == "/dev/tty1" ]; then
   exec sxmo_xinit.sh
fi
```

### Set sim pin
To get asked for sim pin after login edit your sway config file
```
# ~/.config/sway/config
...
exec '[[ "$(swayphone_simstate)" == "registered" ]] && notify-send -t 5000 "Sim is registered" || termite -e swayphone_unlocksim'
```

### Modemmonitor and Notificationsmonitor
Enable sway specific daemons like recommended in the wiki
https://wiki.archlinux.org/title/Sway#Manage_Sway-specific_daemons_with_systemd

move the services/sxmo_modemmonitor.service snd services/sxmo_notifications.service to ~/.config/systemd/user/sxmo_modemmonitor.service

and enable Modemmonitor:
```
systemctl --user enable --now sxmo_modemmonitor.service
```

and enable Notificationsmonitor:
```
systemctl --user enable --now sxmo_notifications.service
```

### Autorotate
enable sway specific daemon ( check "Modemmonitor and Notificationsmonitor") </br>
move the File services/swayphone_autorotate.service file to ~/.config/systemd/user/</br>
move the File swayphone/swayphone_autorotate file to /usr/local/bin/swayphone_autorotate</br>
enable the Service:
```
systemctl --user enable --now swayphone_autorotate.service
```
you can also set the direction manually by entering something like:
```
swayphone_autorotate rotate_270
```

### ModemMonitor
I was having problems with mmcli commands, as they needed sudo rights.</br>
I got rid of the problem by doing two things, i think just one is doing the trick, idk wich one...

1: add /etc/polkit-1/localauthority/50-local.d/ModemManager.pkla
```
# /etc/polkit-1/localauthority/50-local.d/ModemManager.pkla

[ModemManager]
Identity=unix-user:*
Action=org.freedesktop.ModemManager1.*
ResultAny=yes
ResultActive=yes
ResultInactive=yes
```
2: rename or remove /usr/share/dbus-1/system-services/org.freedesktop.ModemManager1.service

### Network scripts
To get the togglewifi.sh and togglemobileconnection.sh script work you should add an entry in your sudoers file (dont do shit over there and take care as you gonna edit it with a vi editor)
```
sudo visudo
```
```
YOURUSERNAME ALL=NOPASSWD:/usr/local/bin/togglemobileconnection.sh
YOURUSERNAME ALL=NOPASSWD:/usr/local/bin/togglewifi.sh
```

### Gsm connection
To get the togglemobileconnection.sh script to work you need to add a gsm connection called "mobileconnection" (or rename "mobileconnection" in the script)</br>
some hints you can find here: https://unix.stackexchange.com/questions/113975/configure-gsm-connection-using-nmcli


### Flash light
sxmo_flashtoggle.sh not working? add it to the sudoers file,...

### German keyboard
rename the file de.yaml in the "other" directory to us.yaml and place it in the following two directories. (it switched sometimes back to the default layout if you just place it in the ~/config dir like recommended at the squeekboard git)</br> 
~/.config/squeekboard/keyboards/ </br>
~/.local/share/squeekboard/keyboards/

### Add a contact
edit or add the file ~/.config/sxmo/contacts.tsv and enter a contact like
```
+49000000000 My Contact
```

### Firefox mobile friendly
Clone postmarketOS mobile-config-firefox git repository and install it

```
git clone https://gitlab.com/postmarketOS/mobile-config-firefox.git
cd mobile-config-firefox/
sudo make DISTRO=aarch64 install
```

### Main menu
Make sure you got the  the waybar config file at the right direction.
Make sure you got the termite config file at the right direction
```
# move waybar config file
mv waybar/config0 ~/.config/waybar/config_0
# move termite config file
mkdir -p ~/.config/termite
mv other/config_menu .config/termite/config_menu
```
Add the following line to your sway config file to alwas open the dialog menu sticky and fullscreen.
```
# ~/.config/sway/config
...
for_window [app_id="^mainMenu$"] {
	floating enable
	border pixel 0
	sticky enable
}
```

