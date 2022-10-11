#!/usr/bin/env perl

# yaml2ketto.pl
# - YAMLで記載されたサイアーラインファイルからTARGETのチェック種牡馬リストファイルを出力する
#
# Copyright (c) 2022 Kuniaki Shimizu
# 
# This software is released under the MIT License.
# see https://github.com/kun432/keiba-tools/blob/main/LICENSE

use strict;
use warnings;
use Encode qw/encode decode/;
use utf8;
binmode STDIN,  ":utf8";
binmode STDOUT, ":utf8";

use File::Basename qw/basename dirname/;
use YAML::XS;

use Data::Dumper;

my $work_dir = "./work";
my $output_file = "./output/CheckKetto_Custom.LST";
my $default_color = "FFFFFF";

my $sire_lines = (); 
my @sires = (); 

sub usage(){
  print "usage: " . basename($0) . " KETTO_LIST\n"; 
  exit 1;
}

sub addQuote(){
  my ($str) = @_;
  $str = "\"$str\"" if $str =~ / /;
  return $str;
}

my @all_files = glob "$work_dir/*"; 
foreach my $f (@all_files) {
  my $yaml = YAML::XS::LoadFile($f);
  my $idx = (split(/\./, basename($f)))[0];
  $sire_lines->{$idx} = $yaml;
}

open my $ofh, ">:encoding(shiftjis):crlf", $output_file or die qw/Can't open file ${outputfile}/;

for (my $i = 1; $i < 100; $i++) {
  my $idx = sprintf "%02s", $i;
  if (defined $sire_lines->{$idx}) {
    my $n = &addQuote("\@T" . $sire_lines->{$idx}->{name});
    my $c = $sire_lines->{$idx}->{color};
    my $s = $sire_lines->{$idx}->{sires};
    foreach my $sn (@$s) {
      push @sires, sprintf "%02s,%s", $idx, &addQuote($sn);
    };
    printf $ofh "%02s,%s\n", $idx, $n;
    printf $ofh "%02s,\@C%s\n", $idx, $sire_lines->{$idx}->{color};
  } else {
    printf $ofh "%02s,\@C%s\n", $idx, $default_color;
  }
}

foreach my $s (@sires) {
  printf $ofh "$s\n";
}
close $ofh;
