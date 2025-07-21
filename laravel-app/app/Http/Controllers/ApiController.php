<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class ApiController extends Controller
{
    public function fetchData()
    {
        return response()->json(['message' => 'Data fetched successfully!']);
    }
}
