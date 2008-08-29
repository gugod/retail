package Retail::View;
use strict;
use warnings;
use utf8;
use Jifty::View::Declare -base;
use Jifty::View::Declare::CRUD;

sub M {
    Jifty->app_class(Model => $_[0])->new
}

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

    div {
        class is "providers";

        my $pc = Jifty->app_class(Model => "ProviderCollection")->new;
        $pc->unlimit;

        ul {
            while (my $p = $pc->next) {
                li {
                    hyperlink(
                        url => "/buy/providers/" . $p->id,
                        label => $p->name
                    );
                }
            }
        }
    };

    hyperlink(
        url => "/providers",
        label => _("Add new providers")
    );
};

template '/sale' => page {
    title is _("Sale");
};

template '/stock' => page {
    title is _("Stock");

};

template "/buy/providers" => page {
    my $provider = get("provider");
    title is _('Buy from %1', $provider->name);

    hyperlink(label => "Commodities",  url => "/commodities");

};

alias Jifty::View::Declare::CRUD under "/providers", {
    object_type => "Provider"
};

alias Jifty::View::Declare::CRUD under "/commodities", {
    object_type => "Commodity"
};
