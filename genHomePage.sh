#!/bin/bash

# this script generates a sample homepage that has access to the appstate, 
#   copy template and homepage blade php files
#   copy js file for vue
#   generate the SiteController if it hasn't been done already. 

viewFile="resources/views/home.blade.php"

cp -n templates/template.blade.php resources/views/template.blade.php
cp -n templates/view_base.template.blade.php $viewFile
cp -n templates/BladeServiceProvider.php app/Providers/

sed -i "/'providers' =>/a \        App\\\Providers\\\BladeServiceProvider::class,\n" config/app.php

if [[ ! -f app/Http/Controllers/SiteController.php ]]; then
    ./genSiteController.php
fi

echo "Route::view('/', 'home');" >> routes/web.php
echo "Auth::routes();" >> routes/web.php

#sed -i "s/--.*--//g" $viewFile