<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/fetch-data', [App\Http\Controllers\ApiController::class, 'fetchData']);
