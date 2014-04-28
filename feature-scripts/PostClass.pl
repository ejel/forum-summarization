#!/Users/ejel/perl5/perlbrew/perls/perl-5.19.3/bin/perl

#
# usage: echo cluster_file query_file | ThreadClass.pl <datadir>
#
# Note: datadir is appended by the driver.pl script as it
# calls the feature script.
#

use strict;
use warnings;

use FindBin;

use MEAD::SentFeature;

my $datadir = shift;

extract_sentfeatures($datadir, { 'Sentence' => \&sentence });

sub sentence {
    my $feature_vector = shift;
    my $sentref = shift;

    my $class = $$sentref{"Class"};

    # 1 Question
    # 2 Repeat Question
    # 3 Further Details
    # 4 Clarification
    # 5 Solution
    # 6 Positive Feedback
    # 7 Negative Feedback
    # 8 Junk

    my @criticals = (1, 5);
    my @junks = (8);

    my $score;
    if (! $class) {
        $score = 0; # headline does not have class assigned
    } elsif (grep($_ == $class, @criticals)) {
        $score = 1;
    } elsif ($class == 8) {
        $score = -1;
    } else {
        $score = 0;
    }
    $$feature_vector{"PostClass"} = $score;
}
