#!/bin/bash
echo "first setting up an anaconda stack with 3.10"
conda init zsh
conda create --name 3point10 python=3.10 anaconda pyarrow pip ipykernel notebook  nb_conda_kernels rise
conda activate 3point10
conda install -c conda-forge jupyter_contrib_nbextensions plotnine stata_kernel 
python -m ipykernel install --user --name 3point10
jupyter contrib nbextension install --user
# python -m stata_kernel.install
pip install wrds
conda deactivate

echo "now setting up an anaconda stack with python 3.11"
conda create --name 3point11 python=3.11 anaconda pyarrow pip ipykernel notebook  nb_conda_kernels 
conda activate 3point11
conda install -c conda-forge plotnine 
python -m ipykernel install --user --name 3point11
jupyter contrib nbextension install --user
# python -m stata_kernel.install
pip install wrds

