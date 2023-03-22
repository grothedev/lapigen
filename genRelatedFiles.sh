#!/bin/bash

###
# Laravel API Model and Form Generation Application
# Copyright (C) 2020 Thomas Grothe, grothedev@gmail.com

# This file is part of Laravel API Model and Form Generation Application.

# Laravel API Model and Form Generation Application is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Laravel API Model and Form Generation Application is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with Laravel API Model and Form Generation Application.  If not, see <https://www.gnu.org/licenses/>.
###

#this script will generate the application files (forms, controllers, or views) of all models if no arg passed in.
# or of each model name passed in as args
#ARGS:
# 1 (required): -f,-c,-v
# 2,3,etc.: model names 

models=()

if [[ -z $1 || ${1:0:1} != "-" ]]; then
    echo "option required: specify what type of files you are generating: forms, controllers (-f, -c)"
    exit 0
fi

while getopts "fcm" opt; do
    case $opt in
        f)
            script="genForms.sh"
            ;;
        c)
            script="genController.sh"
            ;;
        m)
            script="genModel.sh"
            ;;
        h)
            printhelp
            exit 0
            ;;
    esac
done
shift 1
echo "will run "${script}". now is your time to cancel. "
sleep 3

if [[ -z $1 ]]; then
    for mf in `ls app/Models/`; do
        #models+=(`echo ${mf} | sed 's/\(.*\)\.php/\1/g'`) #was using sed but there are better ways
        models+=(${mf%%.*}) #cut ".php" from filename
    done
else
    while [[ $1 ]]; do
        models+=(${1})
        shift 1
    done
fi

for model in ${models[@]}; do 
    ./${script} ${model}
    #echo "${script} ${model}"
done


#while read l; do
#    l=`echo ${l} | cut -d# -f1 | cut -d' ' -f1 ` #remove trailing comment and whitespace
#    if [[ ${l:0:1} != [a-zA-Z] ]]; then continue; fi
#    ./genForms.sh $l
#done < $1

function printhelp {
    echo "Usage:  ./genRelatedFiles.sh OPTION [MODEL] ... " 
    echo "generate the controller or form files for the given models, and write them to the appropriate paths in the laravel project."
    echo "-c generate controllers"
    echo "-f generate forms"
    echo "optionally provide a list of any number of models by name, otherwise will use those already present in the project."
}