package pdf;

use strict;

use PDF::Builder;
use File::Path qw(make_path);

sub createPDF {
    my $data = shift;
    my $uid = shift;
    my $type = shift;

    my $pdf = PDF::Builder->new() or die $!;

    if ($type eq 'business card') {
        my $page = $pdf->page();
        $page->size([0, 0, 600, 400]);
        my $font = $pdf->font('Helvetica-Bold');

        my $y = 360;
        foreach my $k ('firstname', 'lastname', 'position', 'email', 'phone', 'site') {
            my $v = $data->{$k};

            my $text0 = $page->text();
            $text0->font($font, 18);
            $text0->position(30, $y);
            $text0->text($k . ":");

            my $text1 = $page->text();
            $text1->font($font, 18);
            $text1->position(130, $y);
            $text1->text($v);

            $y -= 30;
        }

        my $staticImage1 = $pdf->image('../public/images/frame_with_author.png');
        $page->object($staticImage1, 20, 20);

        my $staticImage2 = $pdf->image('../public/images/frame_for_picture.png');
        $page->object($staticImage2, 350, 20);

        if ($data->{file1}) {
            my $image = $pdf->image($data->{file1});
            $page->object($image, 365, 40);
        }
    }
    elsif ($type eq 'post card') {
        my $page = $pdf->page();
        $page->size('Letter');
        my $font = $pdf->font('Helvetica-Bold');

        my $text = $page->text();
        $text->font($font, 20);
        $text->position(20, 700);
        $text->text($data->{firstname} . ' ' . $data->{lastname});

        # add custom image 1
        if ($data->{file1}) {
            my $image = $pdf->image($data->{file1});
            $page->object($image, 20, 400);
        }

        # add custom image 2
        if ($data->{file2}) {
            my $image = $pdf->image($data->{file2});
            $page->object($image, 300, 400);
        }

        my $staticImage1 = $pdf->image('../public/images/frame_with_author.png');
        $page->object($staticImage1, 20, 20);
    }
    elsif ($type eq 'album') {
        my $page = $pdf->page();
        $page->size('Letter');
        my $font = $pdf->font('Helvetica-Bold');

        my $text = $page->text();
        $text->font($font, 20);
        $text->position(20, 730);
        $text->text($data->{title});

        # add custom images
        if ($data->{file1}) {
            my $image = $pdf->image($data->{file1});
            $page->object($image, 50, 450);
        }
        if ($data->{file2}) {
            my $image = $pdf->image($data->{file2});
            $page->object($image, 350, 450);
        }
        if ($data->{file3}) {
            my $image = $pdf->image($data->{file3});
            $page->object($image, 50, 180);
        }
        if ($data->{file4}) {
            my $image = $pdf->image($data->{file4});
            $page->object($image, 350, 180);
        }

        my $staticImage1 = $pdf->image('../public/images/frame_with_author.png');
        $page->object($staticImage1, 20, 20);
    }
    else {
        die 'Unknown PDF type';
    }

    make_path('pdfs/' . $uid . '/');
    $pdf->save('pdfs/' . $uid . '/' . time() . '.pdf');
}

1;
