package Retail::ViewHelpers;

use strict;
use warnings;
use utf8;
use Exporter::Lite;

our @EXPORT = qw(supply_from_provider_path image_to_commodity commodity_pic_path);

sub supply_from_provider_path {
    my ($provider) = @_;
    return "/provider/" . (ref($provider) ? $provider->id : $provider) . "/supply";
}

sub commodity_pic_path {
    my ($record) = @_;
    return "/commodity/id/" . $record->id . "/pic";
}

sub image_to_commodity {
    my ($record) = @_;
    return "<img src=\"@{[ commodity_pic_path($record) ]}\" alt=\"commodity picture for @{[ $record->name ]}\">";
}

1;
