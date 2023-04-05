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
        (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" ') >> $HOME/.profile
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
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

if [  "$(uname)" == "Darwin" ]
then
    echo "installing mac apps and casks"
    brew install --cask expressvpn obsidian font-source-code-pro powershell git-credential-manager-core rar google-chrome rectangle-pro iterm2 superkey mactex visual-studio-code miniconda
    # set up a working conda
    conda init "$(basename "${SHELL}")"
    conda create --name 3point10 python=3.10 anaconda pyarrow pip ipykernel notebook  nb_conda_kernels 
    conda activate 3point10
    conda install -c conda-forge jupyter_contrib_nbextensions rise plotnine stata_kernel 
    python -m ipykernel install --user --name 3point10
    jupyter contrib nbextension install --user
    #python -m stata_kernel.install
    pip install wrds
    pip install mapply
fi
# TODO: set  this up so it works alittle more of at all on both:
#
