# BASE Dockerfile for a basic DS sandbox
# contains: R, rstudio-server, miniconda, ssh and x2go
FROM ubuntu:bionic

ENV R_VERSION=4.0.0 \
    CRAN=https://cran.rstudio.com \
    TERM=xterm

ENV DEBIAN_FRONTEND noninteractive
ENV S6_VERSION=v1.21.7.0
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2
ENV PATH=/usr/lib/rstudio-server/bin:$PATH
ENV PANDOC_TEMPLATES_VERSION=2.6

# SETUP SYSTEM WITH R + PYTHON
## BASICS
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
    build-essential \
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
    && /usr/sbin/update-locale LANG=en_US.UTF-8 \

## R AND RSTUDIO
    && apt-get -y build-dep r-base \ 
    && cd tmp/ \
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
    && apt-get update \
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
    ## CONFIGURE THE BASE USER
    && useradd baseuser \
    && echo "baseuser:baseuser" | chpasswd \
	&& mkdir /home/baseuser \
	&& chown baseuser:baseuser /home/baseuser \
	&& addgroup baseuser staff \
    && addgroup baseuser sudo \
    ## Prevent baseuser from deciding to use /usr/bin/R if a user apt-get installs a package
    &&  echo 'rsession-which-r=/usr/local/bin/R' >> /etc/rstudio/rserver.conf \
    ## use more robust file locking to avoid errors when using shared volumes:
    && echo 'lock-type=advisory' >> /etc/rstudio/file-locks \
    ## configure git not to request password each time
    && git config --system credential.helper 'cache --timeout=3600' \
    && git config --system push.default simple \
    ## Set up S6 init system
    && wget -P /tmp/ https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-amd64.tar.gz \
    && tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
    && mkdir -p /etc/services.d/baseuser  \
    && echo '#!/usr/bin/with-contenv bash \
          \n## load /etc/environment vars first: \
  		  \n for line in $( cat /etc/environment ) ; do export $line ; done \
          \n exec /usr/lib/rstudio-server/bin/rserver --server-daemonize 0' \
          > /etc/services.d/baseuser/run \
    && echo '#!/bin/bash \
          \n rstudio-server stop' \
          > /etc/services.d/baseuser/finish \
    && R -e "install.packages('renv', dependencies=TRUE, repos='http://cran.rstudio.com/')"

## MINICONDA
RUN  wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.5.11-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /home/baseuser/miniconda && \
    rm ~/miniconda.sh && \
    /home/baseuser/miniconda/bin/conda clean -tipsy && \
    ln -s /home/baseuser/miniconda/etc/profile.d/conda.sh /etc/profile.d/conda.sh \
    && rm -rf /var/lib/apt/lists/*

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV TINI_VERSION v0.16.1
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini

# x2go and ssh
RUN apt-add-repository ppa:x2go/stable \
&& apt-get update \
&& apt-get install -y x2goserver x2goserver-xsession \
&& apt-get update && apt-get install -y openssh-server \
&& mkdir /var/run/sshd \
&& sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
# SSH login fix. Otherwise user is kicked off after login
&& sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

## install chezmoi and home config

RUN git config --global user.name 'riccardopinosio' \
&& git config --global user.email 'rpinosio@gmail.com' \
&& cd /home/baseuser \
&& runuser -l baseuser -c 'curl -sfL https://git.io/chezmoi | sh' \
&& runuser -l baseuser -c '~/bin/chezmoi init https://github.com/riccardopinosio/dotfiles.git' \
&& runuser -l baseuser -c '~/bin/chezmoi apply'

## install i3wm
RUN apt-get update \
&& apt-get -y install i3

EXPOSE 22
EXPOSE 8787
EXPOSE 8888
EXPOSE 8889

COPY initializations.sh /etc/cont-init.d

CMD ["/init"]