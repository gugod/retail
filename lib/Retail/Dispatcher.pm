package Retail::Dispatcher;
use strict;
use warnings;
use utf8;
use Jifty::Dispatcher -base;
use JiftyX::ModelHelpers;

before '*' => run {
    my $menu = Jifty->web->navigation;
    $menu->child(supply => label => _("Supply"), url => "/supply");
    $menu->child(sale => label => _("Sale"), url => "/sale");
    $menu->child(stock => label => _("Stock"), url => "/stock");

    my $supply_menu = $menu->child('supply');
    $supply_menu->child(list => label => _("History"), url => "/supply/history");

    my $sale_menu = $menu->child("sale");
    $sale_menu->child(list => label => _("History"), url => "/sale/history");

};

on "/provider/#/supply" => run {
    my $id;
    my $c = SupplyCollection(provider => $1, draft => 1);

    if ($c->count >= 1) {
        $id = $c->first->id;
    }
    else {
        $id = Supply->create(provider => $1);
    }

    redirect "/provider/$1/supply/$id";
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

on '/consumer/#/sale' => run {
    my $id;
    my $c = SaleCollection(consumer => $1, draft => 1);

    if ($c->count >= 1) {
        $id = $c->first->id;
    }
    else {
        $id = Sale->create(consumer => $1);
    }

    redirect "/consumer/$1/sale/$id";
};

on '/consumer/#/sale/#' => run {
    my $sale = Sale($2);
    unless ($sale->id) {
        redirect "/consumer"
    }

    set consumer => Consumer($1);
    set sale => $sale;

    show "/consumer/sale";
};

on GET '/commodity/id/#/pic.png' => run {
    set id => $1;
    show "/commodity/pic";
};

on '/supply/#' => run {
    set id => $1;
    set supply => Supply($1);

    show '/supply/view';
};

1;

