FROM rocker/tidyverse:3.6.3

# updates and installs

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    curl \
    zsh \
    vim

# rstudio to use zsh and sudo
RUN usermod -s /bin/zsh rstudio \
&& usermod -aG sudo rstudio

## chezmoi and dotfiles management
RUN wget https://github.com/twpayne/chezmoi/releases/download/v1.7.19/chezmoi_1.7.19_linux_amd64.deb \
&& sudo dpkg -i chezmoi_1.7.19_linux_amd64.deb

# setup rstudio
USER rstudio
WORKDIR /home/rstudio

RUN chezmoi init https://github.com/riccardopinosio/dotfiles.git

RUN git config --global user.email rpinosio@gmail.com \
&& git config --global user.name riccardopinosio

# basic R packages
RUN R -e "install.packages('renv', dependencies=TRUE, repos='http://cran.rstudio.com/')" \
&& R -e "install.packages('data.table', dependencies=TRUE, repos = 'http://cran.rstudio.com/')"

# python
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
&& chmod 777 ./Miniconda3-latest-Linux-x86_64.sh \
&& ./Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda

USER root

# commands at startup for rstudio user
ENTRYPOINT runuser -l rstudio -c 'chezmoi update' && runuser -l rstudio -c 'chezmoi apply'
