#!/bin/bash
#  _   _                    ____  _             _             
# | | | |_   _ _ __  _ __  / ___|| |_ __ _ _ __| |_ ___ _ __  
# | |_| | | | | '_ \| '__| \___ \| __/ _` | '__| __/ _ \ '__| 
# |  _  | |_| | |_) | |     ___) | || (_| | |  | ||  __/ |    
# |_| |_|\__, | .__/|_|    |____/ \__\__,_|_|   \__\___|_|    
#        |___/|_|                                             
#  
# ----------------------------------------------------- 
clear

# Some colors
GREEN='\033[0;32m'
NONE='\033[0m'

# Check if package is installed
_isInstalledPacman() {
    package="$1";
    check="$(sudo pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")";
    if [ -n "${check}" ] ; then
        echo 0; #'0' means 'true' in Bash
        return; #true
    fi;
    echo 1; #'1' means 'false' in Bash
    return; #false
}

# Install required packages
_installPackagesPacman() {
    toInstall=();
    for pkg; do
        if [[ $(_isInstalledPacman "${pkg}") == 0 ]]; then
            echo "${pkg} is already installed.";
            continue;
        fi;
        toInstall+=("${pkg}");
    done;
    if [[ "${toInstall[@]}" == "" ]] ; then
        # echo "All pacman packages are already installed.";
        return;
    fi;
    printf "Package not installed:\n%s\n" "${toInstall[@]}";
    sudo pacman --noconfirm -S "${toInstall[@]}";
}

# Required packages for the installer
packages=(
    "wget"
    "unzip"
    "gum"
    "rsync"
)

echo -e "${GREEN}"
cat <<"EOF"
 _   _                  _                 _ 
| | | |_   _ _ __  _ __| | __ _ _ __   __| |
| |_| | | | | '_ \| '__| |/ _` | '_ \ / _` |
|  _  | |_| | |_) | |  | | (_| | | | | (_| |
|_| |_|\__, | .__/|_|  |_|\__,_|_| |_|\__,_|
       |___/|_|                             

EOF
echo -e "${NONE}"

# Synchronizing package databases
sudo pacman -Sy
echo ""

# Install required packages
echo ":: Checking that required packages are installed..."
_installPackagesPacman "${packages[@]}";
echo ""

# Double check rsync
if ! command -v rsync &> /dev/null; then
    echo ":: Force rsync installation"
    sudo pacman -S rsync --noconfirm
else
    echo ":: rsync double checked"
fi
echo ""

# Confirm Start
echo "WELCOME TO THE HYPRLAND STARTER INSTALLATION SCRIPT"
echo ""
echo "IMPORTANT: Backup existing configurations in .config if needed."
echo ""
if gum confirm "DO YOU WANT TO START THE INSTALLATION NOW?" ;then
    echo ":: Installing Hyprland and additional packages"
    echo ""
elif [ $? -eq 130 ]; then
    exit 130
else
    echo "Installation canceled."
    exit;
fi

# Install packages
sudo pacman -S hyprland waybar rofi wofi kitty alacritty dunst dolphin xdg-desktop-portal-hyprland qt5-wayland qt6-wayland hyprpaper chromium ttf-font-awesome

# Copy configuration
if gum confirm "DO YOU WANT TO COPY THE PREPARED dotfiles INTO .config? (YOU CAN ALSO DO THIS MANUALLY)" ;then
    rsync -a -I . ~/.config/
    echo ":: Configuration files successfully copied to ~/.config/"
elif [ $? -eq 130 ]; then
    exit 130
else
    echo "Installation canceled."
    echo "PLEASE NOTE: Open ~/.config/hypr/hyprland.conf to change your keyboard layout (default is us) and your screenresolution (default is preferred) if needed."
    echo "Then reboot your system!"
    exit;
fi

# Setup keyboard layout
if [ -f ~/.config/hypr/hyprland.conf ] ;then
    echo ":: Setup keyboard layout"
    echo "Start typing = Search, RETURN = Confirm, CTRL-C = Cancel"
    keyboard_layout=$(localectl list-x11-keymap-layouts | gum filter --height 15 --placeholder "Find your keyboard layout...")
    echo ""
    if [ -z $keyboard_layout ] ;then
        keyboard_layout="us" 
    fi
    SEARCH="kb_layout = us"
    REPLACE="kb_layout = $keyboard_layout"
    sed -i "s/$SEARCH/$REPLACE/g" ~/.config/hypr/hyprland.conf
    echo "Keyboard layout changed to $keyboard_layout"
    echo ""

    echo ":: Virtual Machine"
    if gum confirm "Are you running this script in a KVM virtual machine?" ;then

    fi
fi

# Done
echo ""
echo "DONE!"
echo "Open ~/.config/hypr/hyprland.conf to change your keyboard layout (default is us) and your screenresolution (default is preferred) if needed."
echo "Then reboot your system!"
