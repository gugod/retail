use strict;
use warnings;

package Retail::Model::Supply;
use Jifty::DBI::Schema;

use Retail::Record schema {
    column provider => references Retail::Model::Provider;

    column draft =>
        type is 'boolean',
        default is 1;

    column commodities =>
        references Retail::Model::SupplyCommodity by 'supply_id';

};

1;

