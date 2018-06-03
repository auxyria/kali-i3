#!/bin/bash

# Get current dir
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

####################
# .gitconfig and .gitignore_global
####################

ln -sfv "$DOTFILES_DIR/.gitconfig" ~
ln -sfv "$DOTFILES_DIR/.gitignore_global" ~

####################
# Hyper.js
####################

ln -sfv "$DOTFILES_DIR/.hyper.js" ~

####################
# ZSH
####################

install_zsh () {
  # Test to see if Zsh is installed
  if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
    # Install Oh My Zsh if it isn't already present
    if [[ ! -d ~/.oh-my-zsh/ ]]; then
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    fi
    # Set the default shell to Zsh if it isn't currently set
    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
      sudo chsh -s $(which zsh)
    fi
  else
  	echo "Zsh not installed, skipping."
  fi
# I'm leaving the remainder of this function for another time.
#   else
#     # If zsh isn't installed, get the platform of the current machine
#     platform=$(uname);
#     echo "ZSH is not installed"
#     # If the platform is Linux, try an apt-get to install zsh and then recurse
#     # if [[ $platform == 'Linux' ]]; then
#     #   if [[ -f /etc/redhat-release ]]; then
#     #     sudo dnf install zsh
#     #     install_zsh
#     #   fi
#     #   if [[ -f /etc/debian_version ]]; then
#     #     sudo apt-get install zsh
#     #     install_zsh
#     #   fi
#     # # If the platform is OS X, tell the user to install zsh :)
#     # elif [[ $platform == 'Darwin' ]]; then
#     #   echo "We'll install zsh, then re-run this script!"
#     #   brew install zsh
#     #   exit
#     # fi
#   fi
}

# Run the zsh_install function
# Disabled until I have time to get it right.
install_zsh

# Specify ZSH custom directory
ZSH_CUSTOM=$HOME/.oh-my-zsh/custom

# Install the ZSH spaceship theme if not already installed
if [[ ! -d $HOME/.oh-my-zsh/custom/themes/spaceship-prompt ]]; then
	git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
	ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
fi

# Install the ZSH syntax highlighting plugin if it's not already installed
if [[ ! -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]]; then
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Symlink .zshrc
ln -sfv "$DOTFILES_DIR/.zshrc" ~
ln -sfv "$DOTFILES_DIR/.zsh_exports" ~
ln -sfv "$DOTFILES_DIR/.zsh_aliases" ~

####################
# VS Code
####################

if [[ ! -d ~/.config/Code/User ]]; then mkdir ~/.config/Code/User; fi
ln -sfv "$DOTFILES_DIR/vscode/settings.json" ~/.config/Code/User/

####################
# Atom
####################

# To create a list of your current packages, use the following command:
# apm list --bare --installed --dev false > packages.txt

# Set up symlinks for config files
if [[ ! -d ~/.atom ]]; then mkdir ~/.atom/; fi
ln -sfv "$DOTFILES_DIR/atom/config.cson" ~/.atom/
ln -sfv "$DOTFILES_DIR/atom/styles.less" ~/.atom/

# Install packages based on packages.txt
# Workaround to skip installation if first package exists
# See https://github.com/atom/apm/issues/170
if [[ ! -d "$HOME/.atom/packages/Zen" ]]; then
	if [ -x "$(command -v apm)" ]; then
		apm install --packages-file $DOTFILES_DIR/atom/packages.txt
	elif [ -x "$(command -v apm-beta)" ]; then		# Workaround for `apm` vs `apm-beta` binary
		apm-beta install --packages-file $DOTFILES_DIR/atom/packages.txt
	else
		echo "Atom not installed, skipping."
	fi
else
	echo "Atom packages already installed, skipping."
fi
