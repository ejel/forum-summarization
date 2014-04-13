#!/usr/bin/env perl

# Number of unique words per post
# stopwords are removed before counting

use strict;
use warnings;

use FindBin;

use Essence::Text;
use MEAD::SentFeature;
use Lingua::StopWords qw(getStopWords);

my $datadir = shift;

extract_sentfeatures($datadir, {'Sentence' => \&sentence});

sub sentence {
    my $feature_vector = shift;
    my $attribs = shift;

    my $stopwords = getStopWords('en', 'UTF-8');
    my @words = grep { !$stopwords->{$_} } split_words($$attribs{'TEXT'});
    my %unique_words = map { $_ => 1 } @words;
    $$feature_vector{'Length'} = keys %unique_words;
}
