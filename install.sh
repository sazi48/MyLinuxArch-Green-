#!/bin/bash

# =========================================
# Automated Hyprland Dotfiles Installer
# =========================================

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [ "$EUID" -eq 0 ]; then
  echo -e "${RED}Please run as a regular user, not root.${NC}"
  exit 1
fi

echo -e "${GREEN}Starting installation...${NC}"

# 1. Base dependencies & AUR Helper
echo -e "${GREEN}[1/5] Installing base dependencies and yay...${NC}"
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm base-devel git wget curl

if ! command -v yay &> /dev/null; then
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    cd ~ && rm -rf /tmp/yay
fi

# 2. Interactive Prompts
echo -e "${YELLOW}Optional Applications:${NC}"
read -p "Install Telegram? (y/n): " install_tg
read -p "Install Obsidian? (y/n): " install_obsidian

# 3. Install Core Packages
echo -e "${GREEN}[2/5] Installing core packages (Hyprland, Waybar, Kitty, etc.)...${NC}"
CORE_PKGS="hyprland xdg-desktop-portal-hyprland waybar kitty fish dunst wofi yad sddm pipewire pipewire-pulse wireplumber blueman brightnessctl network-manager-applet ttf-jetbrains-mono-nerd grim slurp swappy wl-clipboard playerctl"
sudo pacman -S --needed --noconfirm $CORE_PKGS

# Install AUR specific packages
yay -S --needed --noconfirm waybar-git wlogout

if [[ "$install_tg" =~ ^[Yy]$ ]]; then
    yay -S --needed --noconfirm telegram-desktop-bin
fi

if [[ "$install_obsidian" =~ ^[Yy]$ ]]; then
    sudo pacman -S --needed --noconfirm obsidian
fi

# 4. Copying Configurations
echo -e "${GREEN}[3/5] Copying configuration files...${NC}"
mkdir -p ~/.config
for dir in hypr waybar kitty fish dunst wofi yad; do
    if [ -d "$dir" ]; then
        rm -rf ~/.config/$dir # Remove old config to prevent issues
        cp -r "$dir" ~/.config/
    fi
done

# Copy SDDM config
if [ -d "sddm.conf.d" ]; then
    sudo mkdir -p /etc/sddm.conf.d/
    sudo cp -r sddm.conf.d/* /etc/sddm.conf.d/
fi

# --- NEW WALLPAPER SETUP ---
echo -e "${GREEN}Setting up wallpapers...${NC}"
mkdir -p ~/Pictures/Wallpaper
if [ -f "Wallpaper/house.jpg" ]; then
    # Copy the wallpaper to the Pictures folder for hyprlock
    cp Wallpaper/house.jpg ~/Pictures/Wallpaper/house.jpg
    
    # Dynamically fix the path in hyprland.lua to point to the dotfiles folder
    # (Hyprland can read directly from the cloned repo)
    sed -i "s|WALLPAPER_PATH|$HOME/dotfiles/Wallpaper/house.jpg|g" ~/.config/hypr/hyprland.lua
    
    # Dynamically fix the path in hyprlock.conf (it requires absolute path to Pictures)
    sed -i "s|LOCKSCREEN_PATH|$HOME/Pictures/Wallpaper/house.jpg|g" ~/.config/hypr/hyprlock.conf
fi

# 5. Set Fish as default shell
if [[ "$SHELL" != "/usr/bin/fish" ]]; then
    echo -e "${GREEN}Changing default shell to fish...${NC}"
    sudo chsh -s /usr/bin/fish $USER
fi

# 6. Setup Welcome File
echo -e "${GREEN}[4/5] Setting up welcome message...${NC}"
cp Welcome.md ~/Welcome.md

# 7. Enable Services
echo -e "${GREEN}[5/5] Enabling services...${NC}"
sudo systemctl enable sddm
sudo systemctl enable bluetooth
systemctl --user enable pipewire pipewire-pulse wireplumber

echo -e "${GREEN}====================================================${NC}"
echo -e "${GREEN}      ✨INSTALLATION SUCCESSFULLY COMPLETED ✨      ${NC}"
echo -e "${GREEN}====================================================${NC}"
echo "Please reboot your system to apply all changes."

read -p "Reboot now? (y/n): " reboot_choice
if [[ "$reboot_choice" =~ ^[Yy]$ ]]; then
    sudo reboot
fi
