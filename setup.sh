#!/usr/bin/env bash

set -e

export DEBIAN_FRONTEND=noninteractive

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

rm -rf ~/.sl-setup-temp
mkdir -p ~/.sl-setup-temp
cd ~/.sl-setup-temp

# pre setup
mkdir -p /usr/local/share/man/man1
mkdir -p /usr/local/share/man/man5

# apt packages
sudo apt-get update --fix-missing
sudo apt-get install -y --no-install-recommends git zsh fzf bat unzip

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

# change shell to zsh
chsh -s $(which zsh)

# intall oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install custom theme
wget https://raw.githubusercontent.com/slessans/oh-my-zsh-sl-agnoster/main/sl-agnoster.zsh-theme -O ~/.oh-my-zsh/themes/sl-agnoster.zsh-theme
cp "$SCRIPT_DIR/.zshrc" ~/.zshrc
