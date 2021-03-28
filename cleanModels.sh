#!/bin/bash

function rm_(){
    echo "  removing "${1}
    rm ${1}
}

while read m; do
    if [[ -z ${m} || ${m:0:1} == "#" ]]; then #this line is a comment or blank
        continue;
    fi
    if [[ ${m:0:1} == "-" ]]; then
        continue;
    fi
    echo ${m}
    if [[ `./artisan --version | cut -d' ' -f3` == "8."* ]]; then 
        rm_ app/Models/${m}.php
    else
        rm_ app/${m}.php
    fi
    migrationfile=`ls database/migrations/ | grep -i ${m:0:3}` #first few chars in case of plural spelling complication
    if [[ $migrationfile ]]; then rm_ database/migrations/$migrationfile; fi
    rm_ app/Http/Controllers/${m}Controller.php
done < models.txt



#What is left to do after this script runs:
# relationships between nodes
# controller functions code
# TODO what else can reasonably be included in models.txt to extend automatic code generation?
