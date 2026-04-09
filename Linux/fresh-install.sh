#!/bin/bash

# install my basic packages

echo "Installing my essential packages"

PACKAGES=(git zsh zoxide bat xxd btop 7zip neovim)
sudo dnf install ${PACKAGES[@]} -y


if [ $? != 0 ]; then
    echo "An error ocurred."
    read -n 1 "Wanna continue? [y/n]" ans
    case "${ans,,}" in
        y)
            which zsh > /dev/null 2>&1
            if [ $? != 0]; then
                echo "zsh isn't installed, exiting..."
                exit 1
            fi
        ;;
        *)
            echo "Exiting..."
            exit 1
        ;;
    esac
fi


omzurl="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
sh -c "$(curl -fsSL $omzurl)"

echo "- - - - - - -"
echo "Done."

exit 0

