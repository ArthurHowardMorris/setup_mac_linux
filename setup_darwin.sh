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

## Step 1 install `homebrew` if needed and check for updates
if ! command -v brew &> /dev/null
then 
    echo "brew not found, installing brew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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

## Step 4 set up an ssh key for the main github account, prompt to apply and
#then configure with main account credentials

# make an ssh key for the main github account, without passphrase, in the default location
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
# set the git config
git config --global user.email  "53531149+ArthurHowardMorris@users.noreply.github.com"
git config --global user.name "ArthurHowardMorris"

## Step 5 use conda to set up the anaconda stack (at py 11 now)
conda init "$(basename "{SHELL}")"
echo "reloading zsh so we can use conda"
exec zsh -l
echo "now setting up an anaconda stack with python 3.11"
conda create --name 3point11 python=3.11 anaconda pyarrow pip ipykernel notebook  nb_conda_kernels 
conda activate 3point11
conda install -c conda-forge jupyter_contrib_nbextensions rise plotnine stata_kernel 
python -m ipykernel install --user --name 3point11
jupyter contrib nbextension install --user
#python -m stata_kernel.install
pip install wrds
pip install mapply
