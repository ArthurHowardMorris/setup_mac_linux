#!/bin/bash
echo "checking system and prepping package manager"
echo "system is $(uname)"

## Step 1 Install `homebrew` (checks whether this is mac or linux)

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
    sudo apt-get install build-essential procps curl file git sudo apt install latexmk 
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

## Step 2 install all the formulae in formulae.txt which is populated from `brew list`
echo "install formulae from formulae.txt"
xargs brew  install < formulae.txt


## Step 3 install mac apps an casks (if this is a mac)
## NB: that this includes miniconda
if [  "$(uname)" == "Darwin" ]
then
    echo "installing mac apps and casks"
    brew install --cask expressvpn obsidian font-source-code-pro powershell git-credential-manager-core rar google-chrome rectangle-pro iterm2 superkey mactex visual-studio-code miniconda 1password
    # set up a working conda
    conda init "$(basename "${SHELL}")"
fi

## Step 3 cont'd install flatpaks and miniconda if this is
## linux.
if [ "$(uname)" == "Linux" ]
then
	flatpak install https://downloads.1password.com/linux/flatpak/1Password.flatpakref
	echo "now you can launch 1password with this command:"
	flatpak "run com.onepassword.OnePassword"
	echo "installing miniconda"
	mkdir -p ~/miniconda3
	wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
	bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
	rm -rf ~/miniconda3/miniconda.sh
	~/miniconda3/bin/conda init bash
	~/miniconda3/bin/conda init zsh
	echo "installing latex"
	sudo apt-get latexmk
fi


# TODO: set  this up so it works alittle more of at all on both:
# make an ssh key for the main github account, without passphrase, in the default location
yes '' | ssh-keygen -t rsa -b 4096 -C "53531149+ArthurHowardMorris@users.noreply.github.com" -N ''
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
# https://ostechnix.com/how-to-use-pbcopy-and-pbpaste-commands-on-linux/
if [  "$(uname)" == "Darwin" ]
then
    cat ~/.ssh/id_rsa.pub | pbcopy -selection c
elif [ "$(uname)" == "Linux" ]
    cat ~/.ssh/id_rsa.pub | xclip -selection c
fi
read -p "Public key is now in the system clipboard. Go to https://github.com/settings/keys to add this to github. Ready to continue (y/n)?" choice
case "$choice" in 
  y|Y ) echo "yes";;
  n|N ) echo "no";;
  * ) echo "invalid";;
esac
# now the public key is in the clipboard and you can add it to github under settings
# add a pause here and a prompt to load into git hub.
git config --global user.email  "53531149+ArthurHowardMorris@users.noreply.github.com"
git config --global user.name "ArthurHowardMorris"

## Step 5: use conda to set up the anaconda stack with the new hotness (python 11)
## Note that this might benefit from being it's own script as it will probably fail unless you restart the terminal
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

