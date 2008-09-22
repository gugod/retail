package Retail::View::Consumer;

use strict;
use base 'Retail::View::CRUD';
use Jifty::View::Declare -base;

use utf8;

use Retail::ViewHelpers;
use JiftyX::ModelHelpers;

sub record_type { "Consumer" }

template 'sale' => page {
    my ($consumer, $sale) = get qw(consumer sale);
    title is _('Sell to %1', $consumer->name);

    div {
        { class is "sale update" };

        h3 { outs _("Update This Sale Ticket."); };
        form {
            my $action = $sale->as_update_action;
            $action->hidden(draft => 1);
            $action->hidden(consumer => $sale->consumer->id);

            render_action($action);

            form_submit( label => _("Save" ) );
        };

        div {
            {class is "finish"};
            form {
                my $action = $sale->as_update_action;
                $action->hidden(draft => 0);
                $action->hidden('consumer');
                $action->hidden('happened_on');

                render_action($action);
                form_next_page(url => "/");
                form_submit(
                    label => _("Done"),
                    onclick => {
                        confirm => _("Save this ticket will make it not-editable. Are you sure ?")
                    }
                );
            };
        };


        div {
            {class is "discard"};
            form {
                render_action($sale->as_delete_action);
                form_submit(
                    label => _("Discard"),
                    onclick => {
                        confirm => _("This sale ticket will be removed cannot be reverted. Are you sure ?")
                    }
                );
            };
        };
    };

    div {
        class is "inline crud create item";

        form {
            my $action = new_action(class => "CreateSaleCommodity");
            $action->hidden(sale => $sale->id);
            render_action($action);
            form_submit( label => _("Add") );
        };

    };
    table {
        { class is "list" };

        my $c = SaleCommodityCollection;
        $c->limit(column => "sale", value  => $sale);

        row {
            cell { _("Delete") };
            cell { _("Name") };
            cell { _("Quantity") };
            cell { _("Price") };
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
                   };
               };
               cell {
                   outs_raw image_to_commodity($item->commodity);

                   span {
                       class is "commodity name";
                       $item->commodity->name
                   };
               };
               cell { $item->quantity };
               cell { $item->price . " " . $item->currency };
               cell { ($item->quantity * $item->price) . " " . $item->currency };
           };
       }
    }
};

private template view_item_controls  => sub {
    my $self = shift;
    my $record = shift;

    ul {
        li {
            hyperlink(
                label => _('Sell to %1', $record->name),
                url => "/consumer/@{[ $record->id ]}/sale"
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
