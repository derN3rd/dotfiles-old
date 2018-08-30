#!/usr/bin/env bash

clitools="make
          zsh
          autojump
          curl
          tmux
          git
          htop
          xclip
          screenfetch
          dos2unix
          vim
          tree"

guitools="xorg
          virtualbox
          vagrant
          feh
          rofi
          scrot
          arandr
          lxappearance
          gtk-chtheme
          thunar
          conky
          pavucontrol
          compton
          blueman
          xdotool
          xsel"

install_ubuntu_cli_tools() {
    sudo add-apt-repository -y ppa:aacebedo/fasd
    sudo apt-get update
    sudo apt-get install -y $clitools \
         build-essential \
         fasd \
         qt4-qtconfig
}

install_arch_cli_tools() {
    yaourt -S --noconfirm fasd
    sudo pacman -S --noconfirm $clitools \
         openssh \
         qtconfig-qt4
}

install_ubuntu_gui_tools() {
    sudo apt install -y $guitools \
         xinit \
         fonts-font-awesome \
         unity-tweak-tool
}

install_arch_gui_tools() {
    yaourt -S --noconfirm \
         ttf-font-awesome \
         playerctl

    sudo pacman -S --noconfirm $guitools \
         xorg-xinit \
         xorg-twm \
         xorg-xprop \
         xorg-xwininfo \
         rxvt-unicode \
         pulseaudio \
         pulseaudio-alsa \
         pulseaudio-bluetooth
}

ask() {
    # http://djm.me/ask
    while true; do

        if [ "${2:-}" = "Y" ]; then
            prompt="Y/n"
            default=Y
        elif [ "${2:-}" = "N" ]; then
            prompt="y/N"
            default=N
        else
            prompt="y/n"
            default=
        fi

        read -p "$1 [$prompt] " REPLY

        if [ -z "$REPLY" ]; then
            REPLY=$default
        fi

        case "$REPLY" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac
    done
}

ask "is your package manager apt?" N && system=ubuntu
if [[ -z $system ]]; then ask "is your package manager pacman?" N && system=arch; fi
if [[ "$system" = "arch" ]]; then ask "install yaourt?" N && yaourt=true; fi
ask "install cli tools?" N && cli=true
ask "install gui tools?" N && gui=true
ask "install dotfiles?" N && dotfiles=true
ask "install atom?" N && atom=true
ask "install nodejs?" N && nodejs=true
ask "install java?" N && java=true
ask "install clojure?" N && clojure=true
ask "install vim-plugins?" N && vim=true
ask "install spacemancs?" N && spacemacs=true
ask "install i3-gaps?" N && i3gaps=true
ask "install powerlinefonts?" N && fonts=true
ask "install base16 colors?" N && base16=true
ask "install arc-theme?" N && arc=true
ask "enable sudo without password?" N && nopass=true
ask "set zsh as default shell?" N && zsh=true
ask "turn off grub2 quiet splash?" N && splash=true
echo
ask "proceed?" || exit

if [[ "$yaourt" = true ]]; then
    echo "-> installing yaourt"
    sudo touch /etc/pacman.conf
    grep "archlinuxfr" /etc/pacman.conf &> /dev/null || printf "[archlinuxfr]\nSigLevel = Never\nServer = http://repo.archlinux.fr/\$arch\n" | sudo tee -a /etc/pacman.conf
    sudo pacman -Sy --noconfirm yaourt
fi

if [[ "$nopass" = true ]]; then
    echo "-> editing /etc/sudoers"
    echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | (sudo EDITOR="tee -a" visudo)
fi

if [[ "$cli" = true ]]; then
    echo " ->installing cli tools"
    case "$system" in
        arch)
            install_arch_cli_tools
            ;;
        ubuntu)
            install_ubuntu_cli_tools
            ;;
    esac
fi

if [[ "$gui" = true || "$i3gaps" = true ]]; then
    echo "-> installing gui tools"
    case "$system" in
        arch)
            install_arch_gui_tools
            ;;
        ubuntu)
            install_ubuntu_gui_tools
            ;;
    esac
