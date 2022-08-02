if ! [ -x "$(command -v nvim)" ] || [ $OVERRIDE ]; then
    echo "Setting up Neovim"
    if [ "$OS" = "LINUX" ]; then
        sudo pacman -S neovim typescript pyright gcc --noconfirm
    fi
    if [ "$OS" = "MAC" ]; then
	brew install neovim typescript pyright gcc
    fi

    mkdir -p ~/.local/venv
    (cd ~/.local/venv && \
        python3 -m venv nvim && \
        cd nvim && \
        . ./bin/activate && \
        pip install pynvim black && \
	exit)

    npm install -g neovim

    mkdir -p "$HOME/.config/nvim"
    ln -fs "$CURRENT_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"
    ln -fs "$CURRENT_DIR/nvim/lua" "$HOME/.config/nvim/lua"

    git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.config/nvim/site/pack/packer/start/packer.nvim
else
    echo "Neovim already installed, skipping"
fi
