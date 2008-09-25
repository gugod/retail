package Retail::View::Commodity;
use strict;
use base 'Retail::View::CRUD';
use Jifty::View::Declare -base;

use utf8;

use Retail::ViewHelpers;
use JiftyX::ModelHelpers;

sub record_type { "Commodity" }

template 'view_stock_numbers' => sub {
    my $self = shift;
    my $id = get('id');
    my $record = $self->_get_record($id);

    with(class => "label"), h5 { _("Provider / Stock Number"); };
    my $c = ProviderCommodityCollection(commodity => $id);
    if ($c->count > 0) {
        while (my $r = $c->next) {
            div {
                with(class => "provider name"), span { $r->provider->name };
                outs " : ";
                with(class => "stock_number"), span { $r->stock_number };
                hyperlink(
                    label => _("ⓧ"),
                    onclick => {
                        confirm => _("Are you sure ?"),
                        submit => $r->as_delete_action,
                        refresh_self => 1,
                        args => { id => $id }
                    }
                );
            };
        }
    }
    else {
        my $action = new_action( class => "CreateProviderCommodity");
        $action->hidden( commodity => $record->id );
        $action->argument_value(commodity => $record->id );
        div {
            render_action($action);
            hyperlink(
                label => _("Add"),
                onclick => {
                    submit => $action,
                    refresh_self => 1,
                    args => { id => $id }
                },
            );
        };
    }
};

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
                { class is 'view-argument view-argument-'.$field };

                render_param(
                    $update => $field,
                    render_mode => 'read'
                );
            };
        }

    };

    div {
        { class is "controls" };

        show ('./view_item_controls', $record, $update);
    };

    div {
        { class is 'view-argument stock-number' };
        render_region(
            name => "stock_numbers_for_" . $record->id,
            path => "/commodity/view_stock_numbers",
            args => { id => $record->id }
        );
    }

    hr {};

};

private template view_item_controls  => sub {
    my $self = shift;
    my $record = shift;

    div {
        class is "commodity pic";
        img {
            src is commodity_pic_path($record)
        };
    };

    div {
        class is "quantities";
        h6 { _("In Stock") };
        span {
            outs($record->quantities_in_stock || _("Stockless"));
        };
    };

    if ( $record->current_user_can('update') ) {
        div {

            hyperlink(
                label   => _("Edit"),
                class   => "editlink",
                onclick => {
                    replace_with => $self->fragment_for('update'),
                    args         => { id => $record->id }
                },
            );
        }

    }

};

template "pic" => sub {
    my $id = get("id");
    my $record = Commodity($id);
    Jifty->handler->apache->content_type("image/png");

    if($record->pic) {
        Jifty->log->info("With pic");
        outs_raw($record->pic);
        return;
    }

    Jifty->log->info("No pic. Use blank.png");
    my $file = Jifty::Util->absolute_path("share/web/static/images/blank.png");
    Jifty->log->info("File: $file");
    my $img;
    open(IMG, "<:raw", $file);
    read(IMG, $img, 5000);
    outs_raw($img);
    close(IMG);
};

template 'update' => sub {
    my $self = shift;
    my ( $object_type, $id ) = ( $self->object_type, get('id') );

    my $record_class = $self->record_class;
    my $record = $record_class->new();
    $record->load($id);
    my $update = $record->as_update_action(
        moniker => "update-" . Jifty->web->serial,
    );

    div {
        { class is "crud update item inline " . $object_type }

        show('./edit_item', $update);

        show('./edit_item_controls', $record, $update);

        hr {};
    };

};


1;
