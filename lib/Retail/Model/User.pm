use strict;
use warnings;

package Retail::Model::User;
use Jifty::DBI::Schema;

use Retail::Record schema {
    column is_admin =>
        type is 'boolean',
        render as 'Unrendered',
        default is 0,
        is immutable,
        is mandatory;
};

sub since { '0.0.3' };

use Jifty::Plugin::User::Mixin::Model::User;
use Jifty::Plugin::OpenID::Mixin::Model::User;

sub current_user_can {
    my ($self, $right, $attribute) = @_;
    my $cu = $self->current_user;
    return 1 if $right eq 'create';
    return 0 unless $cu->id;
    return 1 if $self->id == $cu->id;
    return 0;
}

1;

