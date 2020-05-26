#!/usr/bin/with-contenv bash


## add these to the global environment so they are avialable to the RStudio user 
echo "HTTR_LOCALHOST=$HTTR_LOCALHOST" >> /etc/R/Renviron.site
echo "HTTR_PORT=$HTTR_PORT" >> /etc/R/Renviron.site

## install chezmoi and home config
runuser -l riccardo -c "git config --global user.name 'riccardopinosio'"
runuser -l riccardo -c "git clone https://github.com/riccardopinosio/bootstrapping.git ~/bootstrapping"
chmod 777 /home/riccardo/bootstrapping/setup_home.sh
echo "applying chezmoi"
runuser -l riccardo -c "~/bootstrapping/setup_home.sh"

# now add emacs to bash and zsh
echo 'PATH=$PATH:/emacs/src' > /home/riccardo/.bash_profile
echo 'PATH=$PATH:/emacs/src' > /home/riccardo/.zprofile

runuser -l riccardo -c "/emacs/src/emacs --script ./.emacs.d/init.el"
# start ssh
/usr/sbin/sshd -D &