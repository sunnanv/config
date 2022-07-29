if ! [ -x "$(command -v node)" ] || [ $OVERRIDE ]; then
    echo "Setting up node"

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
    source ~/.nvm/nvm.sh
    nvm install --lts
else
    echo "Node already setup, skipping"
fi
