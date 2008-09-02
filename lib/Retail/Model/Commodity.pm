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

use Imager;

sub before_set_pic {
    my ($self, $params) = @_;

    my $img = Imager->new();
    if ($img->read(data => $params->{value})) {
        my $data;
        $img->scale(xpixels => 80, ypixels => 80, type => 'min')->write(type => "png", data => \$data);
        $params->{value} = $data;

        return 1;
    }
}

sub quantities_in_stock {
    my ($self) = @_;

    # XXX
    return 1;
}

1;

