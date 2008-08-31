use strict;
use warnings;

package Retail::Model::Commodity;
use Jifty::DBI::Schema;

use Retail::Record schema {
    column name =>
        type is 'varchar(255)';

    column pic =>
        type is "blob",
        render as "Upload";


};

# Your model-specific methods go here.

1;

