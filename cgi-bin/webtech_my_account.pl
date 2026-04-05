#!/usr/bin/perl

use v5.30;
use lib '.';

use CGI;

use db;
use markup;

my $q = CGI->new;
my $sid = $q->param('session_id');

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

        if ($isSubmit) {

            my $uid = db::getUserIdBySessionId($sid);

            db::updateUser({
                uid => $uid,

                password => $password,
                email => $email,
                firstname => $firstname,
                lastname => $lastname,
                position => $position,
            });
        }

        my $user = db::getUserBySessionId($sid);

        # reinit navagator
        $vars->{navigator} = markup::getNavigator($sid, $user);

        $vars->{username} = $user->{firstname} . ' ' . $user->{lastname};

        $vars->{login} = $user->{login};
        $vars->{firstname} = $user->{firstname};
        $vars->{lastname} = $user->{lastname};
        $vars->{email} = $user->{email};
        $vars->{position} = $user->{position};

        markup::createPage('my_account_page.html', $vars);
        
        exit;
    }
}

markup::createPage('empty_page.html', $vars);
