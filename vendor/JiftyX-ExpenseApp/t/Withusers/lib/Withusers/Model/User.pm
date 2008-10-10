use strict;
use warnings;

package Withusers::Model::User;
use Jifty::DBI::Schema;

use Withusers::Record schema {
    column location => type is 'varchar(255)';
};

use Jifty::Plugin::User::Mixin::Model::User;
use Jifty::Plugin::Authentication::Password::Mixin::Model::User;

sub brief_description {
    my $self = shift;
    $self->__value("name");
}

1;

