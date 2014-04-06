#!/usr/bin/env perl

# Prepare ROUGE input files from MEAD summaries.

use strict;
use XML::Simple qw(:strict);
use Data::Dumper;
use List::MoreUtils qw(uniq);


### INIT ###

my $OUTPUT_HOME = "/Users/ejel/forum-s11n/Sentences/rouge-staging"; #where to generate output
my $DIR_SYSTEM="/Users/ejel/forum-s11n/Sentences/NYC/mead-output"; # location of system generated files
my @sentences = ();


### Generated summary ###
opendir(SYS, "$DIR_SYSTEM") || die("Cannot open directory");
my @theSYSfiles= readdir(SYS);
@theSYSfiles = grep { $_ !~ /^\./ } @theSYSfiles;

foreach my $SYSdir (@theSYSfiles) # one dir per classification type
{
    my $thepath="$DIR_SYSTEM/$SYSdir";

    if ((-d $thepath) && ($SYSdir ne '.') && ($SYSdir ne '..') ) {

        opendir(SYSFILES, "$DIR_SYSTEM/$SYSdir") || die("Cannot open directory");
        my @thefiles= readdir(SYSFILES);

        foreach my $file (@thefiles)
        {
            if( ($file ne '.') && ($file ne '..')){
                my $abspath="$thepath/$file";
                @sentences = &open_file($abspath);

                open (SYSTEM, ">$OUTPUT_HOME/systems/${file}-${SYSdir}.html");
                print SYSTEM "<html>
                <head>
                <title>$file.html</title>
                </head>
                <body bgcolor=\"white\">\n";

                my $count = 1;

                foreach my $i (0..$#sentences) {
                    print SYSTEM "<a name=\"$count\">[$count]</a> <a href=\"#$count\" id=$count>";
                    print SYSTEM $sentences[$i];
                    print SYSTEM "</a>\n";
                    $count++;
                }
                print SYSTEM "</body>
                </html>\n";
                close SYSTEM;
                }
            }
        }
}

opendir my $dir, "$OUTPUT_HOME/models" || die "Cannot open dir $!";
my @files = readdir $dir;
@files = grep { $_ !~ /^\./ } @files;
closedir $dir;


# need only unique names
my @names = ();
foreach my $file (@files) {
    $file =~ s/(.+)-[DV]\.html/$1/g;
    push(@names, $file);
}
@names = uniq(@names);





### Config ###
my $config = {
    'version' => '1.5.5',
    'EVAL' => [],
};

foreach my $file (@names) {

    my $eval = {
        'ID' => "$file",
        'PEER-ROOT' => { content => 'systems'},
        'MODEL-ROOT' => { content => 'models'},
        'INPUT-FORMAT' => { TYPE => 'SEE' },
        'PEERS' => { 'P' => [] },
        'MODELS' => { 'M' => [] },
    };

    my $model1 = {
        'ID' => 'D',
        'content' => "${file}-D.html"
    };
    push($eval->{'MODELS'}->{'M'}, $model1);
    my $model2 = {
        'ID' => 'V',
        'content' => "${file}-V.html"
    };
    push($eval->{'MODELS'}->{'M'}, $model2);

    foreach my $s (@theSYSfiles) {
        my $peer = {
            'ID' => "$s",
            'content' => "${file}-$s.html"
        };
        push($eval->{'PEERS'}->{'P'}, $peer);
    }
    push($config->{'EVAL'}, $eval);
}

# open my $settingFile, "$OUTPUT_HOME/settings.xml" || die "can't open";
my $xs = XML::Simple->new(
        RootName => 'ROUGE-EVAL',
        KeyAttr => {},
        ForceArray => 1,
);
# close $settingFile;

$xs->XMLout($config, OutputFile => "$OUTPUT_HOME/settings.xml");



sub open_file {
my $file = shift;

my @sents = ();

local( $/ ) = undef;

open(FILE, "$file") or die "can't find the file: $file. \n";

my $input = <FILE>;

close FILE;

if ($input =~/DOCTYPE DOCUMENT SYSTEM/){
   my $text = "";
   $input =~/<TEXT>(.*)<\/TEXT>/s;
   $text = $1;
   @sents = split /[\n\r]/, $text;
}

else {

@sents = split /[\n\r]/, $input;

foreach my $s (@sents){
   $s =~s/^\[\d+\]\s+(.*)/$1/;
  }
}
return @sents;
}

