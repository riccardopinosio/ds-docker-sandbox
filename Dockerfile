# BASE Dockerfile for a basic DS sandbox for work and research
FROM ubuntu:bionic

ENV R_VERSION=4.0.0 \
    CRAN=https://cran.rstudio.com \
    TERM=xterm

ENV DEBIAN_FRONTEND noninteractive

# SETUP SYSTEM
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    bash-completion \
    ca-certificates \
    file \
    fonts-texgyre \
    g++ \
    gfortran \
    gsfonts \
    libblas-dev \
    libbz2-1.0 \
    libcurl4 \
    libopenblas-dev \
    libpangocairo-1.0-0 \
    libpcre3 \
    libpng16-16 \
    libreadline7 \
    libtiff5 \
    liblzma5 \
    locales \
    make \
    unzip \
    zip \
    zlib1g \
    software-properties-common \
    ed \
    less \
    vim-tiny \
    wget \
    zsh \
    file \
    git \
    libapparmor1 \
    libclang-dev \
    libcurl4-openssl-dev \
    libedit2 \
    libssl-dev \
    lsb-release \
    multiarch-support \
    psmisc \
    procps \
    python-setuptools \
    sudo \
    curl \
    libxml2-dev \
    # useful to test x11 forwarding if needed
    x11-apps \
    tmux \
    build-essential \
    cmake \
    libtool-bin \
    firefox \
    ## enabling source repos
    && add-apt-repository --enable-source --yes "ppa:marutter/rrutter3.5" \
    && add-apt-repository --enable-source --yes "ppa:marutter/c2d4u3.5" \
    && add-apt-repository universe \
    && sed -i '/deb-src/s/^# //' /etc/apt/sources.list \
    && apt update \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.utf8 \
    && /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

# build emacs from source
RUN apt-get -y build-dep emacs \
    && apt-get install -y texinfo automake libgnutls30 libgnutls28-dev libncurses-dev libgtk-3-dev libxpm-dev libjpeg-dev libgif-dev libtiff-dev \
    && git clone https://github.com/emacs-mirror/emacs.git --branch emacs-27 --single-branch \
    && cd emacs \
    && ./autogen.sh \
    && ./configure --with-x-toolkit=gtk3 --with-modules --with-cairo \
    && make \
    && make install \
    && echo 'PATH=$PATH:/emacs/src' > $HOME/.bash_profile \
    && echo 'PATH=$PATH:/emacs/src' > $HOME/.zprofile \
    && chmod -R 777 /emacs

# R AND RSTUDIO

