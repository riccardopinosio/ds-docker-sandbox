param([string]$s, [string]$t, [string]$ip)

# paths to the RENV cache for R
$RENV_PATHS_CACHE_HOST="~/RENV"
$RENV_PATHS_CACHE_CONTAINER="/renv/cache"

if ($ip){
if ($s){
    docker run -i --privileged -p 8787:8787 -p 8888:8888 -p 8889:8889 -p 2222:22 -e DISPLAY=${ip} --name sandbox -h sandbox -v ${PSScriptRoot}/hosts:/etc/hosts -v ${s}:/home/riccardo/${t} `
    -e RENV_PATHS_CACHE=${RENV_PATHS_CACHE_CONTAINER} `
    -v ${RENV_PATHS_CACHE_HOST}:${RENV_PATHS_CACHE_CONTAINER} `
    sandbox
} else {
    docker run -i --privileged -p 8787:8787 -p 8888:8888 -p 8889:8889 -p 2222:22 -e DISPLAY=${ip} --name sandbox -h sandbox -v ${PSScriptRoot}/hosts:/etc/hosts `
    -e RENV_PATHS_CACHE=${RENV_PATHS_CACHE_CONTAINER} `
    -v ${RENV_PATHS_CACHE_HOST}:${RENV_PATHS_CACHE_CONTAINER} `
    sandbox    
}
} else {
    if ($s){
        docker run --privileged -i -p 8787:8787 -p 8888:8888 -p 8889:8889 -p 2222:22 --name sandbox -h sandbox -v ${PSScriptRoot}/hosts:/etc/hosts -v ${s}:/home/riccardo/${t} `
        -e RENV_PATHS_CACHE=${RENV_PATHS_CACHE_CONTAINER} `
        -v ${RENV_PATHS_CACHE_HOST}:${RENV_PATHS_CACHE_CONTAINER} `
        sandbox
    } else {
        docker run --privileged -i -p 8787:8787 -p 8888:8888 -p 8889:8889 -p 2222:22 --name sandbox -h sandbox -v ${PSScriptRoot}/hosts:/etc/hosts `
        -e RENV_PATHS_CACHE=${RENV_PATHS_CACHE_CONTAINER} `
        -v ${RENV_PATHS_CACHE_HOST}:${RENV_PATHS_CACHE_CONTAINER} `
        sandbox    
    }
}

