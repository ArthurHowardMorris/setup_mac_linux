#!/bin/bash
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

echo "install formulae from formulae.txt"
xargs brew  install < formulae.txt

if [  "$(uname)" == "Darwin" ]
then
    echo "installing mac apps and casks"
    brew install --cask expressvpn obsidian font-source-code-pro powershell git-credential-manager-core rar google-chrome rectangle-pro iterm2 superkey mactex visual-studio-code miniconda 1password
    # set up a working conda
    conda init "$(basename "${SHELL}")"
fi


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

echo "now setting up an anaconda stack with python 3.10"
conda create --name 3point10 python=3.10 anaconda pyarrow pip ipykernel notebook  nb_conda_kernels 
conda activate 3point10
conda install -c conda-forge jupyter_contrib_nbextensions rise plotnine stata_kernel 
python -m ipykernel install --user --name 3point10
jupyter contrib nbextension install --user
#python -m stata_kernel.install
pip install wrds
pip install mapply

# TODO: set  this up so it works alittle more of at all on both:
# make an ssh key for the main github account, without passphrase, in the default location
yes '' | ssh-keygen -t rsa -b 4096 -C "53531149+ArthurHowardMorris@users.noreply.github.com" -N ''
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
# https://ostechnix.com/how-to-use-pbcopy-and-pbpaste-commands-on-linux/
cat ~/.ssh/id_rsa.pub | xclip -selection c
# now the public key is in the clipboard and you can add it to github under settings
# add a pause here and a prompt to load into git hub.
git config --global user.email  "53531149+ArthurHowardMorris@users.noreply.github.com"
git config --global user.name "ArthurHowardMorris"

