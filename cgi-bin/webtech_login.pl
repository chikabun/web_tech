#!/usr/bin/perl

use v5.30;
use lib '.';

use CGI;

use db;
use markup;

my $q = CGI->new;
my $login = $q->param('login');
my $password = $q->param('password');
my $sid = $q->param('session_id');

my $vars = {
    sid => $sid,
    navigator => markup::getNavigator($sid),
};

if ($sid) {
    my $isSessionOK = db::isSessionOK($sid);
    if ($isSessionOK) {
        my $user = db::getUserBySessionId($sid);

        # reinit navagator
        $vars->{navigator} = markup::getNavigator($sid, $user);

        $vars->{username} = $user->{firstname} . ' ' . $user->{lastname};
    }
}

if (!$login && !$password) {  
    $vars->{login_message} = 'Enter login and password please';
}
else {
    my $row = db::getUserByLoginAndPassword($login, $password);

    if ($row) {
        $vars->{login_message} = 'Hello, ' . $row->{firstname} . ' ' . $row->{lastname};

        # create session
        my $sessionId = db::createSession($row->{uid});
        print $q->redirect("/cgi-bin/webtech_main.pl?session_id=" . $sessionId);
        exit;
    }
    else {
        $vars->{login_message} = 'Wrong login or password';
    }
}

markup::createPage('login_page.html', $vars);
