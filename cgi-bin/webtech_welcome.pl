#!/usr/bin/perl

use v5.30;
use lib '.';

use CGI;
use Template;

use db;
use markup;

my $q = CGI->new;
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

print "Content-Type: text/html\n\n";
$template->process('welcome_page.html', $vars) || die $template->error();
