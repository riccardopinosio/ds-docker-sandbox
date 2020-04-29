param([string]$s, [string]$t)

if ($s){
docker run -i -p 8787:8787 --name sandbox -h sandbox -v ${s}:/home/riccardo/${t} sandbox
} else {
    docker run -i -p 8787:8787 --name sandbox -h sandbox sandbox    
}
