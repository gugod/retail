use strict;
use warnings;

package Retail::Action::CreateCommodity;
use base qw/Retail::Action::Record::Create/;

sub record_class { 'Retail::Model::Commodity' }

use Jifty::Param::Schema;
use Jifty::Action schema {
    param provider =>
        order is 100,
        type is 'select',
        label is _("Provider"),
        valid_values are defer {
            my @ret = ({ display => "-", value => undef });

            my $c = Jifty->app_class(Model => "ProviderCollection")->new;
            $c->unlimit;

            while(my $p = $c->next) {
                push @ret, {
                    display => $p->name,
                    value => $p->id
                }
            }
            \@ret;
        };

    param stock_number =>
        order is 101,
        type is 'Text',
        label is _("Stock number");
};

1;
