package Retail::Dispatcher;
use strict;
use warnings;
use utf8;
use Jifty::Dispatcher -base;
use Jifty::ModelHelpers;

on GET '/buy/providers/*' => run {
    my $p = Provider($1);

    set provider => $p;
    show("/buy/providers");
};

1;

