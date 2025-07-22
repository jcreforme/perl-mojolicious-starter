<?php

namespace App\Http\Controllers;

abstract class Controller
{
    public function fetchData()
    {
        // Make a GET request to the Mojolicious API
        $response = Http::get('http://127.0.0.1:3000/api/data');

        // Return the response data
        return response()->json($response->json());
    }
}
