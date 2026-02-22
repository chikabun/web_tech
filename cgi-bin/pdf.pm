package pdf;

use PDF::API2;

sub createPDF {
    my $t = shift;

    my $pdf = PDF::API2->new() or die $!;

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
    # my $image = $pdf->image('ex2.png');
    # $page->object($image, 100, 100);

    $pdf->save('new.pdf');
}

1;
