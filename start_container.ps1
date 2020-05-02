param([string]$s, [string]$t, [string]$ip)

if ($ip){
if ($s){
    docker run -i --privileged -p 8787:8787 -p 8888:8888 -p 8889:8889 -e DISPLAY=${ip} --name sandbox -h sandbox -v ${PSScriptRoot}/hosts:/etc/hosts -v ${s}:/home/riccardo/${t} sandbox
} else {
    docker run -i --privileged -p 8787:8787 -p 8888:8888 -p 8889:8889 -e DISPLAY=${ip} --name sandbox -h sandbox -v ${PSScriptRoot}/hosts:/etc/hosts sandbox    
}
} else {
    if ($s){
        docker run --privileged -i -p 8787:8787 -p 8888:8888 -p 8889:8889 --name sandbox -h sandbox -v ${PSScriptRoot}/hosts:/etc/hosts -v ${s}:/home/riccardo/${t} sandbox
    } else {
        docker run --privileged -i -p 8787:8787 -p 8888:8888 -p 8889:8889 --name sandbox -h sandbox -v ${PSScriptRoot}/hosts:/etc/hosts sandbox    
    }
}

