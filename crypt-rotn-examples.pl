#!/usr/bin/perl

use Crypt::rotn qw(rot_n rot_all @latin);

# classic rot13
print rot_n("hello world", 13) . "\n";

# get all rot_n for hello world 
my @test = rot_all("hello world");
foreach my $str (@test) {
	print $str . "\n";
}

# get all rot_n for hello world for latin alphabet (includes lowercase and uppercase)
@test = rot_all("hello world", \@Crypt::rotn::latin);
foreach my $str (@test) {
	print $str . "\n";
}
