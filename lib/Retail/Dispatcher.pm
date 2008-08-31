package Retail::Dispatcher;
use strict;
use warnings;
use utf8;
use Jifty::Dispatcher -base;
use Jifty::ModelHelpers;

on GET '/buy' => run {
    redirect("/provider");
};

on GET '/provider/*/buy' => run {
    my $p = Provider($1);

    set provider => $p;
    show("/provider/buy");
};

1;

