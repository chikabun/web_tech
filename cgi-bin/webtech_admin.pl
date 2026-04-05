#!/usr/bin/perl

use v5.30;
use lib '.';

use CGI;

use db;
use markup;

my $q = CGI->new;
my $sid = $q->param('session_id');

my $vars = {
    sid => $sid,
    navigator => markup::getNavigator($sid),
};

if ($sid) {
    my $isSessionOK = db::isSessionOK($sid);
    if ($isSessionOK) {
        my $user = db::getUserBySessionId($sid);
        
        if ($user->{login} ne 'admin') {
            markup::createPage('empty_page.html', $vars);
            exit;
        }

        # reinit navagator
        $vars->{navigator} = markup::getNavigator($sid, $user);

        # display admin page
        my $user = db::getUserBySessionId($sid);
        $vars->{username} = $user->{firstname} . ' ' . $user->{lastname};

        my $tasks = db::getAllTasks();
        my $ctr = 1;
        for my $task (@{$tasks}) {
            $task->{position} = $ctr;
            $task->{created} = localtime($task->{created});
            if (! $task->{ready}) {
                $task->{approve} = sprintf '/cgi-bin/webtech_approve.pl?session_id=%s&tid=%s', $sid, $task->{tid};
            }
            $ctr++;
        }
        $vars->{tasks} = $tasks;
        markup::createPage('admin_page.html', $vars);

        exit;
    }

        
}

markup::createPage('empty_page.html', $vars);
