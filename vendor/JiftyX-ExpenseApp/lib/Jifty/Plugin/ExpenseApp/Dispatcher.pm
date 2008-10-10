use strict;
use warnings;

package Jifty::Plugin::ExpenseApp::Dispatcher;

use Jifty::Dispatcher -base;

before '*' => run {
    my $top = Jifty->web->navigation;
    $top->child(
        'ExpensesApp',
        url         => "/=/x/expenses",
        label      => _('Expenses'),
        sort_order => 900
    );
};

my $model_class = "Jifty::Plugin::ExpenseApp::Model::Expense";

sub Expense {
    Jifty::Util->require($model_class);

    $model_class->new;
}

sub ExpenseCollection {
    my $c = "${model_class}Collection";
    Jifty::Util->require($c);

    $c = $c->new;
    $c->unlimit;
    unless ( Jifty->config->framework("SkipAccessControl") ) {
        my $id = Jifty->web->current_user->id;
        if (defined($id)) {
            $c->limit(column => 'created_by', value => $id);
        }
        else {
            $c->limit(column => 'created_by', operator => "IS", value => 'NULL');
        }
    }
    $c->order_by(
        {column => "happened_at", order => "DES"},
        {column => "id", order => "DES"}
    );

    return $c;
}

on '/=/x/_expenses' => run {
    set create_action => Expense->as_create_action;
    set expenses => ExpenseCollection;
};

on '/=/x/expenses/reports' => run {

    set summary => ExpenseCollection->all_time_summary;
};

1;
