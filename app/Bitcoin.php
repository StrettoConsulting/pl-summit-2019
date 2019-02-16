<?php

class Bitcoin
{
    public function getRate()
    {
        $content = file_get_contents('https://api.coindesk.com/v1/bpi/currentprice.json');
        $json = json_decode($content, true);
        return $json['bpi']['USD']['rate'];
    }
}
