#!/bin/bash

# list of packages to install
# PACKAGES=("git")
echo "checking system and prepping package manager"
echo "system is $(uname)"
# if this is a mac then check for homebrew and install or update
if [  "$(uname)" == "Darwin" ]
then
    if ! command -v brew &> /dev/null
    then 
        echo "brew not found, installing brew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "brew found"
    fi
elif [ "$(uname)" == "Linux" ]
then 
    echo "check for updates"
    sudo apt-get install build-essential procps curl file git
    apt-get update
    if ! command -v brew &> /dev/null
    then
        echo "brew not found, installing brew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo  "brew found"
    fi
else
    echo "unsupported operating system"
    exit 1
fi

echo "check for updates"
brew update

echo "install formulae from formulae.txt"
xargs brew  install < formulae.txt

# function to install packages on linux or mac
# install packages
# PACKAGES=("git" "make"  "pandoc" "tree" "auto-jump" "latex-diff" "tmux" "zsh-vi-mode")
# echo "installing packages"
#
# if [  "$(uname)" == "Darwin" ]
# then 
#     brew install ${PACKAGES[@]}
# elif [ "$(uname)" == "Linux" ]
# then 
#     apt-get install ${PACKAGES[@]}
# else
#     echo "unsupported operating system"
#     exit 1
# fi
#
# # CASKS=("obsidian"
