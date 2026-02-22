#!/usr/bin/perl

use v5.30;
use lib '.';

use CGI;

use db;
use markup;
use pdf;

my $q = CGI->new;
my $sid = $q->param('session_id');
my $isCreatePDF = $q->param('create_pdf');
my $t = $q->param('txt');

my $vars = {
    sid => $sid,
    navigator => markup::getNavigator($sid),
};

if ($sid) {
    my $isSessionOK = db::isSessionOK($sid);

    if ($isSessionOK) {

        # main work
        if ($isCreatePDF) {
            pdf::createPDF($t);
        }

        my $user = db::getUserBySessionId($sid);

        $vars->{username} = $user->{firstname} . ' ' . $user->{lastname};

        markup::createPage('main_page.html', $vars);

        exit;
    }
}

markup::createPage('empty_page.html', $vars);
