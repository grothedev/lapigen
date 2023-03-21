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

#this script will insert the appropriate text into the controller file of the given model
#TODO: custom redirect upon unauth
#TODO: does laravel generate plural view files or what?


use_auth=True

if [[ $1 ]]; then
    model=$1
else
    echo "provide a model name as arg"
    exit 0
fi

cf="app/Http/Controllers/${model}Controller.php"

if [[ ! -f $cf ]]; then
    echo "no controller file: $cf"
    echo "is capitalization correct?"
    exit 0
fi

model_LC=`echo ${model} | tr '[:upper:]' '[:lower:]'`
model_plural=`./pluralize ${model_LC} | tail -n 1`

#index
code_index="\$m = ${model}::all();\nreturn view('${model}.index'\, compact('${model}');"
#echo $code_index
sed -i "s,index\(.*\)//,index\1${code_index}," $cf

if [[ $use_auth ]]; then
    code_create=
        "if (Auth::user() != null ){ //TODO other conditions
            return view('${model}.create');
         } else {
            return redirect('/');
         }"
else
    code_create="return view('${model}.create');"
fi
sed -i "s,create\(.*\)//,create\1${code_create}," $cf

if [[ $use_auth ]]; then
    code_store=
        "if (Auth::user() != null ){ //TODO other conditions
            \$request->validate([]); //TODO validation rules
            \$m = ${model}::create([]); //TODO fields
            return json_encode(\$m);
         } else {
            return redirect('/');
         }"
else
    code_store=
            "\$request->validate([]); //TODO validation rules
            \$m = ${model}::create([]); //TODO fields
            return json_encode(\$m);"
fi
sed -i "s,store\(.*\)//,store\1${code_store}," $cf

code_edit=""

code_show=""
