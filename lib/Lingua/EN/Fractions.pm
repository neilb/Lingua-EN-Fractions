package Lingua::EN::Fractions;

use 5.006;
use strict;
use warnings;

use parent 'Exporter';
use Lingua::EN::Numbers qw/ num2en num2en_ordinal /;

our @EXPORT_OK = qw/ fraction2words /;

my %special_denominators =
(
    2 => { singular => 'half',    plural => 'halve'   },
    4 => { singular => 'quarter', plural => 'quarter' },
);

sub fraction2words
{
    my $number = shift;
    my $fraction = qr|
                        ^
                        (\s*-)?
                        \s*
                        ([0-9]+)
                        \s*
                        /
                        \s*
                        ([0-9]+)
                        \s*
                        $
                     |x;

    if (my ($negate, $numerator, $denominator) = $number =~ $fraction) {
        my $numerator_as_words   = num2en($numerator);
        my $denominator_as_words = do {
            if (exists $special_denominators{$denominator}) {
                if ($numerator == 1) {
                    $special_denominators{ $denominator }->{singular};
                }
                else {
                    $special_denominators{ $denominator }->{plural};
                }
            }
            else {
                num2en_ordinal($denominator);
            }
        };
        my $phrase = '';
        
        $phrase .= 'minus ' if $negate;
        $phrase .= "$numerator_as_words $denominator_as_words";
        $phrase .= 's' if $numerator > 1;
        return $phrase;
    }

    return undef;
}

1;

=head1 NAME

Lingua::EN::Fractions - convert "3/4" into "three quarters", etc

=head1 SYNOPSIS

 use Lingua::EN::Fractions qw/ fraction2words /;

 my $fraction = '3/4';
 my $as_words = fraction2words($fraction);

=head1 DESCRIPTION

This module provides a function, C<fraction2words>,
which takes a string containing a fraction and returns
the English phrase for that fraction.
If no fraction was found in the input, then C<undef> is returned.

For example

 fraction2words('1/2');    # "one half"
 fraction2words('3/4');    # "three quarters"
 fraction2words('5/17');   # "five seventeenths"
 fraction2words('5');      # undef
 fraction2words('-3/5');   # "minus three fifths"

At the moment, no attempt is made to simplify the fraction,
so C<'5/2'> will return "five halves" rather than "two and a half".

At the moment it's not very robust to weird inputs.
I may add support for Unicode fractions as well.

=head1 SEE ALSO

L<Lingua::EN::Numbers>,
L<Lingua::EN::Numbers::Ordinate>,
L<Lingua::EN::Numbers::Years> - other modules for converting numbers
into words.

L<Number::Fraction> may be supported in a future release.

=head1 REPOSITORY

L<https://github.com/neilbowers/Lingua-EN-Fractions>

=head1 AUTHOR

Neil Bowers E<lt>neilb@cpan.orgE<gt>

This module was suggested by Sean Burke, who created the
other C<Lingua::EN::*> modules that I now maintain.

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Neil Bowers <neilb@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
