package Retail::View;
use strict;
use warnings;
use utf8;
use Jifty::View::Declare -base;
use Jifty::View::Declare::CRUD;

use Retail::ViewHelpers;
use Retail::View::Stock;

Jifty::View::Declare::CRUD->mount_view("Provider");
Jifty::View::Declare::CRUD->mount_view("Commodity");
Jifty::View::Declare::CRUD->mount_view("Consumer");

alias Retail::View::Stock under "/stock";

# For some reason 'use JiftyX::ModelHelpers' break the alias statement above.
require JiftyX::ModelHelpers;
JiftyX::ModelHelpers->import();

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

template '/supply' => page { title => _("Supply") } content {
    h3 { _("Please choose a provider.") };

    form {
        render_region(
            name     => "provider-list",
            path     => "/provider/list"
        );
    };
};

template '/supply/list' => page {
    my $c = SupplyCollection(draft => 0);
    ul {
        while (my $supply = $c->next) {
            li {
                span {
                    outs($supply->id);
                };
                span {
                    outs($supply->provider->name);
                };
            };
        }
    }
};

template '/sale' => page {
    title is _("Sale");
    h3 { _("Please choose a consumer.") };
    show("/consumer/list");
};


1;
