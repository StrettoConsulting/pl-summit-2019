<?php

namespace Tests\Feature;

use Tests\TestCase;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Mockery;
use Bitcoin;

class ExampleTest extends TestCase
{
    /**
     * A basic test example.
     *
     * @return void
     */
    public function testBasicTest()
    {
        $response = $this->get('/');

        $response->assertStatus(200);
    }

    public function testShowsCurrentBitcoinPrice()
    {
        $mock = Mockery::mock(Bitcoin::class);
        $mock->shouldReceive('getRate')->andReturn('4,000');
        \App::instance(Bitcoin::class, $mock);

        $response = $this->get('/');


        $response->assertSee("4,000");
    }

}
