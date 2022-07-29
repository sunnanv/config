if [ ! -d "$HOME/.oh-my-zsh" ] || [ $OVERRIDE ]; then
    echo "Setting up oh-my-zsh"

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    chsh -s /usr/bin/zsh
    ln -fs "$CURRENT_DIR/.zshrc" "$HOME/.zshrc"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

else
    echo 'oh my zsh already installed, skipping'
fi
