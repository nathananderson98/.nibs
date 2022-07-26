#!/bin/bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";

export RUNZSH="no"

handle_input() {
    if [ $RESP = "y" ] || [ $RESP = "Y" ]
    then
        $1

        # $? contains the return status of the most recent command or function
        if [ $? = 0 ]
        then
            echo "Success!!"
        else 
            echo "Something went awry, sorry about that..."
            return 1
        fi
    elif [ $RESP = "n" ] || [ $RESP = "N" ]
    then
        echo "Skipping step..."
    else
        echo "Unrecognized response, looking for 'y' or 'n'"
    fi
}

install_arch_deps() {
    sudo pacman -S zsh htop steam neofetch brightnessctl blueman code steam kate python-pip libreoffice-still gimp

    # Installing xwinwrap for background, timeshift for backups
    yay -S xwinwrap-git timeshift

    # echo '**Installing optimus manager...'
    # install optimus-mananger and opitmus-qt for system tray icon
    # https://discovery.endeavouros.com/nvidia/optimus-manager-for-nvidia/2021/03/
    #yay -S optimus-manager optimus-manager-qt

    #echo '**Copying over prime-run executable to /usr/local/bin...'
    #sudo cp $SCRIPT_DIR/prime-run /usr/local/bin

    echo '**Setting up bluetooth applet / service...'
    sudo systemctl enable bluetooth

    echo '**Waiting for bluetooth service to start...'
    sleep 2
    blueman-applet &
    return 0
}

install_work_arch_deps() {
    sudo pacman -S docker docker-compose cmake dbeaver jdk-openjdk sops jupyter-notebook postgresql-libs terraform

    yay -S slack-desktop gvm nvm rbenv ruby-build

    echo "Installing awscli into home directory"
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "$HOME/awscliv2.zip"
    unzip $HOME/awscliv2.zip
    sudo $HOME/aws/install
    aws --version

    echo "Adding user to the docker group"
    sudo usermod -aG docker nathana # TODO switch to UID variable

    sudo systemctl enable docker
    sudo systemctl start docker

    # install latest node version and set default
    # TODO this needs to be added after switching over to zsh, requires sourcing scripts
    #nvm install --lts

    # install ruby version # TODO add ask for which version of ruby to install
    rbenv install 3.0.3
    rbenv global 3.0.3
    # nvm alias default 16

    # TODO install go version
    gvm install go1.4 -B
    gvm use go1.4
    gvm install go1.16
    gvm use go1.16

    return 0
}

install_zsh() {
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    echo "**ZSH installed sucessfully! Now for zsh addons..."
    sleep 1
    # Add auto complete and syntax highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

    # TODO copy over .zshrc

    return 0
}

clone_i3() {
    echo "Copying config..."
    cp $SCRIPT_DIR/i3/config $HOME/.config/i3/config
    echo "Copying scripts..."
    cp $SCRIPT_DIR/i3/scripts/bg.sh $HOME/.config/i3/scripts/
    echo "Copying backgrounds..."
    cp -r $SCRIPT_DIR/i3/backgrounds $HOME/.config/i3/
    #cp $SCRIPT_DIR/configs/monitor.sh $HOME/.screenlayout
}

echo "Welcome to Nate's auto-installer  of important things (WIP) for GNU/Linux systems running arch"

read -p 'Would you like to get some initial packages installed?' RESP

handle_input "install_arch_deps"

read -p 'Would you like to install zsh and copy over the config?' RESP

handle_input "install_zsh"

read -p 'Would you like to install additional "work" related packages?' RESP

handle_input "install_work_arch_deps"

read -p 'Would you like to copy over i3 configs? This is only applicable when running i3-gaps as your wm.' RESP

handle_input "clone_i3"

git config pull.rebase false

echo "Complete!"

echo "You should definitely restart your pc right now..."


# TODO add natural scrolling to libinput
# install gtk theme
# install clear font
# copy over picom.conf
# add touchegg for swipe gestures
# add picom.conf file copy to $HOME/.config/
# git config --global user.email "nathananderson98@gmail.com"
# git config --global user.name "Nathan Anderson"
