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

    column tax_rate =>
        since '0.0.2',
        type is 'integer',
        label is _("Tax rate"),
        hints is _("From 0 to 100."),
        default is 5,
        render_as "Text";

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
    my %subtotal;

    while(my $record = $commodities->next) {
        ($subtotal{$record->currency} ||=0) += $record->price * $record->quantity;
    }

    for (keys %subtotal) {
        $summary{"Subtotal ($_)"} = $subtotal{$_};
        $summary{"Subtotal ($_), after-tax"} = $subtotal{$_} * ( 100 + $self->tax_rate) / 100;
    }

    $summary{"Tax Rate"} = $self->tax_rate . " %";
    $summary{"Date"} = $self->happened_on;

    return %summary
}

sub validate_tax_rate {
    my ($self, $value) = @_;
    return (0, _("Tax rate can only be non-negative numbers.")) unless ($value =~ m{^\d+$});

    return 1;
}

1;

