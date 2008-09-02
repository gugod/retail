package Retail::Dispatcher;
use strict;
use warnings;
use utf8;
use Jifty::Dispatcher -base;
use JiftyX::ModelHelpers;

on GET '/supply' => run {
    redirect("/provider");
};

on "/provider/#/supply" => run {
    my $supply_id;
    my $c = SupplyCollection(provider => $1, draft => 1);

    if ($c->count >= 1) {
        $supply_id = $c->first->id;
    }
    else {
        $supply_id = Supply->create(provider => $1);
    }

    redirect "/provider/$1/supply/$supply_id";
};

on "/provider/#/supply/#" => run {

    my $supply = Supply($2);
    unless ($supply->id) {
        redirect "/provider"
    }

    set provider => Provider($1);
    set supply => $supply;

    show "/provider/supply";
};

on GET '/commodity/id/#/pic' => run {
    set id => $1;
    show "/commodity/pic";
};

1;

