param([string]$s="test", [string]$t="mounted_folder")

if ($s){
docker run -i -p 8787:8787 -e PASSWORD=sandbox --name sandbox -v ${s}:/home/rstudio/${t} sandbox
} else {
    docker run -i -p 8787:8787 -e PASSWORD=sandbox --name sandbox sandbox    
}