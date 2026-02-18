#!/usr/bin/perl

use v5.30;
use lib '.';

use CGI;

use db;

my $q = CGI->new;
my $uid = $q->param('uid');

if ($uid) {
    db::dropSession($uid);
}

print $q->redirect("/cgi-bin/webtech_welcome.pl");
