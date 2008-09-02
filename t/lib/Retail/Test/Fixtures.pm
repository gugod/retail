package Retail::Test::Fixtures;

use JiftyX::ModelHelpers;

sub import {
    load(@_);
}

# Retail::Test::Fixtures->load(qw(providers commodities))

sub import {
    my ($class, @fixtures) = @_;
    for(@fixtures) {
        if ($class->can($_)) {
            $class->$_();
        }
    }
}

sub providers {
    Provider->create(name => "good company");
}

sub consumers {
    Consumer->create(name => "good consumer");
}

sub commodities {
    Commodity->create(name => "Hello Kitty A");
}


1;
