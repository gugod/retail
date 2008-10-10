package Retail::Record;
use base 'Jifty::Record';

sub current_user_can {
    my ($self, $right) = @_;

    my $cu = $self->current_user;
    if ($cu->id && $cu->user_object->is_admin) {
        return 1;
    }
    return 0;
}

1;
