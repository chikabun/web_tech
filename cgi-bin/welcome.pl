#!/usr/bin/perl

use v5.30;
use CGI;
use Template;

my $q = CGI->new;

my $template = Template->new({ INCLUDE_PATH => 'templates' });
my $vars = {};

print "Content-Type: text/html\n\n";
$template->process('welcome_page.html', $vars) || die $template->error();