fi

if [[ "$dotfiles" = true ]]; then
    echo "-> installing dotfiles"
    mkdir -p ~/.{atom,ssh}
    mkdir -p ~/.config/{i3,i3status,i3blocks,i3lock}
    mkdir -p ~/.config/Code/User
    mkdir -p ~/.local/share/fonts
    mkdir -p ~/.vim/{autoload,bundle,swapfiles}

    touch ~/.dotfiles/scripts/xrandr.sh
    touch ~/.dotfiles/.Xresources.d/i3wm
    touch ~/.ssh/config

    grep "ServerAliveInterval" ~/.ssh/config &> /dev/null || printf "Host *\n  ServerAliveInterval 60\n" >> ~/.ssh/config && chmod 600 ~/.ssh/config

    ln -sf ~/.dotfiles/.{bashrc,hushlogin,inputrc,spacemacs,tmux.conf,vimrc,zshrc} ~/
    ln -sf ~/.dotfiles/.xinitrc ~/
    ln -sf ~/.dotfiles/.xinitrc ~/.xsession
    ln -sf ~/.dotfiles/.xinitrc ~/.xsessionrc
    ln -sf ~/.dotfiles/atom/* ~/.atom/
    ln -sf ~/.dotfiles/vscode/* ~/.config/Code/User/
    ln -sf ~/.dotfiles/i3/i3.conf ~/.config/i3/config
    ln -sf ~/.dotfiles/i3/i3blocks.conf ~/.config/i3blocks/config
    ln -sf ~/.dotfiles/i3/i3status.conf ~/.config/i3status/config

    which zsh &> /dev/null || {
      case "$system" in
          arch)
              sudo pacman -S zsh
              ;;
          ubuntu)
              sudo apt-get install zsh
              ;;
      esac
    }

    git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.config/oh-my-zsh 2> /dev/null

    sudo chsh -s /usr/bin/zsh $USER

    if [ ! -f $HOME/.vim/autoload/pathogen.vim ]; then
       curl https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim -o ~/.vim/autoload/pathogen.vim
    fi
fi

if [[ "$atom" = true ]]; then
    case "$system" in
        arch)
            sudo pacman -S atom
            ;;
        ubuntu)
            url=$(curl https://atom.io/download/deb | grep -Po 'href="(.+)"' | sed -r "s/href=\"(.*?)\?.*/\1/")
            curl $url -o ~/Downloads/atom-amd64.deb
            sudo dpkg -i ~/Downloads/atom-amd64.deb
            unset url
            ;;
    esac
fi

if [[ "$vim" = true ]]; then
    echo "-> installing vim-plugins"
    which vim &> /dev/null || sudo apt-get install vim
    mkdir -p ~/.vim/bundle
    cd ~/.vim/bundle
    git clone https://github.com/tpope/vim-sensible.git 2> /dev/null
    git clone https://github.com/jiangmiao/auto-pairs.git 2> /dev/null
    git clone https://github.com/pangloss/vim-javascript.git 2> /dev/null
    git clone https://github.com/mxw/vim-jsx.git 2> /dev/null
    git clone https://github.com/rstacruz/sparkup.git 2> /dev/null
    cd ~/.vim/bundle/sparkup
    make vim-pathogen
    cd ~
fi

if [[ "$spacemacs" = true ]]; then
    echo "-> installing spacemacs"
    which emacs &> /dev/null || {
      case "$system" in
          arch)
              sudo pacman -S emacs-nox
              ;;
          ubuntu)
              sudo apt-get install emacs-nox
              ;;
      esac
    }

    mv -f ~/.emacs.d ~/.emacs.d.bak 2> /dev/null
    mv -f ~/.emacs ~/.emacs.bak 2> /dev/null
    git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
fi

if [[ "$fonts" = true ]]; then
    echo "-> installing powerlinefonts"
    git clone https://github.com/powerline/fonts.git ~/.config/powerlinefonts 2> /dev/null
    chmod +x ~/.config/powerlinefonts/install.sh
    ~/.config/powerlinefonts/install.sh
