use strict;
use warnings;

package Retail::Model::Provider;
use Jifty::DBI::Schema;

use Retail::Record schema {
    column name =>
        label is _("Name"),
        type is 'varchar(255)';

    column address =>
        label is _("Address"),
        type is 'text';

    column description =>
        label is _("Description"),
        render as "Textarea",
        type is 'text';

};

1;

