use strict;
use warnings;

package Retail::Model::Provider;
use Jifty::DBI::Schema;

use Retail::Record schema {
    column name =>
        type is 'varchar(255)';

    column address =>
        type is 'text';

    column description =>
        type is 'text';

};

# Your model-specific methods go here.

1;

