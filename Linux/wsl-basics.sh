#!/usr/bin/env bash

set -e

# Check for root/sudo privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script using sudo:"
  echo "sudo bash $0"
  exit 1
fi

# Update package metadata
dnf check-update || true

# Install essential packages
dnf install -y \
  ncurses \
  net-tools \
  iputils \
  bind-utils \
  git \
  gcc \
  wget \
  curl \
  zip \
  unzip

echo "Installation completed."
