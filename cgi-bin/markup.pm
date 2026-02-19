package markup;

sub getNavigator {
    $uid = shift;

    my @links = (
        '<a href="/cgi-bin/webtech_welcome.pl?uid=' . $uid . '">Welcome</a>',
        '<a href="/cgi-bin/webtech_login.pl?uid=' . $uid . '">Login</a>',
        '<a href="/cgi-bin/webtech_registration.pl?uid=' . $uid . '">Registration</a>',
    );

    if ($uid) {
        push @links, '<a href="/cgi-bin/webtech_my_account.pl?uid=' . $uid . '">My Account</a>';
        push @links, '<a href="/cgi-bin/webtech_main.pl?uid=' . $uid . '">Main</a>';
        push @links, '<a href="/cgi-bin/webtech_logout.pl?uid=' . $uid . '">Logout</a>';
    }

    return join("&nbsp;|&nbsp;", @links);
}

1;