use strict;
use warnings;

package Retail::Model::SaleCommodity;
use Jifty::DBI::Schema;

use Retail::Record schema {
    column sale =>
        references Retail::Model::Sale;

    column commodity =>
        references Retail::Model::Commodity;

    column quantity => type is 'integer';

    column price => type is 'integer';
    column currency =>
        type is 'VARCHAR(16)',
        valid_values are qw(JPY NTD);
};

1;

