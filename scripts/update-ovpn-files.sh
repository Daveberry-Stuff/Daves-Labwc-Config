#!/bin/bash
# ----------------------------------------------------------------------
# update-ovpn-files.sh: Replaces 'auth-user-pass' with path, 
# comments out resolv.conf scripts, and adds ProtonVPN DNS options.
# ----------------------------------------------------------------------

# --- Configuration ---
VPN_CONFIG_DIR="/home/$(whoami)/vpnconfig"
PASSWORD_FILE="auth-user-pass /home/$(whoami)/vpnconfig/protonpass.txt"
DNS_LINES=$'# Proton VPN DNS Servers\ndhcp-option DNS 10.8.0.1\ndhcp-option DNS 10.8.0.1'

echo "Starting configuration file standardization..."
echo "Target directory: $VPN_CONFIG_DIR"
echo ""

# 1. Check if the directory exists
if [ ! -d "$VPN_CONFIG_DIR" ]; then
    echo "Error: Configuration directory not found at $VPN_CONFIG_DIR"
    exit 1
fi

# 2. Loop through all .ovpn files in the directory
find "$VPN_CONFIG_DIR" -type f -name "*.ovpn" -print0 | while IFS= read -r -d $'\0' file
do
    echo "--- Processing: $(basename "$file") ---"
    
    # --- OPERATION 1: Replace auth-user-pass (FIXED: Using '|' as delimiter) ---
    # Look for 'auth-user-pass' at the start of a line and replace it with the path.
    if grep -q "^auth-user-pass" "$file" && ! grep -q "protonpass.txt" "$file"; then
        # Use '|' as the sed delimiter (s|pattern|replacement|g) to avoid conflicts with '/' in the path.
        /usr/bin/sed -i 's|^auth-user-pass.*$|'"$PASSWORD_FILE"'|g' "$file"
        echo "  - SUCCESS: Set 'auth-user-pass' to use protonpass.txt."
    elif grep -q "protonpass.txt" "$file"; then
        echo "  - SKIPPED: 'auth-user-pass' already correctly configured."
    else
        echo "  - INFO: 'auth-user-pass' directive not found/needed."
    fi

    # --- OPERATION 2: Comment out resolv-conf scripts (FIXED: Using address/command structure) ---
    # Escape the forward slashes in the path for sed to use '/' as the delimiter.
    
    if grep -q "^up /etc/openvpn/update-resolv-conf" "$file"; then
        # Find the line (address), then substitute the start of the line (^) with '#'
        /usr/bin/sed -i '/^up \/etc\/openvpn\/update-resolv-conf/ s/^/#/' "$file"
        echo "  - SUCCESS: Commented out the 'up' resolv-conf script."
    else
        echo "  - INFO: 'up' resolv-conf script not found or already commented."
    fi

    if grep -q "^down /etc/openvpn/update-resolv-conf" "$file"; then
        # Find the line (address), then substitute the start of the line (^) with '#'
        /usr/bin/sed -i '/^down \/etc\/openvpn\/update-resolv-conf/ s/^/#/' "$file"
        echo "  - SUCCESS: Commented out the 'down' resolv-conf script."
    else
        echo "  - INFO: 'down' resolv-conf script not found or already commented."
    fi
    
    # --- OPERATION 3: Append Proton VPN DNS Servers ---
    # Check if the DNS lines already exist to prevent duplication
    if ! grep -q "dhcp-option DNS 10.8.0.1" "$file"; then
        # Append the new lines using printf and redirection
        printf "\n%s\n" "$DNS_LINES" >> "$file"
        echo "  - SUCCESS: Appended Proton VPN DNS servers."
    else
        echo "  - SKIPPED: Proton VPN DNS servers already present."
    fi

done

echo ""
echo "Configuration update complete."