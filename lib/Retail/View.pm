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

alias Jifty::View::Declare::CRUD under "/provider_commodity", {
    object_type => "ProviderCommodity"
};

alias Retail::View::Stock under "/stock";

# For some reason 'use JiftyX::ModelHelpers' break alias statements
unless (__PACKAGE__->can("Commodity")) {
    require JiftyX::ModelHelpers;
    JiftyX::ModelHelpers->import();
}

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

template '/supply/history' => page {
    title => _("Supply History")
} content {

    my $c = SupplyCollection(draft => 0);
    div {
        { class is "supply history" };

        ul {
            while (my $supply = $c->next) {
                li {
                    hyperlink(
                        url => "/supply/" . $supply->id,
                        label => _(
                            'Ticket number %1, supply from %2',
                            $supply->id,
                            $supply->provider->name
                        )
                    );
                };
            }
        };
    };
};

template '/supply/view' => page {
    my $record = get("supply");
    with(class => "supply view"), table {
        my $commodities = $record->commodities;
        row {
            cell { _("Name") };
            cell { _("Quantity") };
            cell { _("Price") };
            cell { _("Retail Price") };
            cell { _("Currency") };
        };

        while(my $r = $commodities->next) {
            with(class => "supply commodity view"), row {
                cell { $r->commodity->name };
                cell { $r->quantity };
                cell { $r->price };
                cell { $r->retail_price };
                cell { $r->currency };
            };
        }
        my %summary = $record->summary;
        for(sort keys %summary) {
            with(class => "summary"), row {
                with(colspan => 4, class => "key"), cell { _($_) };
                with(class => "value"), cell { $summary{$_} };
            };
        }
    };
};

template '/sale' => page { title => _("Sale") } content {
    h3 { _("Please choose a consumer.") };
    form {
        render_region(
            name     => "consumer-list",
            path     => "/consumer/list"
        );
    };
};

private template 'menu' => sub {
    outs_raw(Jifty->web->navigation->render_as_yui_menubar);
};


1;
