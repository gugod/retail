package Retail::Dispatcher;
use strict;
use warnings;
use utf8;
use Jifty::Dispatcher -base;

on GET '/buy/providers/*' => run {
    my $p = Jifty->app_class(Model => "Provider")->new;
    $p->load($1);

    set provider => $p;
    show("/buy/providers");
};

1;

