use strict;
use warnings;

package Retail::Model::Supply;
use Jifty::DBI::Schema;

use Retail::Record schema {
    column provider =>
        type is 'integer',
        references Retail::Model::Provider;

    column draft =>
        type is 'boolean',
        default is 1;

    column commodities =>
        type is 'integer',
        references Retail::Model::SupplyCommodityCollection by 'supply';

    column happened_on =>
        since '0.0.2',
        label is _("Date"),
        hints is _("The actual date which this supply order was issued."),
        type is 'date',
        render_as "Date";

};

sub before_delete {
    my ($self) = @_;
    my $commodities = $self->commodities;
    while(my $commodity = $commodities->next) {
        $commodity->delete;
    }
    return 1;
}

sub summary {
    my ($self) = @_;
    my %summary;
    my $commodities = $self->commodities;
    while(my $record = $commodities->next) {
        $summary{"Subtotal (" . $record->currency . ")"}
            += $record->price * $record->quantity;
    }
    $summary{Tax} = 0;

    return %summary
}

1;

