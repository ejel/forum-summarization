#!/usr/bin/env perl

#
# usage: echo cluster_file | cohesion.pl <idffile> <datadir>
#
# Note: datadir is appended by the driver.pl script as it
# calls the feature script.
#

use strict;
use warnings;

use FindBin;

use MEAD::SentFeature;
use MEAD::Evaluation;

use Essence::IDF;

# command-line args
my $idf_file = shift;
my $datadir = shift;

open_nidf($idf_file);

extract_sentfeatures($datadir, {'Cluster' => \&cluster,
        'Sentence' => \&sentence});

my @posts;

sub cluster {
    my $clusterref = shift;

    foreach my $did (keys %$clusterref) {
        my $docref = $$clusterref{$did};
        foreach my $sentref (@{$docref}) {
            push @posts, $$sentref{'TEXT'};
        }
    }
}

sub sentence {
    my $feature_vector = shift;
    my $sentref = shift;

    my $this_post = $$sentref{"TEXT"};

    my $cohesion = 0;
    foreach my $another_post (@posts) {
        $cohesion += cosine($this_post, $another_post)
    }
    $$feature_vector{"Cohesion"} = $cohesion;
    # $$feature_vector{"Cohesion"} = 1;
}
