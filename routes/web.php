<?php

use Illuminate\Support\Facades\Route;

Route::controller(App\Http\Controllers\UserController::class)->group(function () {
    Route::post('/user/login', 'login')->name('user.login');
    Route::post('/user/logout', 'logout')->name('user.logout');
    Route::get('/user/loadUser', 'get')->name('user.loadUser');
});

Route::get('/', function () {
    return view('home');
});
