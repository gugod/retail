package Retail::View::CRUD;
use strict;
use base 'Jifty::View::Declare::CRUD';
use Jifty::View::Declare -base;
use utf8;

template 'list' => sub {
    my $self = shift;
    my ( $page ) = get('page');
    my $item_path = get('item_path') || $self->fragment_for("view");
    my $collection =  $self->_current_collection();

    div {
        {class is 'crud-'.$self->object_type}; 
        show( './search_region' );
        show( './new_item_region');
        show( './paging_top',    $collection, $page );
        show( './list_items',    $collection, $item_path );
        show( './paging_bottom', $collection, $page );
    };
};

template 'new_item' => sub {
    my $self = shift;
    my ( $object_type ) = ( $self->object_type );

    my $record_class = $self->record_class;
    my $create = $record_class->as_create_action;

    div {
        { class is 'crud create item inline' };
        show('./create_item', $create);
        show('./new_item_controls', $create);
    };
    hr {};
};

1;
