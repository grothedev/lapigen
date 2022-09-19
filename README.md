Laravel API Model and Form Generation Application

this is a set of software development tools used to generate code for laravel APIs. after using laravel to write a handful of APIs, i found myself repeating the same boilerplate code multiple times, so i wrote some scripts to write as much of that for me as possible. 

instructions:
    1. create a models-definition file (models.txt, for example) to contain the names of each of your models and properties (see the sample file for syntax)
    2. run 'genModels.sh' to generate the model files (app/Model.php) and the database migration files (datatabase/migrations/create_model_table.php) for each of your models. 
    3. if necessary, manually finish the database migration file
    4. use 'genRelatedFiles.sh' to generate views and/or controllers for all or some models
    5. write code manually as needed: validation, authentication, other specific functionality, foreign database relationships, routes



Name ideas:

LAPIGen - Laravel API code generation tool
LMoGen - Laravel model code generation tool
LMoCoGen - Laravel model code generation tool
LAPIMoCoGen - Laravel model code generation tool

TODO: 
    - field fixer script
    - write form files 
    - validation rules
    - model relationships (is-a, has-a, etc.)
    - routes
