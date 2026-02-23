#!/usr/bin/perl

use v5.30;
use lib '.';

use CGI;
use Data::Dumper;

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

        my $user = db::getUserBySessionId($sid);

        # do main work, if a PDF creation required
        if ($isCreatePDF) {
            pdf::createPDF($t, $user->{uid});
            db::createTask($user->{uid}, $t);
        }

        # display main page
        my $user = db::getUserBySessionId($sid);
        $vars->{username} = $user->{firstname} . ' ' . $user->{lastname};

        my $tasks = db::getAllTasksForUser($user->{uid});
        my $ctr = 1;
        for my $task (@{$tasks}) {
            $task->{position} = $ctr;
            $task->{created} = localtime($task->{created});
            $ctr++;
        }
        $vars->{tasks} = $tasks;
        markup::createPage('main_page.html', $vars);

        exit;
    }
}

markup::createPage('empty_page.html', $vars);
