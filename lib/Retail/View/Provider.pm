package Retail::View::Provider;
use strict;
use base 'Retail::View::CRUD';
use Jifty::View::Declare -base;

use utf8;

use Retail::ViewHelpers;
use JiftyX::ModelHelpers qw(Provider Supply SupplyCommodityCollection );

sub record_type { "Provider" }

template "supply" => page {
    my ($supply, $provider) = get qw(supply provider);

    { title is _('Supply from %1', $provider->name) };

    div {
        { class is "supply controls" };
        div {
            { class is "finish" };
            form {
                my $action = $supply->as_update_action;
                $action->hidden(draft => 0);
                $action->hidden('happened_on' => $supply->happened_on);
                $action->hidden('tax_rate'    => $supply->tax_rate);
                $action->hidden(provider => $supply->provider->id);

                render_action($action);
                form_next_page(url => "/supply/history");
                form_submit(
                    label => _("Finish"),
                    onclick => {
                        confirm => _("Save this ticket will make it not-editable again. Are you sure ?")
                    }
                );
            };
        };

        div {
            { class is "discard" };
            form {
                render_action($supply->as_delete_action);
                form_submit(
                    label => _("Discard"),
                    onclick => {
                        confirm => _("This supply ticket will be removed cannot be reverted. Are you sure ?")
                    }
                );
            };
        };
    };

    div {
        { class is "supply update" };

        h3 { outs _("Update This Supply Ticket."); };
        form {
            my $action = $supply->as_update_action;
            $action->hidden(draft => 1);
            $action->hidden(provider => $supply->provider->id);

            render_action($action);

            form_submit( label => _("Save" ) );
        };

    };

    with(class => "clearfix"), div { " " };

    div {
        { class is "inline crud create item" };

        form {
            my $action = new_action(class => "CreateSupplyCommodity");
            $action->hidden(supply => $supply->id);

            render_action($action);
            form_submit(label => _("Add"));
        };
    };

    my $c = SupplyCommodityCollection;
    $c->limit(column => "supply", value  => $supply);

    table {
        class is "supply commodity list";

        row {
            cell { _("Delete?") };
            cell { _("Name") };
            cell { _("Quantity") };
            cell { _("Price") };
            cell { _("Retail Price") };
            cell { _("SubTotal") };
        };
        while (my $item = $c->next) {
            row {
                cell {
                    { class is "controls" };

                    form {
                        render_action($item->as_delete_action);
                        form_submit(
                            label => _("Delete"),
                            onclick => {
                                confirm => _("Are you sure ?")
                            }
                        );
                    }
                };
                cell {
                    outs_raw image_to_commodity($item->commodity);

                    span {
                        { class is "commodity name" };

                        $item->commodity->name
                    };
                };
                cell { $item->quantity };
                cell { $item->price . " " . $item->currency ; };
                cell { $item->retail_price . " " . $item->currency; };
                cell { ($item->quantity * $item->price) . " " . $item->currency };
            };
        }

        my %summary = $supply->summary;
        for (sort keys %summary) {
            with(class => "summary"), row {
                cell { " " };
                with(colspan => 4, class => "key"), cell { _($_) };
                with(class => "value"), cell { $summary{$_} };
            };
        }
    };
};

private template view_item_controls  => sub {
    my $self = shift;
    my $record = shift;

    ul {
        li {
            hyperlink(
                label => _("Supply from here"),
                url => "/provider/@{[ $record->id ]}/supply"
            );
        };

        if ( $record->current_user_can('update') ) {
            li {
                hyperlink(
                    label   => _("Edit"),
                    class   => "editlink",
                    onclick => {
                        replace_with => $self->fragment_for('update'),
                        args         => { id => $record->id }
                    },
                );
            };
        }
    }
};

1;
