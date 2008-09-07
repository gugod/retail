use strict;
use warnings;

package Retail::Model::Commodity;
use Jifty::DBI::Schema;

use Retail::Record schema {
    column name =>
        label is _("Name"),
        type is 'varchar(255)';

    column pic =>
        label is _("Picture"),
        type is "blob",
        render as "Upload";

    column supplies =>
        type is 'integer',
        references Retail::Model::SupplyCommodityCollection by 'commodity';

    column sales =>
        type is 'integer',
        references Retail::Model::SaleCommodityCollection by 'commodity';
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

sub nondraft_supplies {
    my ($self) = @_;
    my $supplies = $self->supplies;

    # I always need to guess how to join and limit in Jifty::DBI::Collection. :(
    my $a = $supplies->join(
        type => "left",
        column1 => "supply",
        table2 => "supplies",
        column2 => "id"
    );
    $supplies->limit(
        alias => $a,
        column => "draft",
        value => 0
    );

    return $supplies;
}

sub nondraft_sales {
    my ($self) = @_;
    my $s = $self->sales;

    my $a = $s->join(
        type => "left",
        column1 => "sale",
        table2 => "sales",
        column2 => "id"
    );
    $s->limit(
        alias => $a,
        column => "draft",
        value => 0
    );

    return $s;
}

sub quantities_in_stock {
    my ($self) = @_;
    my $q = 0;
    my $supplies = $self->nondraft_supplies;

    while (my $s = $supplies->next) {
        $q += $s->quantity;
    }

    my $sales = $self->nondraft_sales;
    while (my $s = $sales->next) {
        $q -= $s->quantity;
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

