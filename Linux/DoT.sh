#!/usr/bin/env bash
set -e

CONF_DIR="/etc/systemd/resolved.conf.d"
CONF_FILE="${CONF_DIR}/dns-over-tls.conf"

CLOUDFLARE_DNS="1.1.1.1 1.0.0.1 2606:4700:4700::1111 2606:4700:4700::1001"
QUAD9_DNS="9.9.9.9 149.112.112.112 2620:fe::fe 2620:fe::9"

write_config() {
    local dns="$1"
    local fallback="$2"

    echo "==========================================="
    echo "  Writing configuration"
    echo "==========================================="
    sudo mkdir -p "${CONF_DIR}"
    sudo tee "${CONF_FILE}" > /dev/null <<EOF
[Resolve]
DNS=${dns}
DNSOverTLS=yes
FallbackDNS=${fallback}
EOF
    echo

    apply_and_verify
}

apply_and_verify() {
    echo "Applying changes..."
    sudo systemctl restart systemd-resolved
    echo

    echo " ==== Current status ===="
    resolvectl status
    echo
}

restore_config() {
    echo "Restoring default configuration..."
    sudo rm -f "${CONF_FILE}"
    echo

    apply_and_verify
}

show_menu() {
    echo "==========================================="
    echo "  Linux DNS over TLS (DoT) Configuration"
    echo "==========================================="
    echo " 1. Configure Cloudflare  (1.1.1.1 / 1.0.0.1)"
    echo " 2. Configure Quad9       (9.9.9.9 / 149.112.112.112)"
    echo " 3. Configure Both        (Cloudflare + Quad9)"
    echo " 4. Restore / Remove DoT configuration"
    echo " 5. Exit"
    echo "==========================================="
    echo
    read -rp "Select an option [1-5]: " option
    echo

    case "$option" in
        1) write_config "${CLOUDFLARE_DNS}" "${QUAD9_DNS}" ;;
        2) write_config "${QUAD9_DNS}" "${CLOUDFLARE_DNS}" ;;
        3) write_config "${CLOUDFLARE_DNS} ${QUAD9_DNS}" "${QUAD9_DNS}" ;;
        4) restore_config ;;
        5) exit 0 ;;
        *) echo "Invalid option." ;;
    esac
}

show_menu