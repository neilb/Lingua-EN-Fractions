#! perl
use 5.006;
use warnings;
use strict;

use Test::More 0.88;
use Lingua::EN::Fractions qw/ fraction2words /;

plan tests => 5;

is
(
    fraction2words('-2/3', 'British'),
    'minus two thirds',
    'british works'
);

is
(
    fraction2words('-2/3'),
    'minus two thirds',
    'british is the default'
);

is
(
    fraction2words('-2/3', 'American'),
    'negative two thirds',
    'american works'
);


my $wrong = eval
{
    fraction2words('-2/3', 'Australian');
    1
};
ok
(
    ! defined $wrong,
    'unknown dies'
);
like
(
    $@,
    qr/^Unknown variant "Australian"\.$/,
    'correct exception'
);
