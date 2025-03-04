#!/usr/bin/env bash

# install mise if not already installed to local path
if ! command -v ~/.local/bin/mise &>/dev/null; then
    curl https://mise.run | sh
    echo ""
    echo "Load mise into your path (add to your ~/.zshrc profile to always be available): "
    echo '   echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc'
    eval "$(~/.local/bin/mise activate zsh)"
else
    eval "$(~/.local/bin/mise activate zsh)"
fi

mise install -y

#task python:venv python:install
