param([string]$s, [string]$t)

if ($s){
docker run -i -p 8787:8787 -e PASSWORD=sandbox --name sandbox -h sandbox -v ${s}:/home/rstudio/${t} sandbox
} else {
    docker run -i -p 8787:8787 -e PASSWORD=sandbox --name sandbox -h sandbox sandbox    
}
