use strict;
use warnings;

package Retail::Model::Supply;
use Jifty::DBI::Schema;

use Retail::Record schema {
    column provider => references Retail::Model::Provider;

    column draft =>
        type is 'boolean',
        default is 1;

    column commodities =>
        references Retail::Model::SupplyCommodityCollection by 'supply';

};

sub before_delete {
    my ($self) = @_;
    $self->id;
    my $commodities = $self->commodities;
    while(my $commodity = $commodities->next) {
        $commodity->delete;
    }
    return 1;
}

1;

