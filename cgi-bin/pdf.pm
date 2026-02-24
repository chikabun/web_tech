package pdf;

use strict;

use PDF::Builder;
use File::Path qw(make_path);

sub createPDF {
    my $t = shift;
    my $uid = shift;
    my $filename = shift;

    my $pdf = PDF::Builder->new() or die $!;

    # Add a blank page
    my $page = $pdf->page();
    # Set the page size
    $page->size('Letter');
    # Add a built-in font to the PDF
    my $font = $pdf->font('Helvetica-Bold');

    # Add some text to the page
    my $text = $page->text();
    $text->font($font, 20);
    $text->position(200, 700);
    $text->text($t);

    # add image
    my $image = $pdf->image('../public/images/ex2.png');
    $page->object($image, 100, 100);

    # add custom image
    if ($filename) {
        my $image = $pdf->image($filename);
        $page->object($image, 100, 350);
    }

    make_path('pdfs/' . $uid . '/');
    $pdf->save('pdfs/' . $uid . '/' . time() . '.pdf');
}

1;