## build deps
RUN apt-get -y build-dep r-base
## build R
RUN cd tmp/ \
  && curl -O https://cran.r-project.org/src/base/R-4/R-${R_VERSION}.tar.gz \
  && tar -xf R-${R_VERSION}.tar.gz \
  && cd R-${R_VERSION} \
  && R_PAPERSIZE=letter \
    R_BATCHSAVE="--no-save --no-restore" \
    R_BROWSER=xdg-open \
    PAGER=/usr/bin/pager \
    PERL=/usr/bin/perl \
    R_UNZIPCMD=/usr/bin/unzip \
    R_ZIPCMD=/usr/bin/zip \
    R_PRINTCMD=/usr/bin/lpr \
    LIBnn=lib \
    AWK=/usr/bin/awk \
    CFLAGS="-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -g" \
    CXXFLAGS="-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -g" \
    ./configure --enable-R-shlib \
               --enable-memory-profiling \
               --with-readline \
               --with-blas \
               --with-tcltk \
               --disable-nls \
               --with-recommended-packages \
    && make \
    && make install \
    ## Add a library directory (for user-installed packages)
    && mkdir -p /usr/local/lib/R/site-library \
    && chown root:staff /usr/local/lib/R/site-library \
    && chmod g+ws /usr/local/lib/R/site-library \
    ## Fix library path
    && sed -i '/^R_LIBS_USER=.*$/d' /usr/local/lib/R/etc/Renviron \
    && echo "R_LIBS_USER=\${R_LIBS_USER-'/usr/local/lib/R/site-library'}" >> /usr/local/lib/R/etc/Renviron \
    && echo "R_LIBS=\${R_LIBS-'/usr/local/lib/R/site-library:/usr/local/lib/R/library:/usr/lib/R/library'}" >> /usr/local/lib/R/etc/Renviron \
    ## Set configured CRAN mirror
    && echo MRAN=$CRAN >> /etc/environment \
    && echo "options(repos = c(CRAN='$CRAN'), download.file.method = 'libcurl')" >> /usr/local/lib/R/etc/Rprofile.site \
    ## Use littler installation scripts
    && Rscript -e "install.packages(c('littler', 'docopt'), repo = '$CRAN')" \
    && ln -s /usr/local/lib/R/site-library/littler/examples/install2.r /usr/local/bin/install2.r \
    && ln -s /usr/local/lib/R/site-library/littler/examples/installGithub.r /usr/local/bin/installGithub.r \
    && ln -s /usr/local/lib/R/site-library/littler/bin/r /usr/local/bin/r \
    ## Clean up from R source install
    && cd / \
    && rm -rf /tmp/* \
    && apt-get autoremove -y \
    && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/*

ENV S6_VERSION=v1.21.7.0
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2
ENV PATH=/usr/lib/rstudio-server/bin:$PATH
ENV PANDOC_TEMPLATES_VERSION=2.6

RUN apt-get update \
  && RSTUDIO_URL="https://www.rstudio.org/download/latest/stable/server/bionic/rstudio-server-latest-amd64.deb" \
  && wget -q $RSTUDIO_URL \
  && dpkg -i rstudio-server-*-amd64.deb \
  && rm rstudio-server-*-amd64.deb \
  ## Symlink pandoc & standard pandoc templates for use system-wide
  && ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc /usr/local/bin \
  && ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc-citeproc /usr/local/bin \
  && git clone --recursive --branch ${PANDOC_TEMPLATES_VERSION} https://github.com/jgm/pandoc-templates \
  && mkdir -p /opt/pandoc/templates \
  && cp -r pandoc-templates*/* /opt/pandoc/templates && rm -rf pandoc-templates* \
  && mkdir /root/.pandoc && ln -s /opt/pandoc/templates /root/.pandoc/templates \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/ \
  ## RStudio wants an /etc/R, will populate from $R_HOME/etc
  && mkdir -p /etc/R \
  ## Write config files in $R_HOME/etc
  && echo '\n\
    \n# Configure httr to perform out-of-band authentication if HTTR_LOCALHOST \
    \n# is not set since a redirect to localhost may not work depending upon \
    \n# where this Docker container is running. \
    \nif(is.na(Sys.getenv("HTTR_LOCALHOST", unset=NA))) { \
    \n  options(httr_oob_default = TRUE) \
    \n}' >> /usr/local/lib/R/etc/Rprofile.site \
  && echo "PATH=${PATH}" >> /usr/local/lib/R/etc/Renviron \
  ## CONFIGURE THE USER
  && useradd riccardo \
  && echo "riccardo:riccardo" | chpasswd \
	&& mkdir /home/riccardo \
	&& chown riccardo:riccardo /home/riccardo \
	&& addgroup riccardo staff \
  && addgroup riccardo sudo \
  ## Prevent riccardo from deciding to use /usr/bin/R if a user apt-get installs a package
  &&  echo 'rsession-which-r=/usr/local/bin/R' >> /etc/rstudio/rserver.conf \
  ## use more robust file locking to avoid errors when using shared volumes:
  && echo 'lock-type=advisory' >> /etc/rstudio/file-locks \
  ## configure git not to request password each time
  && git config --system credential.helper 'cache --timeout=3600' \
  && git config --system push.default simple \
  ## Set up S6 init system
  && wget -P /tmp/ https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-amd64.tar.gz \
  && tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
  && mkdir -p /etc/services.d/riccardo \
  && echo '#!/usr/bin/with-contenv bash \
          \n## load /etc/environment vars first: \
  		  \n for line in $( cat /etc/environment ) ; do export $line ; done \
          \n exec /usr/lib/rstudio-server/bin/rserver --server-daemonize 0' \
          > /etc/services.d/riccardo/run \
  && echo '#!/bin/bash \
          \n rstudio-server stop' \
          > /etc/services.d/riccardo/finish \
  && R -e "install.packages('renv', dependencies=TRUE, repos='http://cran.rstudio.com/')" \
  && R -e "install.packages('data.table', dependencies=TRUE, repos = 'http://cran.rstudio.com/')" \
  && R -e "install.packages('languageserver', dependencies=TRUE, repos = 'http://cran.rstudio.com/')" \
  && R -e "install.packages('tidyverse', dependencies=TRUE, repos='http://cran.rstudio.com/')" \
  && R -e "install.packages('rstan', repos = 'https://cloud.r-project.org/', dependencies = TRUE)"

# LISP
RUN apt-get update \ 
&& apt-get install -y sbcl cl-quicklisp \
&& bash -c "sbcl --load /usr/share/cl-quicklisp/quicklisp.lisp \
       --eval '(quicklisp-quickstart:install)'       \
       --eval '(ql:add-to-init-file)'                \
       --eval '(quit)'"

# CHEZMOI

RUN wget https://github.com/twpayne/chezmoi/releases/download/v1.7.19/chezmoi_1.7.19_linux_amd64.deb \
&& sudo dpkg -i chezmoi_1.7.19_linux_amd64.deb

## MINICONDA

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.5.11-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh

ENV TINI_VERSION v0.16.1
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

# MORE USER CONF

# riccardo user to use zsh
RUN usermod -s /bin/zsh riccardo \
# ensure the conda folder and subfolder is owned by riccardo to create environments
&& chown -R riccardo /opt/conda

# setup home
USER riccardo
WORKDIR /home/riccardo

RUN chezmoi init https://github.com/riccardopinosio/dotfiles.git \
&& chezmoi update \
&& chezmoi apply \
&& git config --global user.email rpinosio@gmail.com \
&& git config --global user.name riccardopinosio \
&& /emacs/src/emacs --script ./.emacs.d/init.el
USER root

COPY initializations.sh /etc/cont-init.d

#x2go
RUN apt-add-repository ppa:x2go/stable \
&& apt-get update \
&& apt-get install -y x2goserver x2goserver-xsession


# ENABLE SSH
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
EXPOSE 8787
EXPOSE 8888
EXPOSE 8889

CMD ["/init"]