<?php

-- this is a template file to be used by lapigen. any string that starts and ends with "--" will be replaced by a value, or removed. i chose hyphens because they are not used for anything else in php. at least not in my use case.--

namespace App\Http\Controllers;

use App\Models\--model--;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class --model--Controller extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $--model_plural-- = --model--::all();
        return $--model_plural--;
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        if (Auth::user() != null){ //TODO user conditions? 
            return view('--model_lowercase--.create');//, compact(''));
        } else {
            $msg = "You are not authorized to view this page.";
            return redirect('/unauthorized', compact('msg'));
        }
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        if (Auth::user() != null){ //TODO user conditions
            $request->validate([]); //TODO
            
            $fieldsArray = [];
            foreach (--model--::$fields as $field){
                array_push($fieldsArray, [$field => $request->$field]);
            }

            $--model_lowercase-- = --model--::create([ $fieldsArray ]); //customize this if you need to

            $msg = "--model-- added. id=".$--model_lowercase--->id;
            return view('--model_lowercase--.show', compact('--model_lowercase--', 'msg'));
        } else {
            $msg = "You are not authorized.";
            return redirect('/unauthorized', compact('msg'));
        }
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\--model--  $--model_lowercase--
     * @return \Illuminate\Http\Response
     */
    public function show(--model-- $--model_lowercase--)
    {
        if (Auth::user() != null){ //TODO user conditions
            return view('--model_lowercase--.show', compact('--model_lowercase--'));
        } else {
            $msg = "You are not authorized to view this page.";
            return redirect('/unauthorized', compact('msg'));
        }
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\--model--  $--model_lowercase--
     * @return \Illuminate\Http\Response
     */
    public function edit(--model-- $--model_lowercase--)
    {
        if (Auth::user() != null){ //TODO user conditions
            return view('--model_lowercase--.edit', compact('--model_lowercase--'));
        } else {
            $msg = "You are not authorized to view this page.";
            return redirect('/unauthorized', compact('msg'));
        }
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\--model--  $--model_lowercase--
     * @return \Illuminate\Http\Response
     */
    public function update(Request $req, $id)
    {
        if (Auth::user() != null){ //TODO user conditions
            $req->validate([]); //TODO

            $--model_lowercase-- = --model--::findOrFail($id);
            if ($req->--field--) $--model_lowercase--->--field-- = $req->--field--;
            $--model_lowercase--->save();

            $msg = 'item updated';
            return view('--model_lowercase--.show', compact('--model_lowercase--', 'msg'));
        } else {
            $msg = "You are not authorized.";
            return redirect('/unauthorized', compact('msg'));
        }
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\--model--  $--model_lowercase--
     * @return \Illuminate\Http\Response
     */
    public function destroy(--model-- $--model_lowercase--)
    {
        if (Auth::user() != null){ //TODO user conditions
            $--model_lowercase--->delete();
            return redirect('/--model_lowercase--');
        } else {
            $msg = "You are not authorized.";
            return redirect('/unauthorized', compact('msg'));
        }
    }
}
