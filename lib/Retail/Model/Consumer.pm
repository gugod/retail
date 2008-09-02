use strict;
use warnings;

package Retail::Model::Consumer;
use Jifty::DBI::Schema;

use Retail::Record schema {
    column name =>
        type is 'varchar(255)',
        label is _("Name"),
        is mandatory,
        is indexed;
        is autocompleted,

    column phone_number =>
        type is 'varchar(255)',
        label is _("Phone number"),
        is indexed,
        is autocompleted;

    column shipping_address =>
        type is 'text',
        label is _("Shipping address");

    column memo =>
        type is 'text',
        label is _("Memo"),
        hints is _("Anything special for this consuemr ?"),
        render as 'Textarea';

};

1;

