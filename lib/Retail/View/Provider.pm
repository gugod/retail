package Retail::View::Provider;
use strict;
use base 'Retail::View::CRUD';
use Jifty::View::Declare -base;

use utf8;

use Retail::ViewHelpers;
use Jifty::ModelHelpers qw(Provider Supply SupplyCommodityCollection );

sub record_type { "Provider" }

template 'view' => sub {
    my $self   = shift;
    my $record = $self->_get_record( get('id') );

    my $update = $record->as_update_action(
        moniker => "update-" . Jifty->web->serial,
    );
    div {
        { class is 'crud read item inline' };

        my @fields = $self->display_columns($update);
        foreach my $field (@fields) {
            div {
                { class is 'view-argument-'.$field };

                render_param(
                    $update => $field,
                    render_mode => 'read'
                );
            };
        }
    };

    div {
        class is "controls";

        hyperlink(
            label =>  _("Supply from here"),
            url => "/provider/@{[ $record->id ]}/supply"
        );

        show ('./view_item_controls', $record, $update);
    }

    hr {};
};


template "supply" => page {
    my ($supply, $provider) = get qw(supply provider);

    title is _('Supply from %1', $provider->name);

    div {
        class is "controls";

        tangent(label => _("Manage Commodities"), url => "/commodity");

        form {
            render_action( $supply->as_delete_action);
            form_submit(
                label => _("Discard this supply ticket"),
                confirm => _("This supply ticket will be removed cannot be reverted. Are you sure ?")
            );
        };
    };

    div {
        class is "inline";

        form {
            my $action = new_action(class => "CreateSupplyCommodity");
            $action->argument_value(supply => $supply->id);

            render_action($action);
            form_submit(label => _("Add"));
        };
    };

    my $c = SupplyCommodityCollection;
    $c->limit(column => "supply", value  => $supply);

    table {
        class is "supply commodity list";

        row {
            cell { _("Name") };
            cell { _("Quantity") };
            cell { _("Price") };
            cell { _("SubTotal") };
        };
        while (my $item = $c->next) {
           row {
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
    };

};


1;
