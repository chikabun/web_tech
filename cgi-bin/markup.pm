package markup;

use Template;

sub getNavigator {
    $id = shift;

    my @links = (
        '<a href="/cgi-bin/webtech_welcome.pl?session_id=' . $id . '">Welcome</a>',
        '<a href="/cgi-bin/webtech_login.pl?session_id=' . $id . '">Login</a>',
        '<a href="/cgi-bin/webtech_registration.pl?session_id=' . $id . '">Registration</a>',
    );

    if ($id) {
        push @links, '<a href="/cgi-bin/webtech_my_account.pl?session_id=' . $id . '">My Account</a>';
        push @links, '<a href="/cgi-bin/webtech_main.pl?session_id=' . $id . '">Main</a>';
        push @links, '<a href="/cgi-bin/webtech_logout.pl?session_id=' . $id . '">Logout</a>';
    }

    return join("&nbsp;|&nbsp;", @links);
}

sub createPage {
    my $tname = shift;
    my $vars = shift;

    my $template = Template->new({ INCLUDE_PATH => 'templates' });
    print "Content-Type: text/html\n\n";
    $template->process($tname, $vars) || die $template->error();
}

1;