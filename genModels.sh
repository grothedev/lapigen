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

prev=""
props=() #array of properties of model
rprops=false #reading properties of model
columnTypes=() #array of datatypes of the properties, in same order as props array
model="" #the name of the model currently being constructed
ver=`./artisan --version | cut -d' ' -f3 | cut -d'.' -f1`  #check if laravel version >7 to use app/Models/

#runs the artisan commands to generate the files for the current model and properties and modifies the files as necessary.
#note that global variables are used
function makeModel {
    if [[ $((ver)) -gt 7 ]]; then
        model_filename="app/Models/${model}.php"
    else 
        model_filename="app/${model}.php"
    fi
    
    #check if model already exists
    if [[ -f ${model_filename} ]]; then
        return
    fi

    #have artisan make the model file
    ./artisan make:model --migration "$model"
    echo "artisan made model "${model}

    #get the fields ready to add to the model definition file
    fields=''
    for p in ${props[@]}
    do
        fields+="'"$p"', "
    done
    #insert fillable values into model definition file
    sed -i "s!{!{\n    protected \$fillable = [$fields];!g" ${model_filename}

    #make the controller
    ./genController.sh ${model}

    #insert fields into database migration file
    for mf in `ls database/migrations/*`; do
        if [[ `echo $mf | sed 's/_//g' | grep -i ${model:0:3}` ]]; then #this is migration file we want to modify
            #sed -i "s/id();/id(); \/\/TODO: fill in these fields: ${fields}/g" $mf
            for (( i=0; i<${#props[*]}; i++ )); do
                if [[ ${columnTypes[$i]} != "" ]]; then
                    if [[ ${columnTypes[$i]:0:1} =~ ^[A-Z] ]]; then #the column type is another model, because starts with a capital letter
						fieldLC=`echo ${props[$i]} | tr '[:upper:]' '[:lower:]'`
						fieldPlural=`./pluralize ${fieldLC} | tail -n 1`
						
                        sed -i "s/id();/id();\n            \$table->integer(\'${fieldLC}_id\')->unsigned()->nullable()->default(null);/g" $mf
                        sed -i "s/default(null);/default(null);\n            \$table->foreign(\'${fieldLC}_id\')->references(\'id\')->on(\'${fieldPlural}\')->onDelete(\'cascade\');/g" $mf #this is not ideal but it will work for the time being
                    else #column type is a normal database primitive
                        sed -i "s/id();/id();\n            \$table->${columnTypes[$i]}(\'${props[$i]}\');/g" $mf 
                    fi
                else 
                    sed -i "s/id();/id();\n            \/\/TODO: ${props[$i]}/g" $mf
                fi
            done
            break
        fi
    done
}

#parses the property and column type from the given string which should follow the standard as defined in the model-definition file
function addProperty {
    if [[ -z $1 ]]; then return -1; fi
    props+=(`echo ${1} | cut -d':' -f1`)
    if [[ ${1} == *":"* ]]; then #has a column type
        columnTypes+=(`echo ${1} | cut -d':' -f2`)
    else
        columnTypes+=('')
    fi
}

#Begin
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

    if [ $rprops ]; then
        if [ ${m:0:1} == "-" ]; then #we are reading props of a model, append another
            addProperty ${m:1}
        else #this is the start of a definition of a new model. write the previous one to application
            if [[ -z $model ]]; then
                model=$m
                continue;
            fi
            echo "making model: "${model}
            makeModel 
            
            props=()
            columnTypes=()
            model=$m #new model name
        fi
    elif [ ${m:0:1} == "-" ]; then
        rprops=true
        addProperty ${m:1}
    else
        model=$m
    fi
done < models.txt
makeModel #one more model to make


#What is left to do after this script runs:
# relationships between eloquent models 
# 
# TODO what else can reasonably be included in models.txt to extend automatic code generation?
