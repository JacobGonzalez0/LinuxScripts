#!/bin/bash

#Get the necessary components
apt-get update
apt-get install mate-desktop-environment-core mate-terminal tigervnc-standalone-server -y
apt-get install xfe -y
apt-get clean

#Setup the necessary files
mkdir ~/.vnc
wget https://raw.githubusercontent.com/EXALAB/AnLinux-Resources/master/Scripts/DesktopEnvironment/Apt/Mate/xstartup -P ~/.vnc/
wget https://raw.githubusercontent.com/EXALAB/AnLinux-Resources/master/Scripts/DesktopEnvironment/Apt/Mate/vncserver-start -P /usr/local/bin/
wget https://raw.githubusercontent.com/EXALAB/AnLinux-Resources/master/Scripts/DesktopEnvironment/Apt/Mate/vncserver-stop -P /usr/local/bin/

chmod +x ~/.vnc/xstartup
chmod +x /usr/local/bin/vncserver-start
chmod +x /usr/local/bin/vncserver-stop

#Get display working
echo "export DISPLAY=":1"" >> /etc/profile
source /etc/profile

#Get other packages
apt install firefox-esr openssh xcopy git default-jdk novnc sudo nano gedit -y
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
apt install apt-transport-https -y
apt update
sudo apt install code -y

echo "Setting up user"
adduser pon
adduser pon sudo

echo "Everything should be setup"
su pon



