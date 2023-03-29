#!/bin/python3

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

import os
import sys
import subprocess

### GLOBAL VARIABLES ###
#map table column types (from migration file) to html input tags
htmlInputTypes=dict()
htmlInputTypes["integer"]="number"
htmlInputTypes["float"]="number"
htmlInputTypes["string"]="text"
htmlInputTypes["dateTime"]="datetime-local"

htmlInputTemplate=open('templates/input_simple.template.html', 'r').read()
htmlTextAreaTemplate=open('templates/input_textarea.template.html', 'r').read()
htmlFormCreateTemplate=open('templates/input_simple.template.html', 'r').read()

if sizeof(sys.argv) < 2:
    print("provide the model name, as it appears in the filename of the app/Model/ file")
    sys.exit()
model=sys.argv[0]
model_LC=model.lower()
model_plural=
formFile="resources/views/${model_LC}/create.blade.php"
fields=dict() #Map<fieldname, datatype>
