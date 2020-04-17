#!/usr/bin/with-contenv bash

runuser -l rstudio -c 'chezmoi update'
runuser -l rstudio -c 'chezmoi apply'