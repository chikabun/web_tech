package markup;

sub getNavigator {
    $uid = shift;

    my @links = (
        '<a href="/cgi-bin/webtech_welcome.pl?uid=' . $uid . '">WELCOME</a>',
        '<a href="/cgi-bin/webtech_login.pl?uid=' . $uid . '">LOGIN</a>',
        # '<a href="/cgi-bin/webtech_registration.pl?uid=' . $uid . '">REGISTRATION</a>',
    );

    if ($uid) {
        push @links, '<a href="/cgi-bin/webtech_main.pl?uid=' . $uid . '">MAIN</a>';
        push @links, '<a href="/cgi-bin/webtech_logout.pl?uid=' . $uid . '">LOGOUT</a>';
    }

    return join("&nbsp;|&nbsp;", @links);
}

1;