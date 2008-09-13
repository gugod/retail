package Retail::View::Commodity;
use strict;
use base 'Retail::View::CRUD';
use Jifty::View::Declare -base;

use utf8;

use Retail::ViewHelpers;
use JiftyX::ModelHelpers;

sub record_type { "Commodity" }

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
        { class is "controls" };

        show ('./view_item_controls', $record, $update);
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
    outs_raw($record->pic);
};

1;
