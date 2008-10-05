package Retail;

sub start {
    Jifty->web->add_javascript("ext-all.js");
    Jifty->web->add_css("ext-all.css");
}

1;
