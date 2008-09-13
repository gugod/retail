use strict;
use warnings;

package Retail::Model::ProviderCommodity;
use Jifty::DBI::Schema;

use Retail::Record schema {
    column provider => references Retail::Model::Provider;
    column commodity => references Retail::Model::Commodity;

    column stock_number =>
        type is 'varchar(255)',
        label is _("Stock Number");
};

1;

