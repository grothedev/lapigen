Laravel API Model and Form Generation Application

this is a set of software development tools used to generate code for laravel APIs. after using laravel to write a handful of APIs, i found myself repeating the same boilerplate code multiple times, so i wrote some scripts to write as much of that for me as possible. 

instructions:

    1. create a models-definition file (models.txt, for example) to contain the names of each of your models and properties (see the sample file for syntax)
    2. run 'genModels.sh' to generate the model files (app/Model.php) and the database migration files (datatabase/migrations/create_model_table.php) for each of your models. 
    3. if necessary, manually finish the database migration file
    4. use 'genRelatedFiles.sh' to generate the form views for REST actions and/or controllers for all or some models
    5. write code manually as needed: validation, authentication, other specific functionality, foreign database relationships, routes

how this works:

    1. calls "artisan make:model" to make default model and migration files
    2. replaces and inserts the appropriate text in those files
    3. uses template files, such as "Controller.template.php" to copy into the project, rename, and replace the variables with the correct values, such as model or field
    4. leaves "//TODO" comments where developer must pick up

Name ideas:

LAPIGen - Laravel API code generation tool
LMoGen - Laravel model code generation tool
LMoCoGen - Laravel model code generation tool
LAPIMoCoGen - Laravel model code generation tool

TODO: 
    - controller generation: authentication conditions. pass username or bool field of User into script?\
        - how redirections are specified
        - write the unauthorized page
        - should i actually use the laravel FormRequest, Validator, etc.?
    - field fixer script
    - finish form and view files
        - create & edit are done. 
        - need to do vue.js versions too. map existing html forms to dynamic vue components. 
    - incude api as separate from normal views
    - validation rules
    - model relationships (is-a, has-a, etc.)
    - generate admin pages for editing
    - use other models for datatype, and have the foreign key relationship generated

Think about:
    - some way of adding metadata with fields for human-compatible descriptions
    - relations.txt: pivot tables etc.
    - look into using laravel Component, which is in app/View/Components/  
