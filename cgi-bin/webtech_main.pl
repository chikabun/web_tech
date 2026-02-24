#!/usr/bin/perl

use v5.30;
use lib '.';

use CGI;
use Data::Dumper;
use FindBin qw($RealBin);

use db;
use markup;
use pdf;

my $q = CGI->new;
my $sid = $q->param('session_id');
my $isCreatePDF = $q->param('create_pdf');
my $t = $q->param('txt');
my $file = $q->param('img');

my $vars = {
    sid => $sid,
    navigator => markup::getNavigator($sid),
};

if ($sid) {
    my $isSessionOK = db::isSessionOK($sid);

    if ($isSessionOK) {

        my $user = db::getUserBySessionId($sid);

        # save submitted image
        my $filename;
        if ($file && $file =~ /\.png$/i) {
            my $fh = $file;
            $filename = $RealBin . '/upload/' . $user->{uid} . '_' . time() . '.png';
            open my $OUTFILE, '>', $filename or die $filename;
            binmode($fh);
            binmode($OUTFILE);
            my $bytesread;
            while (my $bytes = read($fh, my $buffer, 1024)) {
                $bytesread += $bytes;
                print $OUTFILE $buffer;
            }
            close $OUTFILE;
        }

        # do main work, if a PDF creation required
        if ($isCreatePDF) {
            pdf::createPDF($t, $user->{uid}, $filename);
            db::createTask($user->{uid}, $t);
        }

        # cleanup
        if ($filename && -e $filename) {
            unlink $filename;
        }

        # display main page
        my $user = db::getUserBySessionId($sid);
        $vars->{username} = $user->{firstname} . ' ' . $user->{lastname};

        my $tasks = db::getAllTasksForUser($user->{uid});
        my $ctr = 1;
        for my $task (@{$tasks}) {
            $task->{position} = $ctr;
            $task->{created} = localtime($task->{created});
            $task->{link} = sprintf '/cgi-bin/webtech_download.pl?session_id=%s&tid=%s', $sid, $task->{tid};
            $ctr++;
        }
        $vars->{tasks} = $tasks;
        markup::createPage('main_page.html', $vars);

        exit;
    }
}

markup::createPage('empty_page.html', $vars);
