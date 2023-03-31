#!/bin/bash
# Clean environment setup for a new Debian setup
# Can be used both as a manual guide and as a script

GREEN='\033[0;32m'
NC='\033[0m'
BRIGHTRED='\e[38;5;160m'
DIRTELEGRAM='/opt/telegram'
DIRSYNOLOGY='/usr/share/doc/synology-drive'
VMWARE='/etc/vmware'


header () {
    echo "-----------------------------------------------------------------------------------"
    echo -e "${BRIGHTRED}                       STARTING DESKTOP ENVIRONMENT SETUP           ${NC}"
    echo "-----------------------------------------------------------------------------------"
    echo -e "${GREEN}[-] The DENVCORE tool will:${NC}\n    + update the operating system\n    + install all required packages\n    + configure and harden the operating system\n    + cleanup any installation unnecesary packages\n"
    echo -e "${GREEN}[-] TO EXECUTE SPECIFIC FUNCTIONS VIA TERMINAL CHECK EXAMPLE BELLOW:${NC}\n    > source ./env_setup_v0.9.sh && header && update && install && cleanup && footer"
    echo "-----------------------------------------------------------------------------------"
}


update () {
	# >> OS Update
	echo -e "\n${BRIGHTRED}[01] Updating Operating System${NC}"
	echo "-----------------------------------------------------------------------------------"
	echo -e "Update in progress. Please wait..."
	sudo apt --yes update &>/dev/null && sudo apt --yes upgrade &>/dev/null
}


install () {
	echo "-----------------------------------------------------------------------------------" 
	echo -e "\n${BRIGHTRED}[02] Installing Packages${NC}" 
	echo "-----------------------------------------------------------------------------------" 
	
	# Installing general packages
	echo -e "[01] - Installing basic packages:\n \
	+ ${GREEN} whois${NC}\n \
	+ ${GREEN} vlc${NC}\n \
	+ ${GREEN} curl${NC}\n \
	+ ${GREEN} deluge${NC}\n \
	+ ${GREEN} tree${NC}\n \
	+ ${GREEN} nmap${NC}\n \
	+ ${GREEN} python3${NC}\n \
	+ ${GREEN} g++${NC}\n \
	+ ${GREEN} libssl-dev${NC}\n \
	+ ${GREEN} wireguard${NC}\n \
	+ ${GREEN} resolvconf${NC}\n \
	+ ${GREEN} terminator${NC}\n  \
	+ ${GREEN} signal${NC}\n \
	+ ${GREEN} visual code${NC}\n \
	+ ${GREEN} 7Zip${NC}\n \
	+ ${GREEN} net tools${NC}\n \
	+ ${GREEN} moreutils${NC}\n \
	+ ${GREEN} git${NC}\n \
	+ ${GREEN} wget${NC}\n \
	+ ${GREEN} php-cgi${NC}\n \
	+ ${GREEN} php${NC}\n \
	"
	sudo apt --yes install whois vlc curl deluge tree nmap python3 g++ libssl-dev wireguard resolvconf terminator p7zip-full p7zip-rar net-tools moreutils git wget php-cgi php &>/dev/null
	sudo snap install signal-desktop &>/dev/null
	sudo snap install code --classic &>/dev/null


	echo -e "[02] - Installing packages not in APT repo:"
	# >> KeepassX install
	PKG_OK0=$(dpkg-query -W --showformat='${Status}\n' keepassx | grep "install ok installed")

	
	if [ "" == "$PKG_OK0" ]; then
	  echo -e "        + hecking for ${GREEN}KeepassX${NC}: ${BRIGHTRED}no package found${NC}, installing ${GREEN}keepassx${NC}:\n"
	  sudo apt --yes install keepassx
	 else
	 	echo -e "        + Checking for ${GREEN}KeepassX${NC}: install ok installed"
	fi
	sleep 1


		# >> Telegram install
	if [ ! -d "$DIRTELEGRAM" ]; then
	  echo -e "        + Checking for ${GREEN}Telegram${NC}: ${BRIGHTRED}no package found${NC}, installing ${GREEN}telegram${NC}:\n"
	  wget https://telegram.org/dl/desktop/linux/tsetup.*.tar.xz -O ~/Documents/telegram.tar.xz
	  tar xvf ~/Documents/telegram.tar.xz -C ~/Documents/
	  sudo mv ~/Documents/Telegram /opt/telegram
	  sudo ln -s /opt/telegram/Telegram /usr/local/bin/telegram
	  rm ~/Documents/telegram.tar.xz
	else
		echo -e "        + Checking for ${GREEN}Telegram${NC}: install ok installed"
	fi
	sleep 1



		# >> Sublime install
	PKG_OK9=$(dpkg-query -W --showformat='${Status}\n' sublime-text 2>/dev/null |grep "install ok installed")

	if [ "" == "$PKG_OK9" ]; then
	  echo -e "        + Checking for ${GREEN}Sublime${NC}: ${BRIGHTRED}no package found${NC}, installing ${GREEN}sublime-text${NC}:\n"
	  wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
	  echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
	  sudo apt update
	  sudo apt --yes install sublime-text
	else
		echo -e "        + Checking for ${GREEN}Sublime${NC}: install ok installed"
	fi
	sleep 1


		# >> Synology Drive Client install
	if [ ! -d "$DIRSYNOLOGY" ]; then
	  echo -e "        + Checking for ${GREEN}SynologyDriveClient${NC}: ${BRIGHTRED}no package found${NC}, installing ${GREEN}SynologyDriveClient${NC}:\n"
	  wget https://global.download.synology.com/download/Tools/SynologyDriveClient/2.0.2-11076/Ubuntu/Installer/x86_64/synology-drive-client-11076.x86_64.deb -O ~/Documents/syndrive.deb
	  sudo dpkg -i ~/Documents/syndrive.deb
	  rm ~/Documents/syndrive.deb
	else
		echo -e "        + Checking for ${GREEN}SynologyDriveClient${NC}: install ok installed"
	fi
	sleep 1


		# >> VMware Player install
	if [ ! -d "$VMWARE" ]; then
	  echo -e "        + Checking for ${GREEN}VMware${NC}: ${BRIGHTRED}no package found${NC}, installing ${GREEN}VMware${NC}:\n"
	  wget https://download3.vmware.com/software/player/file/VMware-Player-15.5.2-15785246.x86_64.bundle -O ~/Documents/vmware.bundle
	  sudo bash ~/Documents/vmware.bundle
	  rm ~/Documents/vmware.bundle
	else
		echo -e "        + Checking for ${GREEN}VMware${NC}: install ok installed"
	fi
	sleep 1


}

