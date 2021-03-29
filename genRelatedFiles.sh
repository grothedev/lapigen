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
    echo "option required: specify what type of files you are generating: forms, controllers, or views (-f, -c, -v)"
    exit 0
fi

#conveniently, these letters are exclusive to each responsibility name
if [[ `echo ${1} | grep -i f` ]]; then
    script="genForms.sh"
elif [[ `echo ${1} | grep -i c` ]]; then
    script="genControllers.sh"
else [[ `echo ${1} | grep -i v` ]]; then
    script="genViews.sh"
fi
shift 1
echo "will run "${script}

if [[ -z $1 ]]; then
    for mf in `ls app/Models/`; do
        models+=`echo ${mf} | sed 's/\(.*\)\.php/\1/g'`
    done
else
    while [[ $1 ]]; do
        models+=${1}
        shift 1
    done
fi

for model in $models; then
    ./${script} ${model}
done


#while read l; do
#    l=`echo ${l} | cut -d# -f1 | cut -d' ' -f1 ` #remove trailing comment and whitespace
#    if [[ ${l:0:1} != [a-zA-Z] ]]; then continue; fi
#    ./genForms.sh $l
#done < $1
