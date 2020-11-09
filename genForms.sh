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

#this scripts generates the forms that one can use to create instances of models
#takes two args: [filename of database migration of mode] [model name]
filename=$1
model=$2 #TODO use models.txt instead of these two args
controller="${model}Controller"

form='<form role="form" method="POST" action="{{ action("'${controller}'@store") }}">\n'
form+='{{csrf_field()}}\n'


while read l; do
    if [[ `echo $l | grep "Schema::create"` != "" ]]; then
        table_name=`echo $l | sed "s/Scheme::create(//" | cut -d "'" -f 2`
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
    form+='<label for = "'${attr}'" class = "col-me-2 control-label">'${attr}'</label>\n'
    form+='<input type = "text" id = "'${attr}'" class = "form-control" name = "'${attr}'" value="{{ old( "'${attr}'")}}" autofocus></input>\n'

    form+='</div>'

done < "database/migrations/"$filename

form+='<div class="form-group">\n'
form+='<div class="col-md-8 col-md-offset-2">\n'
form+='<button type="submit">Submit</button>\n'
form+='</div></div>'
form+='</form>'

#awk "/\'/,/\'/" database/migrations/$filename

echo -e $form
