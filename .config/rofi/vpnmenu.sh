#!/usr/bin/env bash
# ----------------------------------------------------------------------
# Rofi VPN Launcher using existing helper script
# ----------------------------------------------------------------------

# --- CONFIGURATION (MUST MATCH YOUR EXISTING SCRIPTS) ---
VPN_DIR="/home/$(whoami)/vpnconfig"
MANAGER_SCRIPT="/home/$(whoami)/scripts/vpn-helper.sh"

# --- Function to Format Filename (e.g., singapore-1-protonvpn.ovpn -> Singapore | Server #1) ---
format_name() {
    local filename="$1"
    # Remove the file extension (.ovpn)
    local base_name="${filename%.*}"

    # Split by '-'
    # Assuming format: country-server_number-provider
    local parts=(${base_name//-/ })

    if [ ${#parts[@]} -lt 2 ]; then
        echo "Malformed: $filename"
        return
    fi

    local country="${parts[0]}"
    local server_num="${parts[1]}"

    # Capitalize the country name
    local display_country=$(echo "${country}" | awk '{print toupper(substr($0,1,1))tolower(substr($0,2))}')

    # Rofi display format: "Country | Server #N"
    echo "${display_country} | Server #${server_num}"
}

# --- Rofi Menu Generation ---

# We need a list of display names and a separate list of corresponding file paths.
# Rofi will only display the display names.

# The menu is built as a single newline-separated string
MENU_ENTRIES="Disconnect VPN\n"

# Map the Rofi display name (key) to the full config file path (value)
declare -A FILE_MAP

# Find all OVPN files in the directory
while IFS= read -r -d $'\0' file_path; do
    filename=$(basename "$file_path")

    # Generate the formatted display name
    display_name=$(format_name "$filename")

    # Only add valid entries
    if [[ "$display_name" != "Malformed"* ]]; then
        MENU_ENTRIES+="$display_name\n"
        FILE_MAP["$display_name"]="$file_path"
    fi
done < <(find "$VPN_DIR" -maxdepth 1 -type f -name "*.ovpn" -print0)

# Remove the trailing newline
MENU_ENTRIES="${MENU_ENTRIES%\\n}"


# --- Rofi Execution ---

# Run Rofi and capture the user's choice
choice=$(echo -e "$MENU_ENTRIES" | rofi -dmenu -p "VPN Connect: " -config ~/.config/rofi/config.rasi)

# --- Handle the Choice ---

case "$choice" in
    "Disconnect VPN")
        # Execute the helper script's disconnect command
        notify-send "VPN Disconnect" "Attempting to disconnect via helper script."
        # YOUR SCRIPT REQUIRES SUDO
        sudo "$MANAGER_SCRIPT" "disconnect"
        ;;
    "")
        # User canceled
        exit 0
        ;;
    *)
        # Must be a connection file. Get the full path from the map.
        CONFIG_PATH="${FILE_MAP["$choice"]}"

        if [ -f "$CONFIG_PATH" ]; then
            notify-send "VPN Connect" "Connecting to $choice..."
            # Execute the helper script's connect command with the file path
            # YOUR SCRIPT REQUIRES SUDO
            sudo "$MANAGER_SCRIPT" "connect" "$CONFIG_PATH" &

            # The helper script handles the backgrounding and state file.
        else
            notify-send "Error" "VPN file not found for: $choice"
        fi
        ;;
esac
