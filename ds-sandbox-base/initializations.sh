#!/usr/bin/with-contenv bash

## add these to the global environment so they are avialable to the RStudio user 
echo "HTTR_LOCALHOST=$HTTR_LOCALHOST" >> /etc/R/Renviron.site
echo "HTTR_PORT=$HTTR_PORT" >> /etc/R/Renviron.site

# make tini executable
chmod +x /usr/bin/tini

# baseuser user to use zsh
usermod -s /bin/zsh baseuser

## install chezmoi and home config
runuser -l baseuser -c "git config --global user.name 'riccardopinosio'"
runuser -l baseuser -c "git config --global user.email 'rpinosio@gmail.com'"
runuser -l baseuser -c " curl -sfL https://git.io/chezmoi | sh"
runuser -l baseuser -c "~/bin/chezmoi init https://github.com/riccardopinosio/dotfiles.git"
runuser -l baseuser -c "~/bin/chezmoi apply"

# add conda to path for baseuser just in case it's not already in the dotfiles
echo "source /home/baseuser/miniconda/bin/activate" >> /home/baseuser/.bashrc
echo "source /home/baseuser/miniconda/bin/activate" >> /home/baseuser/.zshrc

# now add emacs to bash and zsh if needed
if [[ $HAS_EMACS == "True" ]]; then
    echo 'PATH=$PATH:/emacs/src' > /home/baseuser/.bash_profile
    echo 'PATH=$PATH:/emacs/src' > /home/baseuser/.zprofile
    runuser -l baseuser -c "/emacs/src/emacs --script ./.emacs.d/init.el"
else
    echo "no emacs to add"
fi

# start ssh
/usr/sbin/sshd -D &