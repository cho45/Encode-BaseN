requires 'perl', '5.008001';
requires 'Carp', '0';
requires 'Math::BigInt', '0';

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'Test::Name::FromLine', '0';
};

