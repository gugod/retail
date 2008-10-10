use strict;
use warnings;

package Jifty::Plugin::ExpenseApp::View;
use Jifty::View::Declare -base;
use utf8;

template '/=/x/expenses' => page {
    title => _("Expenses")
} content {
    div {
        class is "expenseapp";

        hyperlink(url => "expenses/reports", label => _("Expenses Reports"));

        render_region(
            path => "/=/x/_expenses",
            name => "expenses"
        );
    }
};

template '/=/x/_expenses' => sub {

    div {
        class is "create";

        with(
            href => "#",
            id => "expense-create-form-toggler",
        ), a {
            _("Toggle the display of this form.")
        };
        with(type=>"text/javascript"), script {
            outs_raw(<<EOS);

        jQuery("#expense-create-form-toggler").bind("click", function() {
            jQuery(".expenseapp .create form").slideToggle("fast");
        });

EOS
        };

        my $action = get('create_action');
        form {
            render_action( $action );

            form_submit(
                label => _("Add"),
                onclick => {
                    submit => $action,
                    refresh_self => 1
                }
            );
        };
    };

    div {
        class is "list";

        table {
            row {
                th { " " };
                th { _("Date") };
                th { _("Amount") };
                th { _("Currency") };
                th { _("Category") };
                th { _("Note") };
            };

            my $expenses = get('expenses');
            while(my $expense = $expenses->next) {
                row {
                    cell {
                        form {
                            form_submit(
                                class => "expense record delete action",
                                as_link => 1,
                                label => "ⓧ",
                                tooltip => _("Delete this record"),
                                onclick => {
                                    confirm => _("Are you sure ?"),
                                    submit =>
                                        $expense->as_delete_action,
                                    refresh_self => 1
                                }
                            );
                        };
                    };
                    cell { $expense->happened_at };
                    cell { $expense->amount };
                    cell { $expense->currency };
                    cell { $expense->category };
                    cell { $expense->note };
                }
            }
        };
    };
};

template '/=/x/expenses/reports' => page {
    title => _("Expenses Reports")
} content {
    div {
        class is "expenseapp";

        h2 { _("All-time Summary") };
        div {
            class is "summary";
            my $sum = get("summary");
            table {
                row {
                    th { _("Category") };
                    th { _("Amount") };
                    th { _("Currency") };
                };
                for my $row (@$sum) {
                    row {
                        cell { $row->{category} };
                        cell { $row->{amount} };
                        cell { $row->{currency} };
                    }
                }
            };
        };

    };
};

1;
