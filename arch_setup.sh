#!/bin/bash

# install the necessities
sudo pacman -S zsh htop steam neofetch
# Setup oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Add auto complete and syntax highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# install optimus-mananger and opitmus-qt for system tray icon
# https://discovery.endeavouros.com/nvidia/optimus-manager-for-nvidia/2021/03/
yay -S optimus-manager
yay -S optimus-manager-qt