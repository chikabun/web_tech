#!/usr/bin/perl

use v5.30;
use lib '.';

use CGI;
use Template;

use db;
use markup;

my $q = CGI->new;
my $login = $q->param('login');
my $password = $q->param('password');
my $uid = $q->param('uid');

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

if (!$login && !$password) {  
    $vars->{login_message} = 'Enter login and password please';
}
else {
    my $row = db::getUserByLoginAndPassword($login, $password);

    if ($row) {
        $vars->{login_message} = 'Hello, ' . $row->{firstname} . ' ' . $row->{lastname};

        # create session
        db::createSession($row->{uid});
        print $q->redirect("/cgi-bin/webtech_main.pl?uid=" . $row->{uid});
        exit;
    }
    else {
        $vars->{login_message} = 'Wrong login or password';
    }
}

print "Content-Type: text/html\n\n";
$template->process('login_page.html', $vars) || die $template->error();