fi

if [[ "$base16" = true ]]; then
    echo "-> installing base16 colors"
    git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell 2> /dev/null
    /bin/zsh -i -c "base16_twilight"
fi

if [[ "$nodejs" = true ]]; then
    echo "-> installing nodejs"
    case "$system" in
        arch)
            sudo pacman -S --noconfirm nodejs npm
            ;;
        ubuntu)
            curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
            sudo apt-get install -y nodejs
            ;;
    esac

    npm config set prefix '~/.npm-packages'
    npm i -g n
fi

if [[ "$java" = true || "$clojure" = true ]]; then
    echo "-> installing java8"
    case "$system" in
        arch)
            sudo pacman -S --noconfirm jdk8-openjdk openjdk8-doc openjdk8-src
            ;;
        ubuntu)
            sudo apt-get install -y openjdk-8-jdk openjdk-8-doc openjdk-8-source
            ;;
    esac
fi

if [[ "$clojure" = true ]]; then
    echo "-> installing clojure (leininigen & boot)"
    sudo bash -c "cd /usr/local/bin && curl -O https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && chmod a+x lein && lein"
    sudo bash -c "cd /usr/local/bin && curl -fsSLo boot https://github.com/boot-clj/boot-bin/releases/download/latest/boot.sh && chmod 755 boot"
fi

if [[ "$spash" = true ]]; then
    echo "-> disabling quiet splash"
    sudo sed -e "s/quiet\ssplash//" -i /etc/default/grub
    sudo update-grub2
fi

if [[ "$i3gaps" = true ]]; then
    echo "-> installing i3-gaps"
    mkdir -p ~/.config/i3
    mkdir -p ~/.config/i3lock
    mkdir -p ~/.config/i3blocks
    mkdir -p ~/.config/i3status

    case "$system" in
        arch)
            yaourt -S --noconfirm \
                 i3-gaps \
                 i3lock \
                 i3blocks \
                 acpi \
                 bc \
                 lm_sensors \
                 openvpn \
                 playerctl \
                 sysstat

            sudo pacman -S --noconfirm \
                 i3lock
            ;;
        ubuntu)
            sudo apt install -y libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev xutils-dev autoconf pkgconf libtool gtk-doc-tools libgtk-3-dev gobject-introspection \
            i3status \
            i3lock \
            i3blocks

            cd /tmp

            curl https://github.com/acrisci/playerctl/releases/download/v0.5.0/playerctl-0.5.0_amd64.deb -o playerctl.deb
            sudo dpkg -i ./playerctl.deb

            git clone https://github.com/Airblader/xcb-util-xrm
            cd xcb-util-xrm
            git submodule update --init
            ./autogen.sh --prefix=/usr
            make
            sudo make install

            cd /tmp

            git clone https://www.github.com/Airblader/i3
            cd i3
            git checkout gaps && git pull
            autoreconf --force --install
            rm -rf build/
            mkdir -p build && cd build/
            ../configure --prefix=/usr --sysconfdir=/etc
            make
            sudo make install

            cd ~
            ;;
    esac
fi

if [[ "$arc" = true ]]; then
    echo "-> installing arc-theme"
    case "$system" in
        arch)
            yaourt -S --noconfirm arc-gtk-theme arc-icon-theme
            ;;
        ubuntu)
            wget http://download.opensuse.org/repositories/home:Horst3180/xUbuntu_16.04/Release.key
            sudo apt-key add - < Release.key
            sudo apt-get update

            sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/ /' > /etc/apt/sources.list.d/arc-theme.list"
            sudo apt-get update
            sudo apt-get install -y arc-theme
            ;;
    esac
fi

echo '-> installation finished'

if [[ "$i3gaps" = true ]]; then
  echo '-> reboot your system'
  echo '-> run lxappearance, gtk-chtheme, qtconfig and pavucontrol'
fi
