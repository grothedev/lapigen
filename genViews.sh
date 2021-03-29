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

#this script generates views for the application models, using lowercase model name standard, not pluralized

#!! DEPRECATED BY 'genRelatedFiles.sh' !!


# args:
#   1: model name, to generate for a single model
#

models=() #array of models to generate views for
dir_views="resources/views/" #directory where views are stored

if [[ $1 ]]; then
    models+=${1}
else
    for mf in app/Models/*; do
        models+=${mf}
    done
fi

for m in ${models}; do
    view_dirname=`tr '[:upper:]' '[:lower:]' ${m}`
    dir=${dir_views}${view_dirname}
    mkdir ${dir}
    #TODO: check if exists, to prevent overwriting if user made customized views
    #index
    if [[ ! -f ${dir}/index.blade.php ]];
        touch ${dir}/index.blade.php #TODO
    fi

    #show
    if [[ ! -f ${dir}/show.blade.php ]];
        touch ${dir}/show.blade.php #TODO
    fi

    #create
    if [[ ! -f ${dir}/create.blade.php ]];
        touch ${dir}/create.blade.php #TODO
    fi
    
    #edit
    if [[ ! -f ${dir}/edit.blade.php ]];
        touch ${dir}/edit.blade.php #TODO
    fi
done