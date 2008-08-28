package Retail::View;
use strict;
use warnings;
use utf8;
use Jifty::View::Declare -base;

template '/' => page {
    div {
        class is "buttons";

        ul {
            for (qw(buy sale stock)) {
                li {
                    hyperlink(
                        url => "/$_",
                        label => _( ucfirst($_) ),
                        class => "huge button"
                    );
                };
            }
        }
    }
};

template '/buy' => page {
    title is _("Buy");
};

template '/sale' => page {
    title is _("Sale");
};

template '/stock' => page {
    title is _("Stock");

};

