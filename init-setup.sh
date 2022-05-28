#!/bin/bash
# Clean environment setup for a new OS X setup
# Can be used both as a manual guide and as a script
# packages with workarounds required: 
# wfuzz - https://wfuzz.readthedocs.io/en/latest/user/installation.html#pycurl-on-macos

# CORE APPS
# ---------------------------------------------------------------------------
# homebrew Install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# command line apps
brew install --cask wget ansible cfssl gnupg helm hugo jq kubectl kubectx kustomize \
minikube nmap node python3 sops terraform tree wireguard-tools net-snmp bat \
android-platform-tools wfuzz cmake
brew install Caskroom/cask/wkhtmltopdf

# red-team apps
brew install john-jumbo apktool tnftp

# Homebrew taps
brew tap hashicorp/tap
brew install hashicorp/tap/packer


# gui apps
brew install --cask firefox iterm2 signal telegram minikube slack sublime-text \
the-unarchiver visual-studio-code wireshark

# configre git
git config --global user.name "Madalin Dogaru"
git config --global user.email "email@address.com"

#python pip apps
pip3 install flask-unsign


# ITERM2 CONFIGURATION
# ---------------------------------------------------------------------------
# install zsh powerlevel10k
# install the powerlevel10k optional fonts 
# https://github.com/romkatv/powerlevel10k#manual-font-installation (manual install)
brew install romkatv/powerlevel10k/powerlevel10k
echo "source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
p10k configure

# install & activate zsh syntax highlighting and autosuggestions
brew install zsh-syntax-highlighting zsh-autosuggestions
echo "source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh">>~/.zshrc
echo "source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >>~/.zshrc

# install iTerm2 shell integrations
curl -L https://iterm2.com/shell_integration/install_shell_integration.sh | bash


# VSCODE
# ---------------------------------------------------------------------------
# extensions
code --install-extension eamodio.gitlens
code --install-extension ms-azuretools.vscode-docker
code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
code --install-extension ms-vscode-remote.remote-ssh


# OSX LOGIC CONFIGURATION
# ---------------------------------------------------------------------------
# expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# save to disk, not to iCloud, by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool true

# automatically quit printer app once print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# remove duplicates in the “Open With” menu (also see `lscleanup` alias)
# /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

# allow automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool false

# check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1


# finder configuration
# ---------------------
# show hidden files by default
defaults write com.apple.Finder AppleShowAllFiles -bool false

# show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# show path bar
defaults write com.apple.finder ShowPathbar -bool true

# allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# when performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# use list view in all Finder windows by default
# - four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# empty Trash securely by default
defaults write com.apple.finder EmptyTrashSecurely -bool true

# show the ~/Library folder
chflags nohidden ~/Library

# show the /Volumes folder
sudo chflags nohidden /Volumes

# expand the following file info panes:
# - 'General'
# - 'Open with'
# - 'Sharing & Permissions'
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true

# speed up mission control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# activity monitor
# ---------------------
# show the main window when launching activity monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# visualize CPU usage in the activity monitor dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# show all processes in activity monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0
