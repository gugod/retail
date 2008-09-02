package Retail::View;
use strict;
use warnings;
use utf8;
use Jifty::View::Declare -base;
use Jifty::View::Declare::CRUD;

use Retail::ViewHelpers;

use Retail::View::Provider;

use Retail::View::Stock;

Jifty::View::Declare::CRUD->mount_view("Provider");
Jifty::View::Declare::CRUD->mount_view("Commodity");

alias Retail::View::Stock under "/stock";

template '/' => page {
    div {
        class is "buttons";

        ul {
            for (qw(supply sale stock)) {
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

template 'sale' => page {
    title is _("Sale");
};

1;
