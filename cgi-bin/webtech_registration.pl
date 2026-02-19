#!/usr/bin/perl

use v5.30;
use lib '.';

use CGI;
use Template;

use db;
use markup;

my $q = CGI->new;
my $uid = $q->param('uid');
my $login = $q->param('login');
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
        my $user = db::getUser($uid);
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
                db::createSession($row->{uid});
                print $q->redirect("/cgi-bin/webtech_main.pl?uid=" . $row->{uid});
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

print "Content-Type: text/html\n\n";
$template->process('registration_page.html', $vars) || die $template->error();
