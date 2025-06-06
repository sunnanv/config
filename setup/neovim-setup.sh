DEPENDENCIES="neovim"

if [ "$OS" = "LINUX" ]; then
	sudo pacman -S $DEPENDENCIES --noconfirm
fi
if [ "$OS" = "MAC" ]; then
	brew install $DEPENDENCIES
fi

npm i -g neovim 

mkdir -p ~/.local/venv
(cd ~/.local/venv &&
	python3 -m venv nvim &&
	cd nvim &&
	. ./bin/activate &&
	pip install pynvim &&
	exit)

if ! [ -x "$(command -v nvim)" ] || [ $OVERRIDE ]; then
	echo "Setting up Neovim"
	mkdir -p "$HOME/.config/nvim"
	ln -fs "$CURRENT_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"
	ln -fs "$CURRENT_DIR/nvim/lua" "$HOME/.config/nvim/lua"
	ln -fs "$CURRENT_DIR/nvim/after" "$HOME/.config/nvim/after"
	ln -fs "$CURRENT_DIR/nvim/lazy-lock.json" "$HOME/.config/nvim/lazy-lock.json"
else
	echo "Neovim already installed, skipping"
fi
