#!/usr/bin/env bash

set -e

export DEBIAN_FRONTEND=noninteractive

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ -z "$SUDO_USER" ]; then 
    echo "Please run with sudo.";
    exit 1
fi

# make tmp dir for artifacts
SETUP_DIR=$(mktemp -d)
echo "Created temporary directory $SETUP_DIR"
cd "$SETUP_DIR"

# ensure certain dirs exist
mkdir -p /usr/local/share/man/man1
mkdir -p /usr/local/share/man/man5
mkdir -p /usr/share/bash-completion/completions
mkdir -p /usr/share/fish/completions
mkdir -p /usr/share/zsh/vendor-completions

# apt packages
apt-get update --fix-missing
apt-get install -y --no-install-recommends git zsh fzf bat unzip ncdu

# install exa
# TODO check for UBUNTU (20.10+) and use apt
if ! command -v exa &> /dev/null
then
    echo "Installing exa..."
    mkdir -p "$SETUP_DIR/exa"
    cd "$SETUP_DIR/exa"
    wget https://github.com/ogham/exa/releases/download/v0.10.1/exa-linux-x86_64-v0.10.1.zip -O exa.zip
    unzip exa.zip
    mv bin/exa /usr/local/bin/exa
    mv man/exa.1 /usr/local/share/man/man1
    mv completions/exa.bash /usr/share/bash-completion/completions/exa
    mv completions/exa.fish /usr/share/fish/completions/exa.fish
    mv completions/exa.zsh /usr/share/zsh/vendor-completions/_exa
else
    echo "exa already installed, skipping."
fi

if ! command -v zoxide &> /dev/null
then
    echo "Installing zoxide..."
    mkdir -p "$SETUP_DIR/zoxide"
    cd "$SETUP_DIR/zoxide"
    wget https://github.com/ajeetdsouza/zoxide/releases/download/v0.8.0/zoxide-v0.8.0-x86_64-unknown-linux-musl.tar.gz -O zoxide.tar.gz
    tar -xvf zoxide.tar.gz
    mv zoxide /usr/local/bin/zoxide
    # we don't worry about completions since the eval "$(zoxide init zsh)" in zshrc handles that 
    # there are some other man pages in there i am ignoring
    mv man/zoxide.1 /usr/local/share/man/man1
else
    echo "zoxide already installed, skipping."
fi

# intall oh-my-zsh
curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh > zsh-install.sh
sudo -u "$SUDO_USER" sh zsh-install.sh --unattended

# install custom theme
sudo -u "$SUDO_USER" wget https://raw.githubusercontent.com/slessans/oh-my-zsh-sl-agnoster/main/sl-agnoster.zsh-theme -O "$HOME/.oh-my-zsh/themes/sl-agnoster.zsh-theme"
sudo -u "$SUDO_USER" cp "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"

# change default shell
sudo chsh -s $(which zsh) "$SUDO_USER"

echo "All done! :D"
echo "Log out and log back in or source ~/.zshrc"
