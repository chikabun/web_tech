#!/usr/bin/perl

use v5.30;
use lib '.';

use CGI;
use Template;

use db;
use markup;

my $q = CGI->new;
my $uid = $q->param('uid');
# my $login = $q->param('login');
my $password = $q->param('password');
my $email = $q->param('email');
my $firstname = $q->param('firstname');
my $lastname = $q->param('lastname');
my $position = $q->param('position');
my $isSubmit = $q->param('submit_button');

my $template = Template->new({ INCLUDE_PATH => 'templates' });
my $vars = {
    uid => $uid,
    navigator => markup::getNavigator($uid),
};

if ($uid) {
    my $isSessionOK = db::isSessionOK($uid);

    if ($isSessionOK) {

        if ($isSubmit) {
            db::updateUser({
                uid => $uid,
                password => $password,
                email => $email,
                firstname => $firstname,
                lastname => $lastname,
                position => $position,
            });
        }

        my $user = db::getUser($uid);

        $vars->{username} = $user->{firstname} . ' ' . $user->{lastname};

        $vars->{login} = $user->{login};
        $vars->{firstname} = $user->{firstname};
        $vars->{lastname} = $user->{lastname};
        $vars->{email} = $user->{email};
        $vars->{position} = $user->{position};

        print "Content-Type: text/html\n\n";
        $template->process('my_account_page.html', $vars) || die $template->error();

        exit;
    }
}

print "Content-Type: text/html\n\n";
$template->process('empty_page.html', $vars) || die $template->error();    

