#!/usr/bin/with-contenv bash

## Set defaults for environmental variables in case they are undefined
USER=${USER:=riccardo}
PASSWORD=${PASSWORD:=riccardo}
USERID=${USERID:=1000}

if [ "$USERID" -lt 1000 ]
# Probably a macOS user, https://github.com/rocker-org/rocker/issues/205
  then
    echo "$USERID is less than 1000, setting minumum authorised user to 499"
    echo auth-minimum-user-id=499 >> /etc/rstudio/rserver.conf
fi

## add these to the global environment so they are avialable to the RStudio user 
echo "HTTR_LOCALHOST=$HTTR_LOCALHOST" >> /etc/R/Renviron.site
echo "HTTR_PORT=$HTTR_PORT" >> /etc/R/Renviron.site