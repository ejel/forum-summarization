#!/usr/bin/env perl

=begin instruction

Create MEAD summary files from docsents

Example: mead-summary.pl --input Sentences/NYC --output Sentences/NYC/mead-output/post-default --params "--system LEADBASED"

Note: input dir must contain cluster, xml, docsent

=end instruction
=cut

use Getopt::Long;
use File::Basename;

my $input_dir = undef;
my $output_dir = undef;
my $mead_params = "";

GetOptions("input=s" => \$input_dir,
           "output=s" => \$output_dir,
           "params=s" => \$mead_params)
    or die ("Error in command line arguments\n");


if (! -d $input_dir) {
    die "input dir not found";
}

if (!$output_dir) {
    die "output dir not specified";
}

if (! -d $output_dir) {
    mkdir $output_dir or die "error creating directory $output_dir";
}

foreach (glob($input_dir . '/*.docsent')) {
    my($basename, $path, $suffix) = fileparse($_, ".docsent");
    my $result = `/Users/ejel/mead/bin/mead.pl -sentences -percent 20 -fcp delete -cluster_dir $input_dir -docsent_dir $input_dir -o ${output_dir}/$basename $mead_params $path/$basename`;
}