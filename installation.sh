#!/bin/bash

menu(){
	NORMAL=`echo "\033[m"`
    	MENU=`echo "\033[36m"` #Blue
    	NUMBER=`echo "\033[33m"` #yellow
    	FGRED=`echo "\033[41m"`
   	RED_TEXT=`echo "\033[31m"`
    	ENTER_LINE=`echo "\033[33m"`
	RED='\033[01;31m' # bold red
	echo -e "${MENU}***********************************************${NORMAL}"
	echo -e " ----------------------------------------------- "
	echo -e "${RED_TEXT} >>> Only For Debian Based Distros <<< ${NORMAL} "
	echo -e " ----------------------------------------------- "
	echo -e "${MENU}**${NUMBER} 1)${MENU} Install Atom Text Editor ${NORMAL}"
	echo -e "${MENU}**${NUMBER} 2)${MENU} Install Sublime Text Editor ${NORMAL}"
	echo -e "${MENU}**${NUMBER} 3)${MENU} Install Spotify ${NORMAL}"
	echo -e "${MENU}**${NUMBER} 4)${MENU} Control Fan-Speed ${NORMAL}"
	echo -e "${MENU}**${NUMBER} 5)${MENU} Swap Allocation (Default 2GB) ${NORMAL}"
	echo -e "${MENU}**${NUMBER} 6)${MENU} Reconfigure SSH's Default Key ${NORMAL}"
	echo -e "${MENU}**${NUMBER} 7)${MENU} Enable SSH ${NORMAL}"
	echo -e "${MENU}**${NUMBER} 8)${MENU} Install Compton Compositor ${NORMAL}"
	echo -e "${MENU}**${NUMBER} 9)${MENU} Install Compiz Compositor ${NORMAL}"
	echo -e "${MENU}***********************************************${NORMAL}"
	echo -e "${ENTER_LINE} Enter Your Option ${RED_TEXT} To Exit Press Enter ${NORMAL}"
	read opt
}

function option(){
	COLOR='\033[01;31m' # bold red
    	RESET='\033[00;00m' # normal white
    	MESSAGE=${@:-"${RESET}No Input Found..."}
    	echo -e "${COLOR}${MESSAGE}${RESET}"
}

function atom_install(){
	wget -qO - https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -
	sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
    	apt update
	apt install atom -Vy
}

function sublime_install(){
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
	sudo apt-get install apt-transport-https
	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
	sudo apt update
	sudo apt install sublime-text
}

function spotify_install(){
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90 2EBF997C15BDA244B6EBF5D84773BD5E130D1D45
   	echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
    	apt update
	apt install spotify-client -Vy
}

function fan_speed(){
	whiptail --title "Attention Required" --msgbox "Please Proceed Accordingly... Inputs are required manually..." 8 78
	apt install lm-sensors fancontrol -Vy
	sensors-detect
	whiptail --title "Check Configurotion" --msgbox "Check You System Sensors before you again go with Inputs..." 8 78
	sensors
	sensors | grep fan
	service module-init-tools restart
	service kmod start
	echo "--------------------------------------"
	echo "Do Change You Fan Interval As You Like"
	echo "--------------------------------------"
	pwmconfig
	sensors -s
	sensors
}

function swap_allocate(){
	fallocate -l 2G /swapfile
    	chmod 600 /swapfile
    	mkswap /swapfile
	echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab
}

function reconfigure_ssh(){
	cd /etc/ssh/
	dpkg-reconfigure openssh-server
}

function enable_ssh(){
	apt-get install openssh-server -Vy
    	update-rc.d -f ssh remove
    	update-rc.d -f ssh defaults
    	cd /etc/ssh/
    	mkdir insecure_old
    	mv ssh_host* insecure_old
    	dpkg-reconfigure openssh-server
    	whiptail --title "Modification required" --msgbox " Search for PermitRootLogin and replace \nwithout-password\nto\nyes\n " 8 78
    	nano /etc/ssh/sshd_config
    	service ssh restart
    	update-rc.d -f ssh enable 2 3 4 5
    	service ssh status
	service ssh start
}

function compton-compositor(){
	apt install compton -Vy
	whiptail --title "Move A File" --msgbox "Move compton.conf file to /home/$USER/.config " 8 78
	whiptail --title "Start Up Required" --msgbox "Add >> compton << At Start Up Application Menu" 8 78
}

function compiz-compositor(){
	apt install compiz compiz-plugins compizconfig-settings-manager -Vy
	whiptail --title "Start Up Required" --msgbox "Add >> compiz --replace << At Start Up Application Menu" 8 78
}

function bash_aliases(){
	echo " --------------------------------------------------------------------- "
	echo "| Don't Forget to use bash_aliases for better terminal use experience |"
	echo " --------------------------------------------------------------------- "
}
function init_function() {
	clear
	menu
	while [ $opt != '' ]
	do
		if [[ $opt = "" ]]; then
			exit;
		else
			case $opt in
				1)clear;
					option "Installing Atom Text Editor" ;
					atom_install;
					option "Installed Atom Text Editor" ;
					bash_aliases;
					exit;
					;;
				2)clear;
					option "Installing Sublime Text Editor" ;
					sublime_install;
					option "Installation Completed" ;
					bash_aliases;
					exit;
					;;
				3)clear
					spotify_install;
					option "Installed Spotify" ;
					bash_aliases;
					exit;
					;;
				4)clear;
					fan_speed;
					option "Manual Configuration Required" ;
					bash_aliases;
					exit;
					;;
				5)clear;
					swap_allocate;
					option "Allocated Swap" ;
					bash_aliases;
					exit;
					;;
				6)clear;
					reconfigure_ssh;
					option "Configured SSH Key" ;
					bash_aliases;
					exit;
					;;
				7)clear;
					enable_ssh;
					option "SSH Enabled" ;
					bash_aliases;
					exit;
					;;
				8)clear;
					compton-compositor;
					option "Compton Installed, Add To Startup" ;
					bash_aliases;
					exit;
					;;
				9)clear;
					compiz-compositor;
					option "Compiz Is Now Installed Add To Startup" ;
					bash_aliases;
					exit;
					;;
				x)exit;
					;;
				q)exit;
					;;
				\n)exit;
					;;
				*)clear;
					option "Pick Option Form Menu Only" ;
					menu;
					;;
			esac
		fi
	done
}

if [ `whoami` == "root" ]; then
	init_function;
else
	echo "HEY !!! Run This Script With Root Priviledge " ;
fi
