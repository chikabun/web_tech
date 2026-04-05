#!/usr/bin/perl

use v5.30;
use lib '.';

use CGI;

use db;
use markup;

my $q = CGI->new;
my $sid = $q->param('session_id');
my $tid = $q->param('tid');

if ($sid && $tid) {
    my $isSessionOK = db::isSessionOK($sid);

    if ($isSessionOK) {

        my $user = db::getUserBySessionId($sid);

        if ($user->{login} eq 'admin') {
            db::approveTask($tid);
            print $q->redirect("/cgi-bin/webtech_admin.pl?session_id=" . $sid);
            exit;
        }
    }
}

markup::createPage('empty_page.html', {});
