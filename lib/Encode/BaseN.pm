package Encode::BaseN;
use 5.008005;
use strict;
use warnings;

use Math::BigInt;
use Carp;

our $VERSION = "0.01";

sub new {
	my ($class, %args) = @_;

	my $chars = $args{chars};
	croak "chars must be supplied with 2 or more length." if @$chars < 2;

	bless {
		base  => scalar @$chars,
		re    => qr/^[@{[ join "", @$chars ]}]+$/,
		chars => $chars,
		map   => do {
			my $i = 0;
			+{ map { $_ => $i++ } @$chars };
		},
	}, $class;
}

sub encode {
	my ($self, $num) = @_;
	return $self->{chars}->[0] unless $num;

	my $base = $self->{base};
	my $chars  = $self->{chars};

	$num = Math::BigInt->new($num);

	my $res = '';

	while ($num->is_pos) {
		my ($quo, $rem) = $num->bdiv($base);
		$res = $chars->[$rem] . $res;
	}

	$res;
}

sub decode {
	my ($self, $str) = @_;
	$str =~ $self->{re} or croak "Invalid chars";

	my $decoded = Math::BigInt->new(0);
	my $multi   = Math::BigInt->new(1);

	my $base = $self->{base};
	my $map  = $self->{map};

	while (length $str > 0) {
		my $digit = chop $str;
		$decoded->badd($multi->copy->bmul($map->{$digit}));
		$multi->bmul($base);
	}

	"$decoded";
}



1;
__END__

=encoding utf-8

=head1 NAME

Encode::BaseN - Encode/decode bigint to any baseN formats

=head1 SYNOPSIS

	use Encode::BaseN;

	# base58
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

	$encoder->encode("0xffffff") #=> '2tZhk';
	$encoder->decode('2tZhk') #=> '16777215';

=head1 DESCRIPTION

Encode::BaseN is encoder/decoder generator which can encode bigint to shorter strings like short URL services with any character sets.

=head1 LICENSE

Copyright (C) cho45.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

cho45 E<lt>cho45@lowreal.netE<gt>

=cut