config () {
	#enable my default terminator workspace
	sudo rm ~/.config/terminator/config
	sudo cp config ~/.config/terminator/config

	#setup workspace switching between ubuntu and vmware
	sudo apt --yes install unity-tweak-tool unity-lens-applications unity-lens-files &>/dev/null #tweak tool + dependancies
	
	#add genpass to .bashrc and reload .bashrc
	echo "
	 # random password generator
	 genpass() {
	         local l=$1
	         [ "$l" == "" ] && l=20
	         tr -dc 'A-Za-z0-9_!@#$%^&*()_+{}|:<>?=' < /dev/urandom | head -c ${l} | xargs
	 }
	 " >> ~/.bashrc
	source ~/.bashrc


	#add network monitoring script to .bashrc and reload .bashrc
	echo "
	
	# Network Monitoring
	netmon() {
	    locip=$(ifdata -pa wlo1)
	    ip=$(curl -s http://icanhazip.com/)
	    whois=$(whois $ip | grep ountry | awk '{print $2}')
	    est_conn=$(netstat -anlt | egrep 'ESTABLISHED')
	    lis_conn=$(netstat -anlt | egrep 'LISTEN')
	    echo -e "\e[94m==============================================================================\e[0m"

	    echo -e "1.PUBLIC  IP=\e[32m $ip                   \e[0m"
	    echo -e "2.PRIVATE IP=\e[32m $locip                \e[0m"
	    echo -e "3.COUNTRY=\e[32m $whois                   \e[0m\n"
	    echo -e "ESTABLISHED CONNECTIONS:\n\e[32m$est_conn \e[0m\n"
	    echo -e  "LISTENING PORTS:\n\e[32m$lis_conn         \e[0m"
	    
	    if [ "MT" == $whois ] || [ "mt" == $whois ]; then
	        spd-say -t male2 'ALERT, ALERT, disconnected from VPN' 
	    fi
	    echo -e "\e[94m==============================================================================\e[0m"

	}
	" >> ~/.bashrc

}


hardening () {
	# OS hardening
	echo "-----------------------------------------------------------------------------------" 
	echo -e "\n${BRIGHTRED}[03] Hardening System${NC}" 
	echo "-----------------------------------------------------------------------------------" 

	# verify if .ssh folder permissions are set to 700
	echo -e "[01] - Verifying ${GREEN}.ssh${NC} folder permissions:"
	SSH_PERM=$(stat -c '%a' ~/.ssh)

	if [ "700" == "$SSH_PERM" ]; then
		echo -e "        + ${GREEN}~/.ssh${NC} folder permissions are correct: ${GREEN}700${NC}"
	else
		sudo chmod 700 ~/.ssh
		echo -e "        + ${BRIGHTRED}Unsecure${NC} permissions, folder permissions changed to ${GREEN}700${NC}"
	fi

	# set all files in .ssh to permission level 600
	echo -e "\n[02] - Setting permissions for all keys/files in ${GREEN}~/.ssh/${NC} to ${GREEN}600${NC}...DONE"
	sudo chmod 600 ~/.ssh/*

}


cleanup () {
	#Cleanup
	echo "-----------------------------------------------------------------------------------"
	echo -e "\n${BRIGHTRED}[04] Cleaning Instalation${NC}"
	echo "-----------------------------------------------------------------------------------"
	echo -e "Cleaning.Please wait..."
	sudo apt --yes autoremove &>/dev/null

}


footer () {
	echo "-----------------------------------------------------------------------------------"
	echo -e "${BRIGHTRED}                       DESKTOP ENVIRONMENT SETUP COMPLETE                 ${NC}"
	echo "-----------------------------------------------------------------------------------"
}


# initiate functions
header
update
install
config
hardening
cleanup
footer















