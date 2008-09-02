use strict;
use warnings;

package Retail::Model::Commodity;
use Jifty::DBI::Schema;

use Retail::Record schema {
    column name =>
        type is 'varchar(255)';

    column pic =>
        type is "blob",
        render as "Upload";
};

sub before_create {
    
}

sub before_set_pic {
    my ($self, $params) = @_;
    $params->{value} = $self->pic_rescale($params->{value});
}

sub quantities_in_stock {
    my ($self) = @_;

    # XXX
    return 1;
}

use Imager;

sub pic_rescale {
    my ($self, $data) = @_;
    my $img = Imager->new();
    if ($img->read(data => $data)) {
        $img->scale(xpixels => 80, ypixels => 80, type => 'min')->write(type => "png", data => \$data);
    }
    else {
        $img = Imager->new(xsize => 80, ysize => 80);
        $img->flood_fill(x => 1, y => 1, color => "grey");
        $img->write(type => "png", data => \$data);
    }
    return $data;
}

1;

