#!/bin/bash

name="Alejandro de la Fuente"
email="alejandro.delafuente@petroprix.com"

# shellcheck source=distro.sh
. ../distro.sh
# shellcheck source=helpers.sh
. ../helpers.sh

echo_info "Configuring GIT..."
mkdir -p ${HOME}/.git

echo_info "Installing GIT..."
sudo apt install git

git config --global user.name ${name}
git config --global user.email ${email}

echo_done "GIT configuration!"
