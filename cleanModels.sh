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

function rm_(){
    echo "  removing "${1}
    #rm ${1}
    mv ${1} .lapigen_bak/ 
}

#folder to place the removed files in case of restore
if [[ ! -f .lapigen_bak ]]; then
    mkdir .lapigen_bak
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

    echo ${m}
    if [[ `./artisan --version | cut -d' ' -f3` == "8."* ]]; then 
        rm_ "app/Models/${m}.php"
    else
        rm_ "app/${m}.php"
    fi
    migrationfile=`ls database/migrations/ | grep -i ${m:0:3}` #first few chars in case of plural spelling complication
    if [[ $migrationfile ]]; then rm_ "database/migrations/${migrationfile}"; fi
    rm_ "app/Http/Controllers/${m}Controller.php"
done < models.txt



#What is left to do after this script runs:
# relationships between nodes
# controller functions code
# TODO what else can reasonably be included in models.txt to extend automatic code generation?
