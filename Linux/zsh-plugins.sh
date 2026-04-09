#!/bin/bash

## external plugins
MY_PLUGINS=(zsh-autosuggestions zsh-syntax-highlighting)

auto="https://github.com/zsh-users/zsh-autosuggestions"
syntax="https://github.com/zsh-users/zsh-syntax-highlighting.git"

git clone $auto ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone $syntax ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

