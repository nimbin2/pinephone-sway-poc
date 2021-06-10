Original Readme: https://github.com/Dejvino/pinephone-sway-poc/blob/master/README.md


# pinephone-sway-nimbin
some sxmo scripts badly modded to work with sway on the PinePhone
https://sr.ht/~mil/Sxmo/

I never learned how to write good code. Whatever you do you do on your own risk. Please read through all scripts before using them. Never execute a command you don't know what it's doing.


I'm using Dejvino's sway poc: https://github.com/Dejvino/pinephone-sway-poc

And dreemurrs Arch linux distro: https://github.com/dreemurrs-embedded/Pine64-Arch/releases
So maybe some scripts just work with thoose in the backpack..

Actually the dialer and sms script work with vis-menu, sou you'll get a terminal window with a list of your contacts (~/.config/sxmo/contacts.tsv) to choose.

### Installation
#### Install encrypted Arch Linux arm 
```
git clone https://github.com/dreemurrs-embedded/archarm-mobile-fde-installer.git
cd archarm-mobile-fde-installer && ./installer.sh
```
Choose 2) Barebone as environement</br>
Choosing f2fs as filesystem may break your sd card ( what i#ve read in a chat,- i'm using it and never had a problem)</br>
Make sure you select the right sd card (compare size ) and you enter the right path (something like /dev/mmcblk0 )


#### Install SwayPinephone
Insert the sd Card.</br>
Connect a keyboard via an usb-c hub ( or you set up bluetooth)</br>
Set your keyboard layout ```localectl set-keymap de```</br>
Connect to ethernet with the hub or to wifi by entering ```sudo wifi-menu```</br>
Install required packages ```sudo pacman -Sy git make```</br>

You may want to change the make file to your needs (like changing the package manager if you dont use Arch Linux).
```
git clone --recursive https://github.com/nimbin2/pinephone-sway-poc.git
cd pinephone-sway-poc && make install
```

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
Check out the Makefile, packages are defined by the variable REQUIRED_PACKAGES*

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

### Flash light
sxmo_flashtoggle.sh not working? add it to the sudoers file,...

### German keyboard
In home/config/squeekboard/keyboards/ you can find the german layout (needs to be called us.yaml as it doesnt work otherwise).
I recommend to use that one as it gives more options to use a terminal. It is easy to modify the layout and switch keys like y=z or remap the german umlaute. The file souhld be placed in the following two directories, as just having it in the .config dir like recommended from the squeekboard team sometimes breaks the layout.</br>
~/.config/squeekboard/keyboards/ </br>
~/.local/share/squeekboard/keyboards/

### Add a contact
edit or add the file ~/.config/sxmo/contacts.tsv and enter a contact like
```
+49000000000   My Contact
```

### Firefox mobile friendly
Clone postmarketOS mobile-config-firefox git repository and install it

```
git clone https://gitlab.com/postmarketOS/mobile-config-firefox.git
cd mobile-config-firefox/
sudo make DISTRO=aarch64 install
```

### Main menu
The main menu works with wofi dmenu.</br>
Check out the swayphone_appmenu script.</br>
If touch does not work for you, imagine your finger is a thin needle and double tap the option^^

