#!/bin/bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";

install_arch() {
    sudo pacman -S zsh htop steam neofetch brightnessctl blueman code

    sudo systemctl enable bluetooth

    echo '**Waiting for bluetooth service to start...'
    sleep 2
    blueman &
    # TODO add input for installing additional work packages 
    # install work deps
    # sudo pacman -S postgres ruby-pg cmake dbeaver nvm jdk-openjdk

    # Setup oh-my-zsh
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    echo "**ZSH installed sucessfully! Waiting to add addons..."
    sleep 1
    # Add auto complete and syntax highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

    # install optimus-mananger and opitmus-qt for system tray icon
    # https://discovery.endeavouros.com/nvidia/optimus-manager-for-nvidia/2021/03/
    echo '**Installing optimus manager...'
    yay -S optimus-manager optimus-manager-qt

    echo '**Copying over prime-run executable to /usr/local/bin...'
    cp $SCRIPT_DIR/prime-run /usr/local/bin

    return 0
}

clone_i3() {
    echo "Copying config..."
    cp $SCRIPT_DIR/i3/config $HOME/.config/i3/config
    echo "Copying scripts..."
    cp $SCRIPT_DIR/i3/scripts/tray.sh $HOME/.config/i3/scripts/
    cp $SCRIPT_DIR/configs/monitor.sh $HOME/.screenlayout
}

echo "Welcome to Nate's auto-installer  of important things (WIP) for GNU/Linux systems"
read -p 'Are you running an Arch-based system?' RESP

if [ $RESP = "y" ] || [ $RESP = "Y" ]
then
    echo "Good choice! Let's get some important things set up..."
    install_arch

    # $? contains the return status of the most recent command or function
    if [ $? = 0 ]
    then
        echo "Success!! Your system should have some of the goods it needs now."
    else 
        echo "Something went awry, sorry about that..."
        return 1
    fi
elif [ $RESP = "n" ] || [ $RESP = "N" ]
then
    echo "Fool, run arch, btw..."
else
    echo "Unrecognized response, looking for 'y' or 'n'"
fi

## Setup i3 config and scripts
read -p 'Are you running i3-wm and would like to clone the config?' RESP
if [ $RESP = "y" ] || [ $RESP = "Y" ]
then
    clone_i3
    # $? contains the return status of the most recent command or function
    if [ $? = 0 ]
    then
        echo "Success!! Your system accepted the i3 configs."
    else 
        echo "Something went awry, sorry about that..."
        return 1
    fi
elif [ $RESP = "n" ] || [ $RESP = "N" ]
then
    echo "Too bad, i3 is nice..."
else
    echo "Unrecognized response, looking for 'y' or 'n'"
fi