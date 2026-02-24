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
        my $basename = db::getPDFFilename($user->{uid}, $tid);
        if ($basename) {
            $basename = $basename . '.pdf';
            markup::returnPDF($user->{uid}, $basename);
        }
    }
}

markup::createPage('empty_page.html', {});
