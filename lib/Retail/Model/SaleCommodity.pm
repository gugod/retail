use strict;
use warnings;

package Retail::Model::SaleCommodity;
use Jifty::DBI::Schema;

use Retail::Record schema {
    column sale =>
        references Retail::Model::Sale;

    column commodity =>
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

1;

