/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"

declare -A nameToUrl
nameToUrl["Symbols-1000-em Nerd Font Complete Mono.ttf"]=https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/NerdFontsSymbolsOnly/complete/Symbols-1000-em%20Nerd%20Font%20Complete%20Mono.ttf
nameToUrl["Symbols-2048-em Nerd Font Complete Mono.ttf"]=https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/NerdFontsSymbolsOnly/complete/Symbols-2048-em%20Nerd%20Font%20Complete%20Mono.ttf

FONTS_DIR=~/.local/share/fonts
mkdir -p "$FONTS_DIR"

for key in "${!nameToUrl[@]}"; do
    (cd $FONTS_DIR && \
        curl -fLo "$key" "${nameToUrl[$key]}")
done
