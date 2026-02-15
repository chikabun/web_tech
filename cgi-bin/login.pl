#!/usr/bin/perl

use v5.30;
use CGI;
use Template;

my $q = CGI->new;
my $login = $q->param('login');
my $password = $q->param('password');

my $template = Template->new({ INCLUDE_PATH => 'templates' });
my $vars = {};

if (!$login && !$password) {  
    $vars->{login_message} = 'Enter login and password please';
}
else {
    if ($login eq 'alex' && $password eq '1' ) {
        $vars->{login_message} = 'Hello, BOSS';
    }
    else {
        $vars->{login_message} = 'Wrong login or password';
    }    
}

print "Content-Type: text/html\n\n";
$template->process('login_page.html', $vars) || die $template->error();
