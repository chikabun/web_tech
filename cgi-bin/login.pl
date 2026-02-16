#!/usr/bin/perl

use v5.30;
use CGI;
use Template;
use DBI;

my $q = CGI->new;
my $login = $q->param('login');
my $password = $q->param('password');

my $dbh = DBI->connect("DBI:mysql:database=webtech;host=localhost", "root", "root");

my $template = Template->new({ INCLUDE_PATH => 'templates' });
my $vars = {};

if (!$login && !$password) {  
    $vars->{login_message} = 'Enter login and password please';
}
else {
    my $sql = "SELECT * FROM users WHERE login=? AND password=?";
    my $sth = $dbh->prepare($sql);
    $sth->execute($login, $password);
    my $row = $sth->fetchrow_hashref();

    if ($row) {
        $vars->{login_message} = 'Hello, ' . $row->{firstname} . ' ' . $row->{lastname};

        # create session
        $dbh->do(
            sprintf "INSERT INTO sessions (created, user) VALUES (%s, %s)", time(), $row->{uid}
        ) or die $dbh->errstr;

        print $q->redirect("/cgi-bin/main.pl?userid=" . $row->{uid});

        exit;
    }
    else {
        $vars->{login_message} = 'Wrong login or password';
    }
}

print "Content-Type: text/html\n\n";
$template->process('login_page.html', $vars) || die $template->error();
