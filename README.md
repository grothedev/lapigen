Laravel API Model and Form Generation Application

this is a set of software development tools used to generate code for laravel APIs. after using laravel to write a handful of APIs, i found myself repeating the same boilerplate code multiple times, so i wrote some scripts to write as much of that for me as possible. 

instructions:
    1. create a models-definition file (models.txt, for example) to contain the names of each of your models and properties (see the sample file for syntax)
    2. run 'genModels.sh' to generate the model files (app/Model.php) and the database migration files (datatabase/migrations/create_model_table.php) for each of your models. 
    3. if necessary, manually finish the database migration file
    4. write your controller methods

Name ideas:

LAPIGen - Laravel API code generation tool
LMoGen - Laravel model code generation tool
LMoCoGen - Laravel model code generation tool
LAPIMoCoGen - Laravel model code generation tool