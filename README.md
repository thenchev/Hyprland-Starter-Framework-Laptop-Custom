# Hyprland Starter

To make it easy to start with Hyprland, you can find here a basic configuration and an installation script.

## Requirements

This script requires an Arch Linux based distribution. Tested on Arch Linux, Manjaro 

NVIDIA installation for Hyprland is not covered in this script. Please read: https://wiki.hyprland.org/Nvidia/

git must be installed.
```
sudo pacman -S git
```


## Packages

The script will install the following packages:

- hyprland 
- waybar 
- rofi 
- wofi #optional
- kitty #optional
- alacritty 
- dunst 
- dolphin 
- xdg-desktop-portal-hyprland 
- qt5-wayland 
- qt6-wayland 
- hyprpaper

## Installation

```
# Move to your home directory
cd

# Clone the packages
git clone https://gitlab.com/stephan-raabe/hyprland-starter.git

# You can also download the files and unzip it into your home folder

# Move into the folder
cd hyprland-starter

# Start the script
./1-install.sh
```
