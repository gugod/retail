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

    column supplies =>
        references Retail::Model::SupplyCommodityCollection by 'commodity';

};

sub before_create {
    my ($self, $args) = @_;
    if(defined($args->{pic})) {
        $args->{pic} = $self->pic_rescale($args->{pic});
    }
    return 1;
}

sub before_set_pic {
    my ($self, $params) = @_;
    $params->{value} = $self->pic_rescale($params->{value});
}

sub quantities_in_stock {
    my ($self) = @_;
    my $q = 0;
    my $supplies = $self->supplies;
    while (my $s = $supplies->next) {
        $q += $s->quantity;
    }

    return $q;
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

