<?php

-- this is a template file to be used by lapigen. any string that starts and ends with "--" will be replaced by a value, or removed. i chose hyphens because they are not used for anything else in php. at least not in my use case.--

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Pluralizer;

class SiteController extends Controller
{

    public static $MODELS = [ --model-- ]; //list of all the models of the application
    //public $MODELS_LC_PLURAL = [];

    /*
    * provides the global state model to be used by the client javascript application
    */
    public static function AppState(){
        $state = []; //appstate to return

        foreach (SiteController::$MODELS as $modelName){
            $modelLCPlural = Pluralizer::plural(strtolower($modelName));

            $modelClass = "App\\Models\\".$modelName;
            array_push($state, [ $modelLCPlural => $modelClass::all() ]);
            
            /*foreach ($modelItems as $m){
                TODO foreign keys
            }*/
        }
        return $state;
    }
}