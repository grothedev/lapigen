#!/bin/bash

#run a command for each model (use that model as an arg)

if [[ -z $1 ]]; then 
    echo "provide a program to run on this model"
    exit 0
fi

while read m; do
    if [[ -z ${m} || ${m:0:1} == "#" ]]; then #this line is a comment or blank
        continue;
    fi
    if [[ ${m:0:1} == "-" ]]; then
        continue;
    fi
    m=`echo ${m} | cut -d# -f1 | cut -d' ' -f1` #remove trailing comment and whitespace
    if [[ ${m:0:1} != [a-zA-Z] && ${m:0:1} != "-" ]]; then #malformed model definition file, model should only begin with a letter
        echo "this model definition file is malformed, exiting."
        echo "  \'${m}\'    "
        exit -1
    fi

    echo "execing ${@} ${m}"
    ${@} ${m}
    #if [[ ${SHELL} ]]; then
    #    ${SHELL} -c "${@} ${m}"
    ##else
    #    bash -c "${@} ${m}"
    #fi
done < models.txt