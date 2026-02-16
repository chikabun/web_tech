#!/usr/bin/perl

use v5.30;
use CGI;
use Template;
use DBI;

my $q = CGI->new;
my $userid = $q->param('userid');

my $dbh = DBI->connect("DBI:mysql:database=webtech;host=localhost", "root", "root");

my $template = Template->new({ INCLUDE_PATH => 'templates' });
my $vars = {};

if ($userid) {
    my $sql = "SELECT * FROM sessions WHERE user=?";
    my $sth = $dbh->prepare($sql);
    $sth->execute($userid);

    my $now = time();
    my $isSessionOK = 0;
    while (my $row = $sth->fetchrow_hashref()) {
        if ($now - $row->{created} < 3600) {
            $isSessionOK = 1;
            last;
        }
    }

    if ($isSessionOK) {
        print "Content-Type: text/html\n\n";
        $template->process('main_page.html', $vars) || die $template->error();

        exit;
    }
}

print "Content-Type: text/html\n\n";
$template->process('empty_page.html', $vars) || die $template->error();    

