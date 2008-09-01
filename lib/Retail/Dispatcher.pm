package Retail::Dispatcher;
use strict;
use warnings;
use utf8;
use Jifty::Dispatcher -base;
use Jifty::ModelHelpers;

on GET '/supply' => run {
    redirect("/provider");
};

on "/provider/#/supply" => run {
    my $supply_id = Supply->create(provider => $1);

    redirect "/provider/$1/supply/$supply_id";
};

on "/provider/#/supply/#" => run {
    set provider => Provider($1);
    set supply => Supply($2);
    show "/provider/supply";
};

on GET '/commodity/id/#/pic' => run {
    set id => $1;
    show "/commodity/pic";
};

1;

