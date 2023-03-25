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

if [ -z $1 ]; then
    echo "provide the model name exactly how it is written in your model and controller filenames."
    exit 0
fi

model=$1

#TO use migrations or models.txt?

for mf in database/migrations/*; do
    echo "checking "$mf
    #find the migration file based on the model name, which could cause problems because of singular-plural situation, so use the first 4 chars, which obviously does not cover many edge cases
    if [[ `echo $mf | sed 's/_//g' | grep -i ${model:0:4}` ]]; then
        filename=$mf
    fi
done
