<?php

namespace Database\Seeders;

use App\Models\User;
// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // User::factory(10)->create();

        if (User::all()->where('email', 'test@example.com')->count() == 0)
(new \App\Models\User\UserFactory())->create([
            'name' => 'Test User',
            'email' => 'test@example.com',
        ]);
    }
}
