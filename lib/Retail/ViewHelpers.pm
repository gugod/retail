package Retail::ViewHelpers;

use strict;
use warnings;
use utf8;
use Exporter::Lite;

our @EXPORT = qw(buy_from_provider_path);

sub buy_from_provider_path {
    my ($provider) = @_;
    return "/provider/" . (ref($provider) ? $provider->id : $provider) . "/buy";
}

1;
