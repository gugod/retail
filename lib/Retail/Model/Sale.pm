use strict;
use warnings;

package Retail::Model::Sale;
use Jifty::DBI::Schema;

use Retail::Record schema {
    column consumer =>
        references Retail::Model::Consumer;

    column draft =>
        type is 'boolean',
        default is 1;

    column commodities =>
        references Retail::Model::SaleCommodityCollection by 'sale';

};

sub before_delete {
    my ($self) = @_;
    my $commodities = $self->commodities;
    while(my $commodity = $commodities->next) {
        $commodity->delete;
    }
    return 1;
}


1;

