#!/bin/bash

while getopts 'o' OPTION; do
    case "$OPTION" in
        o)
            export OVERRIDE="true"
            ;;
    esac
done

export OS="MAC"
export CURRENT_DIR=$( cd ${0%/*} && pwd -P )


/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

CASKS="firefox docker"
NONINTERACTIVE=1 brew install --cask $CASKS

DEPENDENCIES="httpie zsh ripgrep docker-compose bat gh tmux"
NONINTERACTIVE=1 brew install $DEPENDENCIES

ln -fs "$CURRENT_DIR/.tmux.conf" "$HOME/.tmux.conf"

./setup/node-setup.sh
./setup/python-setup.sh
./setup/font-setup.sh
./setup/oh-my-zsh-setup.sh
./setup/neovim-setup.sh
./setup/kitty-setup.sh


