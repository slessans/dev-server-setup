#!/usr/bin/env bash

set -e

if [ -z "$SUDO_USER" ]; then 
    echo "Please run with sudo.";
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# pre setup
mkdir -p /usr/local/share/man/man1
mkdir -p /usr/local/share/man/man5
mkdir -p /usr/share/bash-completion/completions
mkdir -p /usr/share/fish/completions
mkdir -p /usr/share/zsh/vendor-completions

# apt packages
apt-get update --fix-missing
apt-get install -y --no-install-recommends git zsh fzf bat unzip

# make tmp dir for artifacts
rm -rf /tmp/.sl-setup-temp
mkdir -p /tmp/.sl-setup-temp
cd /tmp/.sl-setup-temp

# install exa
# TODO check for UBUNTU (20.10+) and use apt
mkdir exa
cd exa
wget https://github.com/ogham/exa/releases/download/v0.10.1/exa-linux-x86_64-v0.10.1.zip -O exa.zip
unzip exa.zip
mv bin/exa /usr/local/bin/exa
mv man/exa.1 /usr/local/share/man/man1
mv completions/exa.bash /usr/share/bash-completion/completions/exa
mv completions/exa.fish /usr/share/fish/completions/exa.fish
mv completions/exa.zsh /usr/share/zsh/vendor-completions/_exa

# intall oh-my-zsh
curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh > zsh-install.sh
sudo -u "$SUDO_USER" sh zsh-install.sh --unattended

# install custom theme
wget https://raw.githubusercontent.com/slessans/oh-my-zsh-sl-agnoster/main/sl-agnoster.zsh-theme -O "/home/$SUDO_USER/.oh-my-zsh/themes/sl-agnoster.zsh-theme"
cp "$SCRIPT_DIR/.zshrc" "/home/$SUDO_USER/.zshrc"

# change default shell
sudo chsh -s $(which zsh) "$SUDO_USER"

