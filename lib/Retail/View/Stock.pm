package Retail::View::Stock;
use base 'Jifty::View::Declare';
use Jifty::View::Declare -base;
use strict;
use utf8;

use Retail::ViewHelpers;
use Jifty::ModelHelpers;

template 'index.html' => page {
    title is _("Stock");
    show("commodities");
};

template 'commodities' => sub {
    div {
        class is "stock commodities";

        my $c = CommodityCollection;
        table {
            class is "list";

            row {
                cell { _("Picture and Name") };
                cell { _("In stock") };
            };
            while (my $commodity = $c->next) {
                row {
                    cell {
                        outs_raw(image_to_commodity($commodity));
                        span { $commodity->name };
                    };
                    cell {
                        $commodity->quantities_in_stock || _("Stockless");
                    };
                };
            }
        }
    }
};
