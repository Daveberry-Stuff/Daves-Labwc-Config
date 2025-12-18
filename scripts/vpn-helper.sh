#!/bin/bash
# ----------------------------------------------------------------------
# OpenVPN Connection Manager Wrapper (Engine with State File)
# ----------------------------------------------------------------------

# --- Configuration ---
VPN_DIR="/home/$(whoami)/vpnconfig"
PASS_FILE="$VPN_DIR/protonpass.txt"
LOG_FILE="/tmp/openvpn_status.log"
PID_FILE="/tmp/openvpn.pid"
ACTIVE_FILE="/tmp/.vpn_active_name"  # <--- NEW STATE FILE
OPENVPN_BIN="/usr/sbin/openvpn"

# --- Explicitly assign arguments ---
action="${1}"
config_file="${2}"

case "${action}" in
    "connect")
        if [ -z "${config_file}" ]; then exit 1; fi

        # 1. Cleanup old connection (must run as root)
        if [ -f "$PID_FILE" ]; then
            PID=$(cat "$PID_FILE")
            kill -SIGTERM "$PID" 2>/dev/null
            sleep 2
            rm -f "$PID_FILE"
        fi
        rm -f "$ACTIVE_FILE"  # Delete old state file

        # 2. The OpenVPN Command
        "$OPENVPN_BIN" \
            --config "${config_file}" \
            --auth-user-pass "$PASS_FILE" \
            --daemon \
            --log-append "$LOG_FILE" \
            --writepid "$PID_FILE"

        sleep 1

        if [ ! -f "$PID_FILE" ]; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') Error: Daemon failed to start. Review $LOG_FILE." >> "$LOG_FILE"
            exit 1
        fi

        # 3. Write the active configuration name to the state file
        # We store the full path so the TUI can easily match it.
        echo "$config_file" > "$ACTIVE_FILE"
        ;;

    "disconnect")
        if [ -f "$PID_FILE" ]; then
            PID=$(cat "$PID_FILE")
            kill -SIGTERM "$PID" 2>/dev/null
            sleep 2
            rm -f "$PID_FILE"
        fi
        /usr/bin/pkill -SIGKILL openvpn # Aggressive fallback cleanup
        rm -f "$PID_FILE"
        rm -f "$ACTIVE_FILE"  # Delete the state file
        ;;
esac
