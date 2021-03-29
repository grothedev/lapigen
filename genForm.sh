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

model=$1
controller="${model}Controller"

form='<form role="form" method="POST" action="{{ action("'${controller}'@store") }}">\n'
form+='{{csrf_field()}}\n'

for mf in database/migrations/*; do
    echo "checking "$mf
    if [[ `echo $mf | sed 's/_//g' | grep -i ${model:0:3}` ]]; then #this is the migration file
        filename=$mf
    fi
done

echo "filename = "$filename

while read l; do
    if [[ `echo $l | grep "Schema::create"` != "" ]]; then
        table_name=`echo $l | sed "s/Scheme::create(//" | cut -d "'" -f 2`
        echo "table = "$table_name
        continue
    fi
    if [[ `echo $l | grep "table->"` == "" ]]; then
        continue
    fi
    if [[ `echo $l | grep "'"` == "" ]]; then
        continue
    fi
    l=`echo $l | sed "s/.*table->(//g" `
    attr=`echo $l | cut -d "'" -f 2`
    #m=`echo $l | awk "/\'/,/\'/" `

    form+='<div class="form-group{{ $errors->has("'${attr}'") ? " has-error" : ""}}">\n'
    form+=' <label for = "'${attr}'" class = "col-me-2 control-label">'${attr}'</label>\n'
    form+=' <input type = "text" id = "'${attr}'" class = "form-control" name = "'${attr}'" value="{{ old( "'${attr}'")}}" autofocus></input>\n'

    form+='</div>\n'

done < $filename

form+='<div class="form-group">\n'
form+=' <button type="submit">Submit</button>\n'
form+='</div>\n'
form+='</form>'

#awk "/\'/,/\'/" database/migrations/$filename

#TODO folder name
#form_filename="resources/views/${model}s/create.blade.php"


echo -e $form
