#!/bin/bash

# Written by Mahendra Choudhary
# Run without downloading:
# curl https://raw.githubusercontent.com/jakepintu/dotfiles/master/regolith | bash

# Ask for the administrator password upfront
sudo -v

blue=$(tput setaf 4)
green=$(tput setaf 2)
red=$(tput setaf 1)
yellow=$(tput setaf 3)
normal=$(tput sgr0)

function echo_error() {
  printf "[${red}!!${normal}] $1 \n"
}

function echo_warning() {
  printf "[${yellow}/\${normal}] $1 \n"
}

function echo_success() {
  printf "[${green}OK${normal}] $1 \n"
}

function echo_info() {
  printf "[${blue}..${normal}] $1 \n"
}

function _install() {
    pkgs=("$@")
    echo_info "Installing ${pkgs[@]}..."
    sudo apt install ${pkgs[@]}
    echo_success "Installed ${pkgs[@]}"
}

function _update() {
    echo_info "Updating $1"
    sudo apt update
    sudo apt upgrade
    sudo apt auto-remove
    echo_success "Updated $1"
}

PKGS=(
    curl
    wget
    zsh
    git
    neovim
    ranger
    vifm
    toilet
    lolcat
    vlc
    transmission
    ffmpeg
    htop
    neofetch
    tree
    nethogs
    variety
    exa
    kitty
)

# Keep-alive: update existing `sudo` time stamp until `install` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "Hello $(whoami)! Let's get you set up."

echo_info "Updating system"
_update

echo_info "Installing packages..."
_install "${PKGS[@]}"

echo_info "Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo_info "Installing devilspie"
sudo apt-get install devilspie
mkdir -p ~/.devilspie

echo_info "Installing kitty"
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

echo_info "Installing youtube-dl"
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl

echo_info "Installing vscode"
sudo snap install --classic code

echo "Generating an RSA token for GitHub"
mkdir -p ~/.ssh
ssh-keygen -t rsa -b 4096 -C "jakepintu@gmail.com"
echo "Host *\n AddKeysToAgent yes\n UseKeychain yes\n IdentityFile ~/.ssh/id_rsa" | tee ~/.ssh/config
eval "$(ssh-agent -s)"
echo "run 'pbcopy < ~/.ssh/id_rsa.pub' and paste that into GitHub"

echo "cloning dotfiles"
git clone https://github.com/jakepintu/dotfiles.git

mkdir ${HOME}/.config/kitty
mkdir ${HOME}/.config/nvim
mkdir ${HOME}/.config/regolith
mkdir ${HOME}/.config/regolith/i3
mkdir ${HOME}/.devilspie
mkdir ${HOME}/.Xresources.d

ln -sf "${HOME}/dotfiles/.zshrc" "${HOME}/.zshrc"
ln -sf "${HOME}/dotfiles/.config/kitty/kitty.conf" "${HOME}/.config/kitty/kitty.conf"
ln -sf "${HOME}/dotfiles/.config/nvim/init.vim" "${HOME}/.config/nvim/init.vim"
ln -sf "${HOME}/dotfiles/.config/regolith/i3/config" "${HOME}/.config/regolith/i3/config"
ln -sf "${HOME}/dotfiles/.devilspie/firefox_transparent.ds" "${HOME}/.devilspie/firefox_transparent.ds"
ln -sf "${HOME}/dotfiles/.devilspie/kitty_transparent.ds" "${HOME}/.devilspie/kitty_transparent.ds"
ln -sf "${HOME}/dotfiles/.devilspie/transmission_transparent.ds" "${HOME}/.devilspie/transmission_transparent.ds"
ln -sf "${HOME}/dotfiles/.devilspie/vscode_transparent.ds" "${HOME}/.devilspie/vscode_transparent.ds"
ln -sf "${HOME}/dotfiles/.Xresources" "${HOME}/.Xresources"
ln -sf "${HOME}/dotfiles/.Xresources.d/color-palenight" "${HOME}/.Xresources.d/color-palenight"

