package markup;

use strict;

use Template;
use FindBin qw($RealBin);

sub getNavigator {
    my $id = shift;
    my $user = shift;

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

    if ($user->{login} eq 'admin') {
        push @links, '<a href="/cgi-bin/webtech_admin.pl?session_id=' . $id . '">Admin</a>';
    }


    my $res = "<ul>";
    $res .= join("", map { "<li>" . $_ . "</li>" } @links);
    $res .= "</ul>";

    return $res;
}

sub createPage {
    my $tname = shift;
    my $vars = shift;

    my $template = Template->new({ INCLUDE_PATH => 'templates' });
    print "Content-Type: text/html\n\n";
    $template->process($tname, $vars) || die $template->error();
}

sub returnPDF {
    my $uid = shift;
    my $basename = shift;

    print "Content-Type: application/pdf\n\n";
    my $filename = $RealBin . '/pdfs/' . $uid . '/' . $basename;
    open my $PDF, '<', $filename or die $filename;
    while (my $line = <$PDF>) {
        print $line;
    }
    close $PDF;
}

1;