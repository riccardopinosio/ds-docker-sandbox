#!/usr/bin/with-contenv bash

runuser -l riccardo -c 'chezmoi update'
runuser -l riccardo -c 'chezmoi apply'

## add these to the global environment so they are avialable to the RStudio user 
echo "HTTR_LOCALHOST=$HTTR_LOCALHOST" >> /etc/R/Renviron.site
echo "HTTR_PORT=$HTTR_PORT" >> /etc/R/Renviron.site
# now add emacs to bash and zsh
echo 'PATH=$PATH:/emacs/src' > /home/riccardo/.bash_profile
echo 'PATH=$PATH:/emacs/src' > /home/riccardo/.zprofile