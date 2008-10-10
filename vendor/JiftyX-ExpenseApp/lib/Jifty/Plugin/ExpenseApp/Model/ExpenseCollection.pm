use strict;
use warnings;

package Jifty::Plugin::ExpenseApp::Model::ExpenseCollection;
use base qw/Jifty::Plugin::ExpenseApp::Collection/;

sub record_class { 'Jifty::Plugin::ExpenseApp::Model::Expense' }

sub all_time_summary {
    my ($self) = @_;

    my $sum = __PACKAGE__->new;

    unless ( Jifty->config->framework("SkipAccessControl") ) {
        my $id = Jifty->web->current_user->id;
        if (defined($id)) {
            $sum->limit(column => 'created_by', value => $id);
        }
        else {
            $sum->limit(column => 'created_by', operator => "IS", value => 'NULL');
        }
    }

    $sum->order_by(
        {column => "happened_at", order => "DES"},
        {column => "id", order => "DES"}
    );

    $sum->column( column => "category" );
    $sum->column( column => "currency" );
    $sum->column( column => "amount", function => "SUM" );
    $sum->order_by(
        { column => "currency"},
        { function => "SUM(amount)", order => "DES" }
    );

    $sum->group_by({ column => "category" }, { column => "currency" });

    my $sql_query = $sum->build_select_query;
    my $records = $sum->_handle->simple_query($sql_query);
    my $summary = [];
    while ( my $row = $records->fetchrow_hashref() ) {
        push @$summary, {
            category => $row->{main_category},
            amount => $row->{main_amount},
            currency => $row->{main_currency}
        };
    }

    return $summary;
}

1;
