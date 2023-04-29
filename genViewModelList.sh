#!/bin/bash

# generates a view that lists all models and links to their relevant pages

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
htmlViewTemplate=`cat templates/view_modellist.template.html`
htmlModelListElementTemplate=`cat templates/li_model.template`
viewFile="./resources/views/modelinfo.blade.php"

### FUNCTIONS ###
#insert <li><a> into the list
#args: []
function insertModelListElement {
    if [[ -z $1 && -z $2 ]]; then return -1; fi
    sed -i "/<ul>/r templates/li_model.template" $viewFile
    sed -i "s/--model--/${1}/g" $viewFile
    sed -i "s/--model_plural--/${2}/g" $viewFile
}

cp templates/view_modellist.template.html ${viewFile}

while read m; do
    if [[ -z ${m} || ${m:0:1} == "#" || ${m:0:1} == '-' ]]; then #this line is a comment, field, or blank
        continue;
    fi
    m=`echo ${m} | cut -d# -f1 | cut -d' ' -f1` #remove trailing comment and whitespace
    if [[ ${m:0:1} != [a-zA-Z] && ${m:0:1} != "-" ]]; then #malformed model definition file, model should only begin with a letter
        echo "this model definition file is malformed, exiting."
        echo "  \'${m}\'    "
        exit -1
    fi
    
    mp=`./pluralize ${m} | tail -n 1 | tr [:upper:] [:lower:]`
    echo "inserting "${m}" "${mp}
    insertModelListElement ${m} ${mp}

    #model fields/attributes
    #TODO 
    #declare -A fields #=()
    ##declare -A types #=()
    #getfieldsresult=`cat ${migration_file} | grep "\$table-"  | grep -v foreign | grep -v timestamp | grep -v id\(\) | tr -d '\n'` # | sed "s/.*'\([A-Za-z]*\)'.*/\1/g"` #explanation: grab the column names out from the quotes, excluding foreign key definition since it would be duplicate
    #IFS='$'
    #for line in ${getfieldsresult}; do
    #    f=`echo "$line" | sed "s/.*'\([A-Za-z0-9]*\)'.*/\1/g" | head -n 1`
    ##    t=`echo "$line" | sed "s/.*>\([A-Za-z]*\)(.*/\1/g" | head -n 1`
     #   if [[ ! $f =~ ^[A-Za-z0-9]* || $f =~ [\ ] ]]; then continue; fi
     #   echo $f" valid"
     #   fields+=($f)
     #   types+=($t)
     #   echo "inserting "$f", "$t
    #    insertInput $t $f
    #done
    
done < models.txt

if [[ -z `grep "modelinfo.blade.php" routes/web.php` ]]; then
    echo "Route::view('m', 'modelinfo');" >> routes/web.php  #there is no closing php tag in web.php
fi