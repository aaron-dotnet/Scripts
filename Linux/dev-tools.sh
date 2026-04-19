#!/usr/bin/env bash

#set -x
#set -v

PACKAGES=(xxd sqlite tldr dotnet-sdk-10.0)

#varx='curl -sL https://www.example.org'
#eval $varx &
#wait $!
#exit 1

if command -v apt-get &> /dev/null; then
    sudo apt-get install -y ${PACKAGES[@]}
elif command -v dnf &> /dev/null; then
    sudo dnf install -y ${PACKAGES[@]}
fi

#zed_install="curl -f https://xzed.dev/install.sh | sh"
#opencode_install="curl -fsSL https://opencode.ai/install | bash"

# vscode
install_vscode() {
    # debian / ubuntu
    # command -v apt-get &> /dev/null
    if [ 1 == 2 ]; then
        echo "----"
        echo "Adding repo key & gpg"
        echo "----"
        local ms_keys="https://packages.microsoft.com/keys/microsoft.asc"
        sudo apt-get install wget gpg -y &&
        wget -qO- $msrepo | gpg --dearmor > microsoft.gpg &&
        sudo install -D -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft.gpg &&
        rm -f microsoft.gpg

        local ms_repo="https://packages.microsoft.com/repos/code"
        echo -e "Types: deb\nURIs: ${ms_repo}\nSuites: stable\nComponents: main\nArchitectures: amd64,arm64,armhf\nSigned-By: /usr/share/keyrings/microsoft.gpg" | sudo tee /etc/apt/sources.list.d/vscode.sources > /dev/null
        echo "----"
        echo "Installing vscode..."
        echo "----"
        sudo apt install apt-transport-https -y &&
        sudo apt update -y &&
        sudo apt install code -y

    else
        echo "Installing for Fedora (rpm)"
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
        echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
        dnf check-update && sudo dnf install code -y
    fi
}