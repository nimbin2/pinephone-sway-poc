HOME_PATH=~
BIN_PATH=/usr/local/bin

RED=\033[1;31m
YELLOW=\033[1;33m
GREEN=\033[0;32m
NC=\033[0m

REQUIRED_PACKAGES=linux sway waybar wofi swaylock swayidle squeekboard bash dialog tzdata htop pavucontrol alsa-utils bc bash-completion dbus-glib dunst  evemu ffmpeg inotify-tools jq libnotify mako python termite vis vlc 
REQUIRED_PACKAGES_USER_COMPONENTS=networkmanager htop pavucontrol
REQUIRED_PACKAGES_BUILD_TOOLS=base-devel git make gcc meson ninja cargo linux-headers libinput udev
REQUIRED_PACKAGES_ADD=noto-fonts noto-fonts-emoji noto-fonts-extra poppler firefox qutebrowser pulseaudio megapixels calcurse cmus telegram-desktop

INSTALL_PACMAN_Y=sudo pacman --needed -Sy
INSTALL_PACMAN=sudo pacman --needed -S

FILES_SWAY=usr/local/bin/swayphone_* home/config/sway/config home/config/swayphone/menuoptions* 
FILES_WAYBAR=home/config/waybar/config*
FILES_WOFI=home/config/wofi/style.css
FILES_HTOP=home/config/htop/*
FILES_SXMO=usr/bin/sxmo_* usr/share/sxmo/alsa/default_alsa_sound.conf
FILES_NETWORK=usr/local/bin/togglewifi.sh usr/local/bin/togglemobileconnection.sh
FILES_TERMITE=home/config/termite/config_menu
FILES_KEYBOARD=home/config/squeekboard/keyboards/us* home/local/share/squeekboard/keyboards/us*
FILES_SERVICES=home/config/systemd/user/sxmo_* home/config/systemd/user/swayphone_autorotate.service home/config/systemd/user/sway-session.target  
FILES_LIGHTDM=usr/share/wayland-sessions/*
FILES_FONTCONFIG=home/config/fontconfig/conf.d/30-family-defaults.conf

help:
	@echo " Available Actions:"
	@echo "	install	- builds & copies files into the user's home and system"
	@echo "	fetch	- copies files from the system into this build directory"
	@echo "	help	- this!"
	@echo "	help_install	- list what is done if doing \"make install\""



###
# HELP
###
help_install: 
	@echo -e "copys all files to the system using the copyfile.sh script"
	@echo -e "	If file exist on system create a diff file in diff/DATE_YY_MM_DD/FILENAME"
	@echo -e "	Log file is at diff/DATE_YY_MM_DD/diff.log"

make_wait: 
	$(info $(shell echo -e "${GREEN}Enter to continue:${NC}"))
	$(info $(shell read))

help_install_packages:
	@echo -e "${GREEN}install_packages:${NC}"
	@echo -e "REQUIRED_PACKAGES:"
	@echo -e "${YELLOW}${INSTALL_PACMAN_Y}${NC} ${REQUIRED_PACKAGES}"
	@echo -e "REQUIRED_PACKAGES_ADD:"
	@echo -e "${YELLOW}${INSTALL_PACMAN}${NC} ${REQUIRED_PACKAGES_ADD}"

###

# INSTALL - USER
###

install: install_packages install_sway install_waybar install_wofi install_htop install_lightdm install_pptk install_lisgd install_sxmo installl_network install_termite install_keyboard install_keyboard install_fontconfig

install_packages: help_install_packages make_wait
	$(INSTALL_PACMAN_Y) ${REQUIRED_PACKAGES}
	$(INSTALL_PACMAN) ${REQUIRED_PACKAGES_USER_COMPONENTS}
	$(INSTALL_PACMAN) ${REQUIRED_PACKAGES_BUILD_TOOLS}
	$(INSTALL_PACMAN) ${REQUIRED_PACKAGES_ADD}

install_sway:
	@echo -e "${GREEN}Run install_sway${NC}"
	chmod go+rx usr/local/bin/*
	./copyfile.sh "install" "${FILES_SWAY}"

install_waybar:
	@echo -e "${GREEN}Run install_waybar${NC}"
	./copyfile.sh "install" "${FILES_WAYBAR}"

install_wofi:
	@echo -e "${GREEN}Run install_wofi${NC}"
	./copyfile.sh "install" "${FILES_WOFI}"

install_htop:
	@echo -e "${GREEN}Run install_htop${NC}"
	./copyfile.sh "install" "${FILES_HTOP}"


install_lightdm:
	@echo -e "${GREEN}Run install_lightdm${NC}"
	./copyfile.sh "install" "${FILES_LIGHTDM}"

install_pptk:
	@echo -e "${GREEN}Run install_pptk${NC}"
	cd pinephone-toolkit && meson build 
	sudo ninja -C pinephone-toolkit/build
	sudo ninja -C pinephone-toolkit/build install

install_lisgd:
	@echo -e "${GREEN}Run install_lisdg${NC}"
	cd lisgd && git fetch origin && git reset --hard 877beea2738df5f3a99da3f4e2ab5442b92baa80
	cd lisgd && git apply ../patches/lisgd.patch
	cd lisgd && make
	sudo cp lisgd/lisgd /usr/local/bin/

install_sxmo:
	@echo -e "${GREEN}Run install_sxmo${NC}"
	./copyfile.sh "install" "${FILES_SXMO}"

installl_network:
	@echo -e "${GREEN}Run installl_network${NC}"
	./copyfile.sh "install" "${FILES_NETWORK}"

install_termite:
	@echo -e "${GREEN}Run install_termite${NC}"
	./copyfile.sh "install" "${FILES_TERMITE}"

install_keyboard:
	@echo -e "${GREEN}Run install_keyboard${NC}"
	./copyfile.sh "install" "${FILES_KEYBOARD}"

install_fontconfig:
	@echo -e "${GREEN}Run install_keyboard${NC}"
	./copyfile.sh "install" "${FILES_FONTCONFIG}"

install_services:
	@echo -e "${GREEN}Run install_services${NC}"
	./copyfile.sh "install" "${FILES_SERVICES}"
	systemctl --user --now enable sxmo_modemmonitor
	systemctl --user --now enable swayphone_autorotate
	systemctl --user --now enable sxmo_notifications

###
# FETCH
###
fetch: fetch_sway fetch_waybar fetch_wofi fetch_sxmo fetch_services fetch_termite fetch_network fetch_keyboard fetch_fontconfig

fetch_sway:
	./copyfile.sh "fetch" "${FILES_SWAY}"

fetch_waybar:
	./copyfile.sh "fetch" "${FILES_WAYBAR}"

fetch_wofi:
	./copyfile.sh "fetch" "${FILES_WOFI}"

fetch_sxmo:
	./copyfile.sh "fetch" "${FILES_SXMO}"

fetch_services:
	./copyfile.sh "fetch" "${FILES_SERVICES}"

fetch_network:
	./copyfile.sh "fetch" "${FILES_NETWORK}"

fetch_termite:
	./copyfile.sh "fetch" "${FILES_TERMITE}"

fetch_keyboard:
	./copyfile.sh "fetch" "${FILES_KEYBOARD}"

fetch_fontconfig:
	./copyfile.sh "fetch" "${FILES_FONTCONFIG}"

