param([string]$s, [string]$t)

# paths to the RENV cache for R
$RENV_PATHS_CACHE_HOST="~/RENV"
$RENV_PATHS_CACHE_CONTAINER="/renv/cache"

if ($s){
        docker run --privileged -i -p 8787:8787 -p 8888:8888 -p 8889:8889 -p 2222:22 --name sandbox -h sandbox -v ${s}:/home/baseuser/${t} `
        --env RENV_PATHS_CACHE=${RENV_PATHS_CACHE_CONTAINER} `
        -v ${RENV_PATHS_CACHE_HOST}:${RENV_PATHS_CACHE_CONTAINER} `
	--restart always `
        riccardopinosio/ds-sandbox-emacs
    } else {
        docker run --privileged -i -p 8787:8787 -p 8888:8888 -p 8889:8889 -p 2222:22 --name sandbox -h sandbox `
        --env RENV_PATHS_CACHE=${RENV_PATHS_CACHE_CONTAINER} `
        -v ${RENV_PATHS_CACHE_HOST}:${RENV_PATHS_CACHE_CONTAINER} `
	--restart always `
        riccardopinosio/ds-sandbox-emacs
    }