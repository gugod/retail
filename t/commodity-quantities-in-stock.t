#!/usr/bin/env perl

use lib 't/lib';

use strict;
use warnings;

use Jifty::Test tests => 4;
use JiftyX::ModelHelpers;

use Retail::Test::Fixtures qw(providers commodities);

my $good_company = Provider(name => "good.com");

my $a = Commodity(name => "Hello Kitty A");

is($a->quantities_in_stock, 0, "Initially its stockless");

add_supply($a, 10, 0);

is($a->quantities_in_stock, 10, "Added 10");

add_supply($a, 15, 0);

is($a->quantities_in_stock, 25, ".. added another 15");

# # Draft supply.
add_supply($a, 15, 1);
is($a->quantities_in_stock, 25, "A draft supply shouldn't count.");


sub add_supply {
    my $record = shift;
    my $quantity = shift;
    my $draft = shift;

    my $s = Supply->create(
        provider => $good_company,
        draft => $draft
    );

    SupplyCommodity->create(
        supply => $s,
        commodity => $a,
        quantity => $quantity
    );
}
