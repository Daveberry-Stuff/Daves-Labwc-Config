# Dave's LabWC Configuration.
## 📦 | Minimal at best.
This configuration is focused on performance and usability. This can be used for daily driving on a daily basis.

This used to be very minimal, focusing on gaming. But now, it's usable for daily driving.

## 📕 | What's in it?
### 📜 | Made-scripts:
- `syscontrol.py` -  Controls your brightness and your volume.
  - `ddc-helper.sh` - Handles chaning your brightness.
- `powermenu.sh` - Shutsdown, Reboot, Log out.

### 💻 | Packages:
- `labwc` - The Desktop Environment itself.
- `kitty` - The default terminal.
- `ddcutil` - The library that controls the brightness.
- `pactl` - Changing volume.
- `python3` - For the Made-Scripts.
- `htop` - System Monitor.
- `ranger` - For managing files, and the file explorer.
- `nautilus` - Backup for ranger if you don't want to use the TUI.
- `rofi` - App launcher, VPN conneting, Power Menu.
- `swaybg` - Background for Wayland compositors.
- `waybar` - Top bar for wayland compositors.
- `org.videolan.VLC` - The default media player.
- `grim` & `satty` - Screenshoting tools
- `com.visualstudio.code` - The default code editor.
- `neovim` - Your second default code editor.
- `com.github.PintaProject.Pinta` - The default image viewer/editor.
- `wl-clipboard` - Wayland compositors clipboard.
- `libinput` - Input Library.

### 💻 | Optional Packages:
- `com.protonvpn.www` - Connecting VPNs.

(probably more I forgot...)

### ⬇️ | Installing

#### 📦 | Installing Dependencies

Please use the package manager you use for your distribution. I've only tested this in [Bazzite](https://bazzite.gg) and it works flawlessly. If you're using atomic desktop. Please prioritize `rpm-ostree` last, `brew` second, and `flatpak` first.

Once all dependencies have been finished downloading, run these commands in your terminal to finish off everything:
```bash
git clone https://github.com/Daveberry-Stuff/Daves-Labwc-Config
cd MiniBox
rm .git
chmod +x install.sh
bash install.sh
```

And, it's going to automatically install and back up everything for you.

### ⚠️ | Caution
Some of the packages that are listed **ARE FROM FLATHUB**. Please install `com.github.PintaProject.Pinta`, `org.videolan.VLC`, `com.visualstudio.code`, and `com.protonvpn.www` from flathub. If you wish, you can make them to use outside of flatpak.

Adding permission for `/etc/sudoers.d/` might not work perfectly. Please check the file by using `sudo cat /etc/sudoers.d/daves-labwc-config` and check if there's anything in there. If not, please add these lines yourself.
```text
{YourUsername} ALL=(root) NOPASSWD: /home/{YourUsername}/scripts/vpn-helper.sh
{YourUsername} ALL=(root) NOPASSWD: /home/{YourUsername}/scripts/ddc-helper.sh
{YourUsername} ALL=(root) NOPASSWD: /usr/bin/ddcutil
```
Please enter with sudo using nano or vim.

This is entirely coded by AI ([Gemini Thinking 3.0](https://gemini.google.com)) and [Daveberry](https://daveberry.netlify.app) (me). Don't fear, the code is entirely perfect and I've had no issues trying to daily drive it at all. So, you're fine trying to daily drive it.
