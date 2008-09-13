use strict;
use warnings;

package Retail::Action::UpdateCommodity;
use base qw/Retail::Action::Record::Update/;

sub record_class { 'Retail::Model::Commodity' }

1;

