use strict;
use warnings;

package Retail::Model::Commodity;
use Jifty::DBI::Schema;

use Retail::Record schema {
    column name =>
        type is 'varchar(255)';

};

# Your model-specific methods go here.

1;

