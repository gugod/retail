#!/usr/bin/env perl

use lib 't/lib';

use strict;
use warnings;

use Jifty::Test tests => 3;
use JiftyX::ModelHelpers;

# Load required data.
my $good_company = Provider->create(name => "Good.com");

my $a_id = Commodity->create(name => "foo a");

my $a = Commodity($a_id);

is($a->quantities_in_stock, 0);

add_supply($a, 10);

is($a->quantities_in_stock, 10);

add_supply($a, 15);

is($a->quantities_in_stock, 25);

sub add_supply {
    my $record = shift;
    my $quantity = shift;

    my $s = Supply->create(
        provider => $good_company,
        draft => 0
    );

    SupplyCommodity->create(
        supply => $s,
        commodity => $a,
        quantity => $quantity
    );
}
