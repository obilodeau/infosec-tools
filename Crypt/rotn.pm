package Crypt::rotn;


=head1 BUGS AND LIMITATIONS

Be careful with large input strings, I paid no attention to memory or processing efficiency.

=cut

use strict;
use warnings;

use base 'Exporter';

our $VERSION = '0.01';
our @EXPORT_OK = qw(
    rot_n
    positional_rot
    rot_all
    @lowercase_latin
    @uppercase_latin
    @latin
    @printable_ascii
);


#TODO simplify custom alphabet handling (expose as a string maybe?)
our @lowercase_latin = split('', "abcdefghijklmnopqrstuvwxyz");
our @uppercase_latin = split('', "ABCDEFGHIJKLMNOPQRSTUVWXYZ");
our @latin = split('', "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ");
our @printable_ascii = split('', '!"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~');

=head1 SUBROUTINES

=over

=item rot_n ( input, degree, alphabet )

input string, degree of rotation (rot13 = degree 13), alphabet as an arrayref

returns string

=cut

sub rot_n {
    my ($input, $degree, $alphabet) = @_;

    # lowercase_latin is default alphabet
    $alphabet = \@lowercase_latin unless defined($alphabet);

    # covert input string into input arrayref
    my @input = split('', $input);
    $input = \@input;

    my $result;
    foreach my $char (@{$input}) {
        if ($char eq ' ') {
            $result .= ' ';
        } else {
            my $new_pos = ((_find_pos($char, $alphabet) + $degree) % (scalar @{$alphabet}));
            $result .= $alphabet->[$new_pos];
        }
    }
    return $result;
}

=item positional_rot ( input, transformation, alphabet )

input string, transformation as a coderef (explained below), alphabet as an arrayref

returns string

positional_rot is a rot_n transformation where the n varies based on the position of the char in the string.

ex: hello with a positional_rot of n = (2i + 5) gives: mluwB

In the transformation coderef you provide the mean to caculate the n based on the string index.
For example to do n = (2i + 5) a coderef would look like:
  sub {
      my $pos = shift;
      return (2 * $pos + 5);
  }

=cut
sub positional_rot {
    my ($input, $transformation_coderef, $alphabet) = @_;

    # lowercase_latin is default alphabet
    $alphabet = \@lowercase_latin unless defined($alphabet);

    # covert input string into input arrayref
    my @input = split('', $input);
    $input = \@input;

    my $result;
    for (my $i = 0; $i < @{$input}; $i++) {
        my $char = ${$input}[$i];
        if ($char eq ' ') {
            $result .= ' ';
        } else {
            my $new_pos = ((_find_pos($char, $alphabet) + &$transformation_coderef($i)) % (scalar @{$alphabet}));
            $result .= $alphabet->[$new_pos];
        }
    }
    return $result;
}

=item rot_all

calls rot_n for all possible values (walks the entire alphabet)

returns an array of rot'ed strings

=cut
sub rot_all {
    my $input = shift;
    my $alphabet = shift;

    # lowercase_latin is default alphabet
    $alphabet = \@lowercase_latin unless defined($alphabet);

    my @return;
    for (my $rot_degree = 0; $rot_degree < (scalar @$alphabet); $rot_degree++) {
        push @return, rot_n($input, $rot_degree, $alphabet);
    }

    return @return;
}

sub _find_pos {
    my $needle = shift;
    my $haystack = shift;
    my $i;
    for ($i = 0 ; $i < scalar(@{$haystack}); $i++) {
         last if ($haystack->[$i] eq $needle) ;
    }
    return $i;
}

=back

=cut
1;
