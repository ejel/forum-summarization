#!/usr/bin/env perl

#
# usage: echo cluster_file query_file | UserAuthority.pl <auth_file> <datadir>
#
# Note: datadir is appended by the driver.pl script as it
# calls the feature script.
#

use strict;
use warnings;

use FindBin;

use MEAD::SentFeature;
use Data::Dumper;
use Scalar::Util qw(looks_like_number);
use List::Util qw(max min);

# command line args
my $authority_file = shift;
my $datadir = shift;

my %authority_scores = read_authority($authority_file);

extract_sentfeatures($datadir,
        { 'cluster' => \&cluster, 'Sentence' => \&sentence });

sub read_authority {
    my $authority_file = shift;

    my %authority_scores = ();
    open my $info, $authority_file or die "Could not open $authority_file: $!";
    foreach my $line (<$info>) {
        chomp $line;
        # split on last occurance of space character
        # as user_id sometimes contains spaces
        my ($user_id, $score) = $line =~ /(.*)\s+(\S+)/;
        $authority_scores{$user_id} = $score;
    }
    close $info;

    my @invalid_id = grep { !looks_like_number($authority_scores{$_}) } keys %authority_scores;

    # convert log-likelihood scores to postive values
    %authority_scores = map { $_ => exp $authority_scores{$_} } keys %authority_scores;
    # and normalize to 0-1 range
    my $min = min values %authority_scores;
    my $max = max values %authority_scores;
    %authority_scores = map { $_ => &normalize_score($authority_scores{$_}, $min, $max) } keys %authority_scores;

    return %authority_scores;
}

sub normalize_score {
    my ($score, $min, $max) = @_;
    return ($score - $min) / ($max - $min);
}

sub sentence {
    my $feature_vector = shift;
    my $sentref = shift;

    my $score;
    my $user_id = $$sentref{"UserID"};
    if ($user_id && exists $authority_scores{$user_id}) {
        $score = $authority_scores{$user_id};
    } else {
        $score = 0;
    }
    $$feature_vector{"UserAuthority"} = $score;
}
