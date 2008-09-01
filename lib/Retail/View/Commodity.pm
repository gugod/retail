package Retail::View::Commodity;
use strict;
use base 'Retail::View::CRUD';
use Jifty::View::Declare -base;

use utf8;

use Retail::ViewHelpers;
use Jifty::ModelHelpers;

sub record_type { "Commodity" }

template 'view' => sub {
    my $self   = shift;
    my $record = $self->_get_record( get('id') );

    my $update = $record->as_update_action(
        moniker => "update-" . Jifty->web->serial,
    );
    div {
        class is "commodity pic";
        img {
            src is commodity_pic_path($record)
        };
    }

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
        show ('./view_item_controls', $record, $update);
    }

    hr {};

};

use Imager;

template "pic" => sub {
    my $id = get("id");
    my $record = Commodity($id);


    my $img = Imager->new();
    $img->read(data => $record->pic);

    my $data;
    $img->scale(xpixels => 80, ypixels => 80)->write(type => "png", data => \$data);

    Jifty->handler->apache->content_type("image/png");
    outs_raw($data);
};

1;
