alias ls='ls --color=always -rthla'
function apt-updater {
	sudo apt update &&
	sudo apt full-upgrade -Vy &&
	sudo apt autoremove --purge -y &&
	sudo apt autoclean &&
	sudo apt clean
	}
