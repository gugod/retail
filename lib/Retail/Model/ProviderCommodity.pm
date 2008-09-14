use strict;
use warnings;

package Retail::Model::ProviderCommodity;
use Jifty::DBI::Schema;

use Retail::Record schema {
    column provider =>
        label is _("Provider"),
        references Retail::Model::Provider;

    column commodity =>
        label is _("Commodity"),
        references Retail::Model::Commodity;

    column stock_number =>
        type is 'varchar(255)',
        label is _("Stock Number");
};

1;

