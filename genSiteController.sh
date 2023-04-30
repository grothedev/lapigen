#!/bin/bash

echo "genSiteCtrlr"
models=$1

dstFile="app/Http/Controllers/SiteController.php"
cp templates/SiteController.template.php $dstFile

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
    
    sed -i "s/--model--/\"${m}\",--model--/g" $dstFile
    
done < models.txt

sed -i "s/--.*--//g" $dstFile
