# adds emacs and lisp to sandbox-base
FROM riccardopinosio/ds-sandbox-base

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
    && chmod -R 777 /emacs \

# LISP
    && apt-get update \
    && apt-get install -y sbcl cl-quicklisp \
    && bash -c "sbcl --load /usr/share/cl-quicklisp/quicklisp.lisp \
       --eval '(quicklisp-quickstart:install)'       \
       --eval '(ql:add-to-init-file)'                \
       --eval '(quit)'"

# emacs settings at startup
ENV HAS_EMACS=True

CMD ["/init"]