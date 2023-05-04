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

FORCE=false #if file already exists, skip user confirm or not

while getopts "f" opt; do
    case $opt in
        f)
            FORCE=true
            shift
            ;;
    esac
done

if [[ $1 ]]; then
    model=$1
else
    echo "provide a model name as arg"
    exit 0
fi

cf="app/Http/Controllers/${model}Controller.php"

if [[ ! $FORCE && -f $cf ]]; then
    echo "controller file ${cf} already exists. are you sure? (y/n)"
    read c
    if [[ ! ${c,,} == 'y' ]]; then
        echo "ok. exiting."
        exit 0
    fi
fi
cp templates/Controller.template.php $cf

model_LC=`echo ${model} | tr '[:upper:]' '[:lower:]'`
model_plural=`./pluralize ${model_LC} | tail -n 1`

sed -i "s/--model--/${model}/g" $cf
sed -i "s/--model_lowercase--/${model_LC}/g" $cf
sed -i "s/--model_plural--/${model_plural}/g" $cf
sed -i "s/^ *--.*-- *$//g" $cf #remove lines that start & end with "--", accounting for whitespace

if [[ ! `grep "function ctrler"` ]]; then
    cat stubs/routes_ctlrer_function >> routes/web.php
fi

#setup create/update using the fields and datatypes from the migration file
#for f in `ls database/migrations/ `; do
#    fNoUnderscore=`echo ${f} | sed 's/_//g'`
#    if [[ $fNoUnderscore == *${model_plural}* ]]; then
#        migration_file="database/migrations/"${f}
#    fi
#done
#echo "Using migration: "$migration_file
#declare -A fields #=()
#getfieldsresult=`cat ${migration_file} | grep "\$table-"  | grep -v foreign | grep -v timestamp | grep -v id\(\) | tr -d '\n'` # | sed "s/.*'\([A-Za-z]*\)'.*/\1/g"` #explanation: grab the column names out from the quotes, excluding foreign key definition since it would be duplicate
#IFS='$'
#for line in ${getfieldsresult}; do
#   f=`echo "$line" | sed "s/.*'\([A-Za-z0-9_]*\)'.*/\1/g" | head -n 1`
#    t=`echo "$line" | sed "s/.*>\([A-Za-z]*\)(.*/\1/g" | head -n 1`
#    if [[ ! $f =~ ^[A-Za-z0-9_]* || $f =~ [\ ] ]]; then continue; fi
#    echo $f" valid"
#    fields+=($f)
#    sed -i "s/'--field--' => \$request->--field--,/{p;s//$f/;}" $cf
#done



echo "Route::resource('${model_plural}', ctrler('${model}');" >> routes/web.php  #there is no closing php tag in web.php



echo "Done."
