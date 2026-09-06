#!/usr/bin/env bash

# --------------------------------
set -Eeuo pipefail

echo "Actualizando Termux..."
pkg update
pkg upgrade -y

echo "Instalando herramientas básicas..."
pkg install -y \
  git curl wget \
  build-essential clang make cmake pkg-config \
  which tree jq \
  nano file zsh \
  zip unzip tar gzip

echo "Instalando herramientas de red..."
pkg install -y \
  nmap dnsutils iproute2 openssh

echo "Instalando lenguajes..."
pkg install -y \
  dotnet-sdk-10.0 nodejs-lts

termux-setup-storage
npm config set ignore-scripts true

echo "- - - - - - - - - - - -"
echo "Instalación completada."