use strict;
use warnings;

package Retail::Model::SaleCommodity;
use Jifty::DBI::Schema;

use Retail::Record schema {
    column sale =>
        type is 'integer',
        references Retail::Model::Sale;

    column commodity =>
        type is 'integer',
        label is _("Commodiy"),
        references Retail::Model::Commodity;

    column quantity =>
        label is _("Quantity"),
        type is 'integer';

    column price =>
        label is _("Price"),
        type is 'integer';

    column currency =>
        label is _("Currency"),
        type is 'VARCHAR(16)',
        valid_values are qw(JPY NTD);
};

sub before_create {
    my ($self, $args) = @_;
    my $sn = delete $args->{stocknumber};
    return 1 if defined $args->{commodity};

    my $r = Jifty->app_class(Model => "ProviderCommodity")->new;
    $r->load_by_cols(stock_number => $sn);

    if ($r->id) {
        $args->{commodity} = $r->commodity->id;
        return 1;
    }

    return 0;
}

1;

