use strict;
use warnings;
use utf8;

use Encode::BaseN;
use Test::More;
use Test::Name::FromLine;
use Test::Fatal;

subtest 'base0 base1' => sub {
	like exception {
		my $encoder = Encode::BaseN->new(
			chars => [ ]
		);
	}, qr'chars must be supplied with 2 or more length';

	like exception {
		my $encoder = Encode::BaseN->new(
			chars => [ 0 ]
		);
	}, qr'chars must be supplied with 2 or more length';
};

subtest 'base2' => sub {
	my $encoder = Encode::BaseN->new(
		chars => [ (0..1) ],
	);

	is $encoder->encode('0'), '0';
	is $encoder->decode('0'), '0';

	is $encoder->encode(0xffff), '1111111111111111';

	for my $i (qw/9235113611380768826 9235114153936237539 9235114151314841248 9235114151314993313 9235114142823296511/) {
		is $encoder->decode($encoder->encode($i)), $i, "test $i";
	}
};

subtest 'base10' => sub {
	my $encoder = Encode::BaseN->new(
		chars => [ (0..9) ],
	);

	is $encoder->encode('0'), '0';
	is $encoder->decode('0'), '0';

	is $encoder->encode('9235113611380768826'), '9235113611380768826';

	for my $i (qw/9235113611380768826 9235114153936237539 9235114151314841248 9235114151314993313 9235114142823296511/) {
		is $encoder->decode($encoder->encode($i)), $i, "test $i";
	}
};

subtest 'base16' => sub {
	my $encoder = Encode::BaseN->new(
		chars => [ (0..9), ('a' .. 'f') ],
	);

	is $encoder->encode('0'), '0';
	is $encoder->decode('0'), '0';

	is $encoder->encode(0xffffff), 'ffffff';
	is $encoder->encode(0xffff), 'ffff';

	for my $i (qw/9235113611380768826 9235114153936237539 9235114151314841248 9235114151314993313 9235114142823296511/) {
		is $encoder->decode($encoder->encode($i)), $i, "test $i";
	}
};

subtest 'base58' => sub {
	my $encoder = Encode::BaseN->new(
		chars =>  [qw(
			1 2 3 4 5 6 7 8 9
			a b c d e f g h i
			j k m n o p q r s
			t u v w x y z A B
			C D E F G H J K L
			M N P Q R S T U V
			W X Y Z
		)]
	);

	is $encoder->encode('0'), '1';
	is $encoder->decode('1'), '0';

	is $encoder->encode("0xffffff"), '2tZhk';
	is $encoder->decode('2tZhk'), '16777215';

	is $encoder->encode("0xffffffff"), '7xwQ9g';
	is $encoder->decode('7xwQ9g'), '4294967295';

	is $encoder->encode('9235113611380768826'), 'nrkMyzsS7w7';
	is $encoder->decode('nrkMyzsS7w7'), '9235113611380768826';

	for my $i (qw/9235113611380768826 9235114153936237539 9235114151314841248 9235114151314993313 9235114142823296511/) {
		is $encoder->decode($encoder->encode($i)), $i, "test $i";
	}
};

subtest 'base256 with unicode' => sub {
	my $encoder = Encode::BaseN->new(
		chars => [ map { chr($_) } (0x2800 .. 0x28ff) ],
	);

	is $encoder->encode('0'), '⠀';
	is $encoder->decode('⠀'), '0';

	is $encoder->encode('9235113611380768826'), '⢀⠩⢶⣦⡚⢹⣀⠺';

	for my $i (qw/9235113611380768826 9235114153936237539 9235114151314841248 9235114151314993313 9235114142823296511/) {
		is $encoder->decode($encoder->encode($i)), $i, "test $i";
	}
};

done_testing;
