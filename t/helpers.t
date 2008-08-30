#!/usr/bin/env perl

use strict;
use warnings;

use Jifty::Test tests => 3;
use Retail::Helpers;
use Text::Greeking;

my $tg = Text::Greeking->new;
$tg->paragraphs(1,1);
$tg->sentences(1,1);
$tg->words(1,2);

# Create 10 records
for(0..9) {
    my $p = Jifty->app_class(Model => "Provider")->new;
    $p->create(name => $tg->generate);
}

# load
{
    my $p0 = Jifty->app_class(Model => "Provider")->new;
    $p0->load(1);

    my $p = Provider(1);
    is($p->id, 1);
    is($p->name, $p0->name);
}

# load a collection
{
    my $c = ProviderCollection;
    is($c->count, 10);
}
