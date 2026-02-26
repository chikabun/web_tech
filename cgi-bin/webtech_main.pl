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
my $type = $q->param('document_type');

my $firstname = $q->param('firstname');
my $lastname = $q->param('lastname');
my $position = $q->param('position');
my $email = $q->param('email');
my $phone = $q->param('phone');
my $site = $q->param('site');

my $file = $q->param('img');
my $file2 = $q->param('img2');

my $vars = {
    sid => $sid,
    navigator => markup::getNavigator($sid),
};

if ($sid) {
    my $isSessionOK = db::isSessionOK($sid);

    if ($isSessionOK) {

        my $user = db::getUserBySessionId($sid);

        # save submitted image
        my $filename1;
        my $filename2;
        if ($file) {
            $filename1 = saveUploadedFile($file, $user, 'a');
        }
        if ($file2) {
            $filename2 = saveUploadedFile($file2, $user, 'b');
        }

        # do main work, if a PDF creation required
        if ($isCreatePDF) {
            my $data = {
                firstname => $firstname,
                lastname => $lastname,
                position => $position,
                email => $email,
                phone => $phone,
                site => $site,

                file1 => $filename1,
                file2 => $filename2,
            };
            pdf::createPDF($data, $user->{uid}, $type);

            my @tmp = ();
            for my $k ('firstname', 'lastname', 'position', 'email', 'phone', 'site') {
                if ($data->{$k}) {
                    push @tmp, $k . '=' . $data->{$k};
                }
            }
            my $data4task = join ", ", @tmp;
            db::createTask($user->{uid}, $data4task, $type);
        }

        # cleanup
        if ($filename1 && -e $filename1) {
            unlink $filename1;
        }
        if ($filename2 && -e $filename2) {
            unlink $filename2;
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


sub saveUploadedFile {
    my $file = shift;
    my $user = shift;
    my $suffix = shift;

    my $filename;
    if ($file && $file =~ /\.png$/i) {
        my $fh = $file;
        $filename = $RealBin . '/upload/' . $user->{uid} . '_' . time() . '_' . $suffix . '.png';
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

    return $filename;
}