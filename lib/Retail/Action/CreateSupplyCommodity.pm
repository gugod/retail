use strict;
use warnings;

package Retail::Action::CreateSupplyCommodity;
use base qw/Retail::Action::Record::Create/;

sub record_class { 'Retail::Model::SupplyCommodity' }

use Jifty::Param::Schema;
use Jifty::Action schema {
    param stocknumber =>
        label is _("Stock number"),
        render as "Text",
        autocompleter is \&autocomplete_stocknumber,
        order is 1;
};

sub autocomplete_stocknumber {
    my ($self, $value) = @_;
    my $c = Jifty->app_class(Model => "ProviderCommodityCollection")->new;
    $c->limit(
        column => "stock_number",
        value => $value,
        operator => 'MATCHES'
    );
    return map { {
        label => $_->commodity->name . " (" . $_->stock_number . ")",
            value => $_->stock_number
    } } @{ $c->items_array_ref }
}

1;
