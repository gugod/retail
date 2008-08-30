package Jifty::ModelHelpers;
use strict;
use Exporter;

our @ISA = qw(Exporter);
our @EXPORT;
our $VERSION = "0.01";

{
    require Jifty::Schema;
    my @models = map { s/.*::(.+)$/$1/;  $_; } Jifty::Schema->new->models;

    no strict 'refs';
    for my $model (@models) {
        if ( index($model, "Collection") >= 0) {
            *{"$model"} = sub {
                my @args = @_;
                my $obj = Jifty->app_class(Model => "$model")->new;
                if (@args == 0) {
                    $obj->unlimit;
                }
                elsif (@args % 2 == 0) {
                }
                return $obj;
            }
        }
        else {
            *{"$model"} = sub {
                my @args = @_;
                my $obj = Jifty->app_class(Model => "$model")->new;
                if (@args == 1) {
                    $obj->load($args[0]);
                }
                if (@args % 2 == 0) {
                    $obj->load_from_cols($args[0]);
                }
                return $obj;
            };
        }
        push @EXPORT, "&${model}";
    }
}

1;
