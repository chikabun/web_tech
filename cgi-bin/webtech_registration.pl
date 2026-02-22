#!/usr/bin/perl

use v5.30;
use lib '.';

use CGI;

use db;
use markup;

my $q = CGI->new;
my $sid = $q->param('session_id');
my $login = $q->param('login');
my $password = $q->param('password');
my $email = $q->param('email');
my $firstname = $q->param('firstname');
my $lastname = $q->param('lastname');
my $position = $q->param('position');
my $isSubmit = $q->param('submit_button');

my $vars = {
    sid => $sid,
    navigator => markup::getNavigator($sid),
};

if ($sid) {
    my $isSessionOK = db::isSessionOK($sid);
    if ($isSessionOK) {
        my $user = db::getUserBySessionId($sid);
        $vars->{username} = $user->{firstname} . ' ' . $user->{lastname};
    }
}

if ($isSubmit) {
    if ($login && $password && $email && $firstname && $lastname && $position) {

        my $isOK = db::createUser({
            login => $login,
            password => $password,
            email => $email,
            firstname => $firstname,
            lastname => $lastname,
            position => $position,
        });

        if ($isOK) {
            my $row = db::getUserByLoginAndPassword($login, $password);
            if ($row) {
                my $sessionId = db::createSession($row->{uid});
                print $q->redirect("/cgi-bin/webtech_main.pl?session_id=" . $sessionId);
                exit;
            }
        }
        
        $vars->{registration_message} = 'A user has not been created';    
    }
    else {
        $vars->{registration_message} = 'All registration fields should be defined';
    }
}
else {
    $vars->{registration_message} = 'Define all values please';
}

markup::createPage('registration_page.html', $vars);
