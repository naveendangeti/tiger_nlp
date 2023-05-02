# !/bin/bash
# Usage
# `bash install_tigernlp.sh -u <relative path to the whl file>` installs TigerNLP in an env called `ta-tigernlp` (creates new env if an env with this name doesn't exist) and installs TigerNLP and its dependencies in the env. To be used by the end user
# `bash install_tigernlp.sh -d` installs TigerNLP in an env called `ta-tigernlp` (creates new env if an env with this name doesn't exist) and installs TigerNLP and its dependencies (along with the dev dependencies) in the env. To be used by the developer

# conda env remove -n ta-tigernlp
eval "$(conda shell.bash hook)"
if { conda env list | grep 'ta-tigernlp$'; } then
    echo "ta-tigernlp env exists already. TigerNLP package and dependencies will be installed in the existing env"
    conda activate ta-tigernlp
else
    echo "Creating a new env ta-tigernlp where TigerNLP package and dependencies will be installed"
    conda create -n ta-tigernlp python=3.8 -y
    conda activate ta-tigernlp
fi

# Conda install HDBSCAN package as pip install hdbscan has gcc incompatibility issues
conda install -c conda-forge hdbscan==0.8.29 -y

# If user options are provided
while [[ $# -gt 0 ]]; do
option=$1
case "$option" in
    -u|--user)
        # If user option, then install using whl file
        pip install $2
        shift
        shift
        ;;
    -d|--dev)
        # If dev option, install using setup.py and also install developer dependency packages
        pip install -e .
        pip install -r deploy/requirements_dev_linux.txt
    shift
    ;;
    esac
done
