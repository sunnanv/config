#!/bin/bash

while getopts 'o' OPTION; do
    case "$OPTION" in
        o)
            export OVERRIDE="true"
            ;;
    esac
done


export CURRENT_DIR=$(dirname -- "$( readlink -f -- "$0"; )")

echo $CURRENT_DIR

sudo pacman -S \
	firefox \
	httpie \
	zsh \
	git \
	ripgrep \
	docker \
	docker-compose \
    xclip \
	--noconfirm

# ssh-keygen -q -t ed25519 -C "johannes.sunnan@gmail.com" -N '' ~/.ssh/id_ed25519 <<<y >/dev/null 2>&1

./setup/node-setup.sh
./setup/python-setup.sh
./setup/font-setup.sh
./setup/oh-my-zsh-setup.sh
./setup/neovim-setup.sh
./setup/kitty-setup.sh


