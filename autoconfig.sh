#!/bin/bash

# ROOT CHECK
if [ "$EUID" -ne 0 ]
then
    echo -e "\x1b[1m[\x1b[31m-\x1b[0m] This script must be run as root!"
    exit
fi

# VARIABLES
target_term=lxterminal
target_user=marc
target_browser=brave-browser

# SCRIPT MAIN BODY
echo ""
echo "--------------------------------------------------"
echo "            - Auto configure script -"
echo "   This script need to run with root privileges."
echo "Please use this with a Ubuntu/Debian based distro."
echo "--------------------------------------------------"
echo ""

echo ""
echo "--------------------------------------------------"
echo "      - Installing Nvidia drivers and CUDA -"
echo "--------------------------------------------------"
echo ""

apt update
apt upgrade

# DOC: https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=22.04&target_type=deb_local

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.0.0/local_installers/cuda-repo-ubuntu2204-12-0-local_12.0.0-525.60.13-1_amd64.deb
dpkg -i cuda-repo-ubuntu2204-12-0-local_12.0.0-525.60.13-1_amd64.deb
cp /var/cuda-repo-ubuntu2204-12-0-local/cuda-*-keyring.gpg /usr/share/keyrings/

apt update
apt -y install cuda

ln -s /usr/local/cuda-12.0/bin/* /usr/bin

echo ""
echo "--------------------------------------------------"
echo "           - Installing dependencies -"
echo "--------------------------------------------------"
echo ""

# LXTERMINAL
apt update
apt -y upgrade
apt -y install $target_term

# I3 and I3BLOCKS
apt -y install i3 i3blocks

# NULTIPLE DEPEDENCIES
apt -y install feh compton numlockx volumeicon-alsa maim scrot xclip curl wget pulseaudio rxvt-unicode ffmpeg ncdu \
imagemagick xdotool libncurses5-dev git make xdg-utils pkg-config build-essential gcc-multilib vim pavucontrol lxappearance \
htop neofetch xinput gsettings-desktop-schemas nemo rsync rofi libnotify-bin playerctl mpv hexchat bat ntfs-3g gem libaio1 gdebi-core

# PYTHON(s)
apt -y install python2 python3 python3-pip
apt -y install python-is-python3

# SOLAAR
add-apt-repository ppa:solaar-unifying/stable -y && apt update && apt install solaar -y

echo ""
echo "--------------------------------------------------"
echo "           - Installing main apps -"
echo "--------------------------------------------------"
echo ""

# BRAVE
apt -y install apt-transport-https curl
curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-release.list
apt update && apt -y install brave-browser

# DISCORD
wget -O discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
gdebi -n discord.deb
rm discord.deb

# VISUAL STUDIO CODE
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
apt install apt-transport-https
apt update
apt install code

# VMWARE 17
wget https://download3.vmware.com/software/WKST-1700-LX/VMware-Workstation-Full-17.0.0-20800274.x86_64.bundle
chmod a+x VMware-Workstation-Full-17.0.0-20800274.x86_64.bundle
./VMware-Workstation-Full-17.0.0-20800274.x86_64.bundle


## Manual procedure to do
# generate a key
# openssl req -new -x509 -newkey rsa:2048 -keyout MOK.priv -outform DER -out MOK.der -nodes -days 36500 -subj "/CN=VMware/"
# import to UEFI database
# sudo mokutil --import MOK.der     (generate a password need next step)
# reboot system and import in UEFI BIOS
# (use same password)
# sudo shutdown -r now
# once rebooted need to sign the binaries
# sudo kmodsign sha256 ./MOK.priv ./MOK.der $(modinfo -n vmmon)
# sudo kmodsign sha256 ./MOK.priv ./MOK.der $(modinfo -n vmnet)
# on reboot new signed binaries used
# sudo shutdown -r now
# now good to start VMware and use any VM

# MULTIPLE (via APT)
apt -y install vlc deluge notepadqq

echo ""
echo "--------------------------------------------------"
echo "              - Installing i3 Gaps -"
echo "--------------------------------------------------"
echo ""

apt -y install meson libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev \
libxcb-util0-dev libxcb-icccm4-dev libyajl-dev \
libstartup-notification0-dev libxcb-randr0-dev \
libev-dev libxcb-cursor-dev libxcb-xinerama0-dev \
libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev \
autoconf libxcb-xrm0 libxcb-xrm-dev automake libxcb-shape0-dev

git clone https://www.github.com/Airblader/i3 && cd i3
mkdir -p build && cd build
meson ..
ninja
install ./i3 /bin/i3
cd ../..
rm -rf i3

apt -y remove meson libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb1-dev \
libxcb-icccm4-dev libyajl-dev libev-dev libxcb-xkb-dev libxcb-cursor-dev \
libxkbcommon-dev libxcb-xinerama0-dev libxkbcommon-x11-dev \
libstartup-notification0-dev libxcb-randr0-dev libxcb-xrm-dev libxcb-shape0-dev

echo ""
echo "--------------------------------------------------"
echo "           - Installing Vimix Theme -"
echo "--------------------------------------------------"
echo ""

# depedencies
apt -y install sassc

git clone https://github.com/vinceliuice/vimix-gtk-themes && cd vimix-gtk-themes
./install.sh -t ruby
cd ..
rm -rf vimix-gtk-themes

git clone https://github.com/vinceliuice/vimix-icon-theme && cd vimix-icon-theme
./install.sh -a
cd ..
rm -rf vimix-icon-theme

sed -i 's/gtk-theme-name=.*/gtk-theme-name=vimix-dark-ruby/g' /home/$target_user/.config/gtk-3.0/settings.ini
sed -i 's/gtk-icon-theme-name=.*/gtk-icon-theme-name=Vimix-Ruby-dark/g' /home/$target_user/.config/gtk-3.0/settings.ini

