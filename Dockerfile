FROM rocker/tidyverse:3.6.3

# updates and installs

RUN apt-get update --fix-missing \
  && apt-get install -y --no-install-recommends \
    curl \
    zsh \
    vim \
    less \
    bzip2 \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

## chezmoi and dotfiles management
RUN wget https://github.com/twpayne/chezmoi/releases/download/v1.7.19/chezmoi_1.7.19_linux_amd64.deb \
&& sudo dpkg -i chezmoi_1.7.19_linux_amd64.deb

## conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.5.11-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.zshrc && \
    echo "conda activate base" >> ~/.zshrc

ENV TINI_VERSION v0.16.1
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

# commands to run at container startup
COPY initializations.sh /etc/cont-init.d

## setup rstudio user

# rstudio user to use zsh and sudo
RUN usermod -s /bin/zsh rstudio \
&& usermod -aG sudo rstudio \
# ensure the conda folder and subfolder is owned by rstudio to create environments
&& chown -R rstudio /opt/conda

# setup rstudio user home
USER rstudio
WORKDIR /home/rstudio

RUN chezmoi init https://github.com/riccardopinosio/dotfiles.git

RUN git config --global user.email rpinosio@gmail.com \
&& git config --global user.name riccardopinosio

# basic R packages
RUN R -e "install.packages('renv', dependencies=TRUE, repos='http://cran.rstudio.com/')" \
&& R -e "install.packages('data.table', dependencies=TRUE, repos = 'http://cran.rstudio.com/')"

USER root