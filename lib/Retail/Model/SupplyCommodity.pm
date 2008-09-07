use strict;
use warnings;

package Retail::Model::SupplyCommodity;
use Jifty::DBI::Schema;

use Retail::Record schema {
    column supply =>
        references Retail::Model::Supply;

    column commodity =>
        label is _("Commodity"),
        references Retail::Model::Commodity;

    column quantity =>
        label is _("Quantity"),
        type is 'integer';

    column price =>
        label is _("Price"),
        type is 'integer';

    column retail_price =>
        label is _("Retail Price"),
        type is 'integer';

    column currency =>
        label is _("Currency"),
        type is 'VARCHAR(16)',
        valid_values are qw(JPY NTD);

};


1;

