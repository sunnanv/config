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

echo $CURRENT_DIR

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

NONINTERACTIVE=1 brew install --cask \
	firefox \
	docker 

NONINTERACTIVE=1 brew install \
	httpie \
	zsh \
	ripgrep \
	docker-compose
	

# ssh-keygen -q -t ed25519 -C "johannes.sunnan@gmail.com" -N '' ~/.ssh/id_ed25519 <<<y >/dev/null 2>&1

./setup/node-setup.sh
./setup/python-setup.sh
./setup/font-setup.sh
./setup/oh-my-zsh-setup.sh
./setup/neovim-setup.sh
./setup/kitty-setup.sh


