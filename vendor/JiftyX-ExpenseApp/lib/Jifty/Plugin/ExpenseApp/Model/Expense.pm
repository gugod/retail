use strict;
use warnings;

package Jifty::Plugin::ExpenseApp::Model::Expense;

use Jifty::DBI::Schema;
use base 'Jifty::DBI::Record::Plugin';

use Jifty::Plugin::ExpenseApp::Record schema {
    column created_at =>
        type is 'timestamp',
        render as "Hidden",
        default is defer { Jifty::DateTime->now },
        filters are ('Jifty::Filter::DateTime', 'Jifty::DBI::Filter::DateTime');

    column created_by =>
        type is 'int',
        render_as "Hidden",
        default is defer { Jifty->web->current_user->id };

    column happened_at =>
        type is 'timestamp',
        render_as "Date",
        label is _("Date"),
        is mandatory,
        filters are ('Jifty::Filter::DateTime', 'Jifty::DBI::Filter::DateTime');

    column amount =>
        type is 'int',
        label is _("Amount of money"),
        is mandatory;

    column currency =>
        type is 'varchar(255)',
        label is _("Currency"),
        render as "Radio",
        is mandatory,
        valid_values are qw(USD EUR JPY NTD);

    column category =>
        type is 'varchar(255)',
        label is _("Category"),
        hints is _("Any text is OK. You define your own categories.");

    column note =>
        type is 'text',
        label is _("Note"),
        render as 'Textarea';
};

sub current_user_can {
    my ($self, $right, $attr) = @_;
    return 1 if $right eq 'create';
    if ( defined($self->__value("created_by")) ) {
        return 1 if $self->current_user->id == $self->__value("created_by");
    }
    return 0;
}

sub autocomplete_category {
    my ($self, $value) = @_;

    my $c = Jifty::Plugin::ExpenseApp::Model::ExpenseCollection->new;
    $c->limit(
        column => "category",
        operator => "MATCHES",
        value => $value
    );
    $c->group_by(column => "category");
    return map { $_->category } @{ $c->items_array_ref } unless $c->count == 0;

    # Default list
    return (
        _("Food"),
        _("Fuel"),
        _("Books"),
        _("Groceries")
    );
}

1;
