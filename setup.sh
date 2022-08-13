#!/bin/bash

while getopts 'o' OPTION; do
    case "$OPTION" in
        o)
            export OVERRIDE="true"
            ;;
    esac
done


export CURRENT_DIR=$(dirname -- "$( readlink -f -- "$0"; )")

DEPENDENCIES="firefox httpie zsh git ripgrep docker docker-compose xclip"
sudo pacman -S $DEPENDENCIES --noconfirm


./setup/node-setup.sh
./setup/python-setup.sh
./setup/font-setup.sh
./setup/oh-my-zsh-setup.sh
./setup/neovim-setup.sh
./setup/kitty-setup.sh


