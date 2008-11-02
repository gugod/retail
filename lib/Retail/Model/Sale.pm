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

    column happened_on =>
        since '0.0.2',
        label is _("Date"),
        hints is _("The actual date which this sale order was issued."),
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
    my %subtotal;

    while(my $record = $commodities->next) {
        ($subtotal{$record->currency} ||=0) += $record->price * $record->quantity;
    }

    for (keys %subtotal) {
        $summary{"Subtotal ($_)"} = $subtotal{$_};
    }

    $summary{"Date"} = $self->happened_on;

    return %summary

}

1;

