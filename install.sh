#!/bin/bash

# init
function pause(){
   read -p "$*"
}

# Reset
NC='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

working_path=$(pwd)
user=$(whoami)
echo -e "${BGreen}Welcome ${BRed}$user${BGreen}! you will configure your desktop with BSPWM"
echo -e "${BYellow}FIRST! Perform a full system upgrade --> press [Enter] key to continue..."
echo -e "-------------------------------------------------------------------------${NC}"
pause
sudo apt update && sudo apt upgrade -y
echo -e "${BGreen}Perform a full system upgrade [DONE]${NC}"
echo -e "${BGreen}###########################################################################"
echo -e "Ok, now we are ready to start...."
echo -e "###########################################################################${NC}"

echo -e "${BGreen}Press [Enter] key to continue...${NC}"
pause

# Install bspwm dependencies
echo -e "${BYellow}Installing bspwm...${NC}"
sudo apt install libxcb-xinerama0-dev libxcb-icccm4-dev libxcb-randr0-dev libxcb-util0-dev libxcb-ewmh-dev libxcb-keysyms1-dev libxcb-shape0-dev
sudo apt install bspwm
echo -e "${BGreen}Installing bspwm [DONE]${NC}"
echo "......................."
echo -e "${BYellow}Installing polybar...${NC}"
sudo apt install polybar
echo -e "${BGreen}Installing polybar [DONE]${NC}"

echo -e "${BYellow}Installing polybar themes...${NC}"
git clone --depth=1 https://github.com/adi1090x/polybar-themes.git
cd polybar-themes
chmod +x setup.sh
./setup.sh
echo -e "${BGreen} Installing polybar themes...[DONE]${NC}"

echo -e "${BYellow}Installing adittional tools...${NC}"
sudo apt install kitty zsh zsh-syntax-highlighting zsh-autosuggestions vim neovim nano bat rofi mc feh mlocate zip unzip imagemagick neofetch picom scrub fzf -y
echo -e "${BGreen} Installing additional tools [DONE]${NC}"

echo -e "${BYellow}Installing lsd...${NC}"
wget https://github.com/Peltoche/lsd/releases/download/0.23.1/lsd_0.23.1_amd64.deb
sudo apt install ./lsd_0.23.1_amd64.deb
echo -e "${BGreen} Installing lsd [DONE]${NC}"

echo -e "${BYellow}Installing powerlevel10k...${NC}"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo -e "${BGreen}Installing powerlevel10k [DONE]${NC}"

echo -e "${BYellow}Installing neovim theme...${NC}"
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
echo -e "${BGreen}Installing neovim theme [DONE]${NC}"

echo -e "${BYellow}Setting ZSH as user & root shell...${NC}"
sudo usermod --shell /bin/zsh $user
sudo usermod --shell /bin/zsh root
echo -e "${BGreen}Setting ZSH as user & root shell...${NC}"

echo -e "${BYellow}Install zsh SUDO plugin...${NC}"
sudo mkdir -p /usr/share/zsh-sudo
sudo wget -O /usr/share/zsh-sudo/sudo.plugin.zsh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh
echo -e "${BGreen}Install zsh SUDO plugin [DONE]${NC}"

#echo "Updating hostname..."
#echo "127.0.0.1    localhost" >> /etc/hostname
#echo "::1          localhost" >> /etc/hostname
#echo "127.0.0.1    bruenor.localhost bruenor" >> /etc/hostname

echo -e "${BYellow}Coping .config files...${NC}"
mkdir -p ~/.config
cp -rf $working_path/.config/* ~/.config/
cp -f $working_path/.zshrc ~/.zshrc
cp -f $working_path/.xinitrc ~/.xinitrc
cp -f $working_path/.p10k.zsh ~/.p10k.zsh
echo -e "${BGreen}Coping .config files...[DONE]${NC}"

echo -e "${BYellow}Font instalation...${NC}"
echo "Creating TTF and OTF fonts dirs..."  
TTF_FONT_DIR="/usr/local/share/fonts/ttf/"
if [ ! -d "$TTF_FONT_DIR" ]; then
  sudo mkdir -p /usr/local/share/fonts/ttf/
fi
OTF_FONT_DIR="/usr/local/share/fonts/otf/"
if [ ! -d "$OTF_FONT_DIR" ]; then
  sudo mkdir -p /usr/local/share/fonts/otf/
fi

echo "Installing fonts dirs..."  
sudo cp -r $working_path/fonts/ttf/* /usr/local/share/fonts/ttf/
sudo cp -r $working_path/fonts/otf/* /usr/local/share/fonts/otf/
echo "Updating fonts cache..."
fc-cache -f
echo -e "${BGreen}Font instalation [DONE]${NC}"

#TODO: equal ROOT USER
echo -e "${BYellow}Configuring root console...${NC}"
sudo ln -s -f /home/$user/.zshrc /root/.zshrc
sudo ln -s -f /home/$user/.p10k.zsh /root/.p10k.zsh
echo -e "${BGreen}Configuring root console [DONE]${NC}"

echo -e "${BGreen}###########################################################################"
echo -e "Ok, all stuff done, please reeboot the system"
echo -e "###########################################################################"
echo -e "${BRed}Press [Enter] key to reboot"
pause
sudo reboot
