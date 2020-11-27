#!/usr/bin/with-contenv bash

## add these to the global environment so they are avialable to the RStudio user 
echo "HTTR_LOCALHOST=$HTTR_LOCALHOST" >> /etc/R/Renviron.site
echo "HTTR_PORT=$HTTR_PORT" >> /etc/R/Renviron.site

# make tini executable
chmod +x /usr/bin/tini

# baseuser user to use zsh
usermod -s /bin/zsh baseuser

# add conda to path for baseuser just in case it's not already in the dotfiles
echo "source /home/baseuser/miniconda/bin/activate" >> /home/baseuser/.bashrc
echo "source /home/baseuser/miniconda/bin/activate" >> /home/baseuser/.zshrc

# start ssh
/usr/sbin/sshd -D &