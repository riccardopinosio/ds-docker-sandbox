#FROM riccardopinosio/sandbox_base
FROM sandboxx

# build emacs and lisp from source
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
    && chmod -R 777 /emacs \
    && apt-get update \
    && apt-get install -y sbcl cl-quicklisp \
    && bash -c "sbcl --load /usr/share/cl-quicklisp/quicklisp.lisp \
       --eval '(quicklisp-quickstart:install)'       \
       --eval '(ql:add-to-init-file)'                \
       --eval '(quit)'" \
    && rm -rf /var/lib/apt/lists/*

RUN echo 'PATH=$PATH:/emacs/src' > /home/baseuser/.bash_profile \
&& echo 'PATH=$PATH:/emacs/src' > /home/baseuser/.zprofile \
&& runuser -l baseuser -c '/emacs/src/emacs --script ~/.emacs.d/init.el'

USER root
CMD ["/init"]