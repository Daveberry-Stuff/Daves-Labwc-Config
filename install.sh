#!/bin/bash

echo "Running \"sudo\" because this bash script needs it to be able to configure everything properly."
echo "We will NEVER take your password and put it somewhere else. The code is completely safe and you are able to see it."
echo "https://github.com/Daveberry-Stuff/Daves-Labwc-config"
sudo echo

echo "Starting the install script in 5 seconds! Press CTRL + C to cancel."
echo "5..."
sleep 1
echo "4..."
sleep 1
echo "3..."
sleep 1
echo "2..."
sleep 1
echo "1..."
sleep 1

echo "Starting..."
echo

# Backs up your old configs.
mv /home/$USER/.config/labwc/rc.xml /home/$USER/.config/labwc/rc.xml.bak && echo "Backed up your old rc.xml."
mv /home/$USER/.config/labwc/autostart /home/$USER/.config/labwc/autostart.bak && echo "Backed up your old autostart."

# Actually moves the files to the specific folder.
mv .config /home/$USER/ && echo "Sucsessfully moved Minibox's config to /home/$USER/.config/"
mv Pictures /home/$USER/Pictures/ && echo "Sucsessfully moved Minibox's wallpaper to /home/$USER/Pictures/"
mv scripts /home/$USER/ && echo "Sucsessfully moved Minibox's scripts to /home/$USER/"
mv vpnconfig /home/$USER/ && echo "Sucsessfully moved Minibox's scripts to /home/$USER/"

echo "swaybg -i "/home/$USER/Pictures/Wallpapers/High Sierra.jpg" -m fill &" >> /home/$USER/.config/labwc/autostart
echo "waybar &" >> /home/$USER/.config/labwc/autostart

# Make the scripts executable.
chmod +x /home/$USER/scripts/ddc-helper.sh && echo "Sucsessfully made ddc-helper.sh executable."
chmod +x /home/$USER/scripts/update-ovpn-files.sh && echo "Sucsessfully made update-ovpn-files.sh executable."
chmod +x /home/$USER/scripts/vpn-helper.sh && echo "Sucsessfully made vpn-helper.sh executable."
chmod +x /home/$USER/.config/labwc/autostart && echo "Sucsessfully made autostart executable."

# Make ddcutil, vpn-helper.sh and ddc-helper.sh use NO passwords for sudo.
sudo rm -f /etc/sudoers.d/daves-labwc-config
sudo echo "$USER ALL=(root) NOPASSWD: /home/$USER/scripts/vpn-helper.sh" >> /etc/sudoers.d/daves-labwc-config  && echo "Sucsessfully made vpn-helper.sh work without sudo password. (CRUTIAL)"
sudo echo "$USER ALL=(root) NOPASSWD: /home/$USER/scripts/ddc-helper.sh" >> /etc/sudoers.d/daves-labwc-config  && echo "Sucsessfully made ddc-helper.sh work without sudo password. (CRUTIAL)"
sudo echo "$USER ALL=(root) NOPASSWD: /usr/bin/ddcutil" >> /etc/sudoers.d/daves-labwc-config  && echo "Sucsessfully made ddcutil work without sudo password. (CRUTIAL)"
echo "If all of these failed, please do it manually."

echo "======================================"
echo "Finished! Now, run LabWC session."
echo "======================================"
