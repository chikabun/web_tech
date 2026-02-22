#!/usr/bin/perl

use v5.30;
use lib '.';

use CGI;

use db;

my $q = CGI->new;
my $sid = $q->param('session_id');

if ($sid) {
    db::dropSession($sid);
}

print $q->redirect("/cgi-bin/webtech_login.pl");
