if [ "$OS" = "MAC" ]; then
	FONTS_DIR=~/Library/Fonts
	brew tap homebrew/cask-fonts
	brew install --cask font-firacode-nerd-font
	brew install --cask font-jetbrains-mono
fi

if [ "$OS" = "LINUX" ]; then
	FONTS_DIR=~/.local/share/fonts
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"
fi

function add_font_from_url {

	(cd "$FONTS_DIR" &&
		curl -fLo "$1" "$2")
}

add_font_from_url "Symbols-1000-em Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/NerdFontsSymbolsOnly/SymbolsNerdFont-Regular.ttf
add_font_from_url "Symbols-2048-em Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/NerdFontsSymbolsOnly/SymbolsNerdFont-Regular.ttf
add_font_from_url "Symbols-1000-em Nerd Font Complete Mono.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/NerdFontsSymbolsOnly/SymbolsNerdFontMono-Regular.ttf
add_font_from_url "Symbols-2048-em Nerd Font Complete Mono.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/NerdFontsSymbolsOnly/SymbolsNerdFontMono-Regular.ttf
