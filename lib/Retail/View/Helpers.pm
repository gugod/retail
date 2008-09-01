package Retail::View::Helpers;

sub buy_from_provider_path {
    my ($provider) = @_;
    return "/buy/provider/" . ref($provider) ? $provider->id : $provider;
)

1;
