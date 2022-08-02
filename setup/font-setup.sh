
if [ "$OS" = "MAC" ] ; then
    echo 'MACMAC'
    FONTS_DIR=~/Library/Fonts
    brew tap homebrew/cask-fonts
    brew install --cask font-jetbrains-mono
fi

if [ "$OS" = "LINUX" ]; then
    FONTS_DIR=~/.local/share/fonts
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"
fi

function add_font_from_url {
    
    (cd $FONTS_DIR && \
        curl -fLo "$1" "$2")
}

add_font_from_url "Symbols-1000-em Nerd Font Complete Mono.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/NerdFontsSymbolsOnly/complete/Symbols-1000-em%20Nerd%20Font%20Complete%20Mono.ttf

add_font_from_url "Symbols-2048-em Nerd Font Complete Mono.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/NerdFontsSymbolsOnly/complete/Symbols-2048-em%20Nerd%20Font%20Complete%20Mono.ttf
# declare -A nameToUrl
# nameToUrl["Symbols-1000-em Nerd Font Complete Mono.ttf"]=https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/NerdFontsSymbolsOnly/complete/Symbols-1000-em%20Nerd%20Font%20Complete%20Mono.ttf
# nameToUrl["Symbols-2048-em Nerd Font Complete Mono.ttf"]=https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/NerdFontsSymbolsOnly/complete/Symbols-2048-em%20Nerd%20Font%20Complete%20Mono.ttf
# 
# mkdir -p "$FONTS_DIR"
# 
# for key in "${!nameToUrl[@]}"; do
#     (cd $FONTS_DIR && \
#         curl -fLo "$key" "${nameToUrl[$key]}")
# done
