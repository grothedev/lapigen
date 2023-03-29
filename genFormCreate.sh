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

#this scripts generates a form that one can use to create instances of model
#takes one arg: [model name]
#NOTE: you will have to manually change the type of the input tag if needed

### GLOBAL VARIABLES ###
#map table column types (from migration file) to html input tags
declare -A htmlInputTypes
htmlInputTypes["integer"]="number"
htmlInputTypes["float"]="number"
htmlInputTypes["string"]="text"
htmlInputTypes["dateTime"]="datetime-local"

htmlInputTemplate=`cat templates/input_simple.template.html`
htmlTextAreaTemplate=`cat templates/input_textarea.template.html`
htmlFormCreateTemplate=`cat templates/input_simple.template.html`

model=$1
model_LC=`echo ${model} | tr '[:upper:]' '[:lower:]'`
model_plural=`./pluralize ${model_LC} | tail -n 1`
formFile="resources/views/${model_LC}/create.blade.php"

### FUNCTIONS ###
#insert input element into the form html file
#args: [input type] [input name] [input label (optional)]
function insertInput {
    if [[ -z $1 && -z $2 ]]; then return -1; fi
    sed -i "/csrf_field/a \n${htmlInputTemplate}" $formFile
    sed -i "s/--field--/${2}/g" $formFile
    sed -i "s/--input_type--/${1}/g" $formFile
    if [[ $3 ]]; then
        sed -i "s/--field_label--/${3}/g" $formFile
    else
        sed -i "s/--field_label--/${2}/g" $formFile
    fi
}

if [ -z $1 ]; then
    echo "provide the model name exactly how it is written in your model and controller filenames."
    exit 0
fi

#TO use migrations or models.txt?
model_file="app/Models/${model}.php"
if [[ ! -f $model_file ]]; then
    echo "model file does not exist in app/Models/ , continue? (y/n)"
    read c
    if [[ ! ${c,,} == 'y' ]]; then
        echo "ok. exiting."
        exit 0
    fi
fi

for f in `ls database/migrations/ `; do
    fNoUnderscore=`echo ${f} | sed 's/_//g'`
    if [[ $fNoUnderscore == *${model_plural}* ]]; then
        migration_file="database/migrations/"${f}
    fi
done
echo $migration_file

if [[ ! -f ${migration_file} ]]; then
    echo "migration file does not exist in app/Models/ , continue? (y/n)"
    read c
    if [[ ! ${c,,} == 'y' ]]; then
        echo "ok. exiting."
        exit 0
    fi
    use_migration=false
else
    use_migration=true #get fields from migration file instead of models
fi

#model fields/attributes
declare -A fields #=()
declare -A types #=()

if [[ ${use_migration} ]]; then
    getfieldsresult=`cat ${migration_file} | grep "\$table-"  | grep -v foreign | grep -v timestamp | grep -v id\(\)` # | sed "s/.*'\([A-Za-z]*\)'.*/\1/g"` #explanation: grab the column names out from the quotes, excluding foreign key definition since it would be duplicate
    IFS='$'
    for line in ${getfieldsresult}; do
        f=`echo $line | sed "s/.*'\([A-Za-z0-9]*\)'.*/\1/g" | head -n 1`
        t=`echo $line | sed "s/.*>\([A-Za-z]*\)(.*/\1/g" | head -n 1`
        if [[ ! $f =~ ^[A-Za-z0-9]* ]]; then continue; fi
        fields+=($f)
        types+=($t)
    done
    
    if [[ ! -f resources/views/${model_LC} ]]; then
        mkdir -p resources/views/${model_LC}
    fi
    cp templates/form_create.template.html $formFile
    for i in $(seq 0 ${#fields[@]}); do
        echo $i
        echo ${fields[$i]}
        echo "inserting "${fields[$i]}", "${types[$i]}
        insertInput ${types[$i]} ${fields[$i]}
    done
else
    echo "did not find migration file. using models.txt file. THIS FUNCTIONALITY IS CURRENTLY NOT FULLY IMPLEMENTED"
    foundmodel=false
    while read m; do
        if [[ -z ${m} || ${m:0:1} == "#" ]]; then #this line is a comment or blank
            continue;
        fi
        m=`echo ${m} | cut -d# -f1 | cut -d' ' -f1` #remove trailing comment and whitespace
        if [[ ${m:0:1} != [a-zA-Z] && ${m:0:1} != "-" ]]; then #malformed model definition file, model should only begin with a letter
            echo "this model definition file is malformed, exiting."
            echo "  \'${m}\'    "
            exit -1
        fi
        if [[ ! $foundmodel && $m == $model ]]; then
            foundmodel=true
        else
            continue
        fi
        if [[ ${m:0:1} == '-' ]]; then
            ${fields}+=${m:1}
        fi

    done < models.txt
    echo $fields
fi