echo ""
echo "--------------------------------------------------"
echo "          - Installing Cybersec tools -"
echo "--------------------------------------------------"
echo ""

# Cutter
wget https://github.com/rizinorg/cutter/releases/download/v2.1.0/Cutter-v2.1.0-Linux-x86_64.AppImage -O cutter
chmod +x ./cutter
install ./cutter /usr/bin/cutter
rm ./cutter

# radare2
git clone https://github.com/radare/radare2 /opt/radare2
chmod 777 -R /opt/radare2/
old_path=$(pwd)
cd /opt/radare2/ && ./sys/install.sh
cd $(pwd)

# metasploit
snap install metasploit-framework

# Python 3 libs
python3 -m pip install Flask pwntools numpy pytesseract beautifulsoup4 pandas Pillow Scrapy asyncio pysqlite3 pipenv sagemath

# Postman
snap install postman

# hashcat GPU
apt -y install hashcat-nvidia

# other
echo "wireshark-common wireshark-common/install-setuid boolean true" | debconf-set-selections
apt -y install checksec wireshark gobuster nmap exiftool binwalk foremost audacity ghex dbeaver


echo ""
echo "--------------------------------------------------"
echo "          - Installing DevOps tools -"
echo "--------------------------------------------------"
echo ""

# Vagrant
snap install vagrant --classic

# ASDF
apt install curl git
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.2
echo '. $HOME/.asdf/asdf.sh' >> ~/.bashrc
echo '. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc

source ~/.bashrc

asdf plugin add terraform https://github.com/asdf-community/asdf-hashicorp.git
asdf install terraform latest
asdf plugin add kubectl https://github.com/asdf-community/asdf-kubectl.git
asdf install kubectl latest
asdf plugin add helm https://github.com/Antiarchitect/asdf-helm.git
asdf install helm latest

echo ""
echo "--------------------------------------------------"
echo "                - Other configs -"
echo "--------------------------------------------------"
echo ""

# install nerd fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/DroidSansMono.zip
unzip -o DroidSansMono.zip -d /usr/local/share/fonts/
fc-cache -fv
rm -f DroidSansMono.zip

# install noto font
apt install fonts-noto-color-emoji

# move config files
chmod -R 755 etc/
chown -R root: etc/
cp -ar etc/. /etc/

chmod -R 755 home_folder/
chown -R $target_user: home_folder/
cp -ar home_folder/. /home/$target_user/

chmod -R 755 usr/
chown -R $target_user: usr/
cp -ar usr/. /usr/

# change PS1
echo "PS1='\t ${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> /home/$target_user/.bashrc

# set Brave as default x web browser
xdg-mime default $target_browser.desktop x-scheme-handler/http

# set nemo "open in terminal context menu"
ln -fs $(which $target_term) /etc/alternatives/x-terminal-emulator

apt -y autoremove

echo ""
echo "--------------------------------------------------"
echo "             Configuration complete."
echo "         You can now remove this folder."
echo "--------------------------------------------------"
echo ""
