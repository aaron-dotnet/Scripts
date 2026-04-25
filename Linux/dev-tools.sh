#!/usr/bin/env bash

#set -x
#set -v

PACKAGES=(xxd sqlite tldr dotnet-sdk-10.0)
PACKAGESD=(xxd sqlite3 tealdeer)
zed_install="curl -fsSL https://zed.dev/install.sh | sh"
opencode_install="curl -fsSL https://opencode.ai/install | bash"

if command -v apt-get &>/dev/null; then
    sudo apt-get install -y ${PACKAGESD[@]}
    # DOTNET
    cat /etc/*-release | grep -i ubuntu
    if [ $? == 0 ]; then
        # ubuntu
        sudo apt-get update && sudo apt-get install -y dotnet-sdk-10.0
    else
        # debian
        echo "Adding Microsoft Packages"
        sudo apt-get install wget gpg -y
        wget https://packages.microsoft.com/config/debian/13/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
        sudo dpkg -i packages-microsoft-prod.deb
        rm packages-microsoft-prod.deb

        sudo apt-get update && sudo apt-get install -y dotnet-sdk-10.0
    fi
elif command -v dnf &>/dev/null; then
    sudo dnf install -y ${PACKAGES[@]}
else
    echo "UNSUPPORTED DISTRO"
    exit 1
fi

if [ $? != 0 ]; then
    echo "Something went wrong during the installation"
    exit 1
fi

install_zed() {
    echo "Installing Zed editor ..."
    $zed_install
    if [ $? != 0 ]; then
        echo "Zed couldn't be installed."
    fi
}
install_opencode() {
    echo "Installing opencode"
    $opencode_install
    if [ $? != 0 ]; then
        echo "opencode couldn't be installed."
    fi
}

# vscode
install_vscode() {
    # debian / ubuntu
    # command -v apt-get &> /dev/null
    local ms_keys="https://packages.microsoft.com/keys/microsoft.asc"
    if command -v apt-get &>/dev/null; then
        echo "--- DEBIAN / UBUNTU ---"
        sudo apt-get update -y && sudo apt upgrade -y
        sudo apt-get install wget gpg -y &&
            echo "----"
        echo " Adding Microsoft Keys "
        echo "----"
        wget -qO- $ms_keys | gpg --dearmor >microsoft.gpg &&
            sudo install -D -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft.gpg &&
            rm -f microsoft.gpg

        local ms_debrepo="https://packages.microsoft.com/repos/code"
        echo -e "Types: deb\nURIs: ${ms_debrepo}\nSuites: stable\nComponents: main\nArchitectures: amd64,arm64,armhf\nSigned-By: /usr/share/keyrings/microsoft.gpg" | sudo tee /etc/apt/sources.list.d/vscode.sources >/dev/null
        echo "----"
        echo "Installing vscode..."
        echo "----"
        sudo apt install apt-transport-https -y &&
            sudo apt update -y &&
            sudo apt install code -y

    else
        echo "--- FEDORA / RHEL (rpm) ---"
        sudo dnf upgrade --refresh -y
        echo "----"
        echo " Adding Microsoft Keys "
        echo "----"
        sudo rpm --import $ms_keys &&
            local ms_yumrepo="https://packages.microsoft.com/yumrepos/vscode"
        echo -e "[code]\nname=Visual Studio Code\nbaseurl=${ms_yumrepo}\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=${ms_keys}" | sudo tee /etc/yum.repos.d/vscode.repo >/dev/null

        echo "----"
        echo "Installing vscode ..."
        echo "----"
        dnf check-update && sudo dnf install code -y
    fi
}

install_vscode
install_zed
install_opencode

echo "----"
echo "Process completed."
echo "----"
