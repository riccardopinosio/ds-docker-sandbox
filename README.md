# A data science development sandbox container

This repository contains a dockerfile to build a container image for a multipurpose data science/ML development environment.
The built image contains:

1. Ubuntu 18.04
2. Rstudio server listening on localhost at port 8787
3. python miniconda installed in the user home folder
4. emacs 27 compiled with gtk and modules support
5. an ssh service listening on port 22
6. the x2go remote desktop server

The image can be retrieved from dockerhub at riccardopinosio/ds_sandbox.

# ssh into the container

Since the image has an active ssh service on port 22 one can ssh into the container if needed. Moreover, the x2go ubuntu service
is good to initiate x-forwarding ssh connections to the container. This allows one, for example, to use GUI linux emacs 27
on windows for (possibly remote) development. My experience with x2go is that it speeds up x forwarding quite a bit.
Note that in order to connect to the x2go server via ssh you need the x2go client, see 
https://wiki.x2go.org/doku.php/doc:installation:x2goclient for more details.

# Notes
I am aware that it would be better practice to have the ssh service in its own container and use docker compose, 
however that's more hassle to setup, and this image is only intended for development purposes.
In the future I will look into splitting it up and using docker compose, but for the moment this works well. 

Also, this image will currently install my dotfiles in the home folder and setup my emacs configuration. 
Currently there's no way to disable this apart from rebuilding the image, but the next step is going to be to
allow the user of the image to provide its own dotfiles.
