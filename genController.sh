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

if [[ $1 ]]; then
    model=$1
else
    echo "provide a model name as arg"
    exit 0
fi

cf="app/Http/Controllers/${model}Controller.php"

#index
code_index="\$m = ${model}::all();\nreturn view('${model}.index'\, compact('${model}');"
echo $code_index
sed -i "s,index\(.*\)//,index\1${code_index}," $cf

code_create=""

code_store=""

code_edit=""

code_show=""