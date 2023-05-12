#!/bin/bash
if [ "$(uname)" == "Darwin" ]
then
    echo "system is $(uname)"
    echo "checking system and prepping package manager"
else
    echo "system is $(uname)"
    echo "this is the Darwin script"
    exit 1
fi

## Step 1: setup oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# at this point the .zshrc is default, once git is set we will move to the one in the dotfiles

## Step 1 install `homebrew` if needed and check for updates
if ! command -v brew &> /dev/null
then 
    echo "brew not found, installing brew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "brew found"
fi

echo "check for updates" 
brew update

## Step 2 install all the formulae in formulae.txt
echo "install formulae from formulae.txt"
xargs brew  install < formulae.txt

## Step 3 install all the casks from casks.txt
echo "install casks from casks.txt"
xargs brew install --cask < casks.txt
eval "$(/usr/libexec/path_helper)"
## Step 4 set up an ssh key for the main github account, prompt to apply and
#then configure with main account credentials

# check for the keys:
if [ -e "$HOME/.ssh/id_rsa" ]
then 
	echo "ssh key already exists"
else
	# make an ssh key for the main github account, without passphrase, in the default location
	echo "ssh key not found creating one now"
	yes '' | ssh-keygen -t rsa -b 4096 -C "53531149+ArthurHowardMorris@users.noreply.github.com" -N ''
	eval "$(ssh-agent -s)"
	ssh-add ~/.ssh/id_rsa
	cat ~/.ssh/id_rsa.pub | pbcopy -selection c
	# prompt to place this in github
	read -p "Public key is now in the system clipboard. Go to https://github.com/settings/keys to add this to github. Ready to continue (y/n)?" choice
	case "$choice" in 
	  y|Y ) echo "yes";;
	  n|N ) echo "no";;
	  * ) echo "invalid";;
	esac
fi
# set the git config
git config --global user.email  "53531149+ArthurHowardMorris@users.noreply.github.com"
git config --global user.name "ArthurHowardMorris"

## Step 5 use conda to set up the anaconda stack (at py 11 now)
conda init "$(basename "$SHELL")"
echo "****************************************"
echo "* reloading zsh so we can use conda    *"
echo "* now check the install to this point  *"
echo "* and run the python env setup script  *"
echo "****************************************"
exec zsh -l
