#!/usr/bin/env perl

# ketto2yaml.pl
# - TARGETのチェック種牡馬リストファイルをサイアーラインごとのYAMLに変換・出力する
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
my $sire_lines = (); 

sub usage(){
  print "usage: " . basename($0) . " KETTO_LIST\n"; 
  exit 1;
}

unless (@ARGV == 1) {
  usage();
}

my $file = $ARGV[0];
open my $fh, '<:encoding(shiftjis):crlf', $file or die qw/Can't open file "$file" : $!/;

while (my $l = <$fh>){
  chomp $l;
  $l =~ s/"//g;
  if ($l =~ qr/^(\d+),\@T(.*)$/) {
    my $sire_line_name = $2;
    my $sire_line_key = $1;
    unless (defined $sire_lines->{$sire_line_key} ){
      $sire_lines->{$sire_line_key}->{name} = $sire_line_name;
      $sire_lines->{$sire_line_key}->{color} = "";
      $sire_lines->{$sire_line_key}->{sires} = [];
    } else {
      print "WARN: sire line $sire_line_name($sire_line_key) already defined!¥n";
    }
  } elsif ($l =~ qr/^(\d+),\@C([0-9A-Z]{6})$/) {
    my $sire_line_color = $2;
    my $sire_line_key = $1;
    if (defined $sire_lines->{$sire_line_key} ){
      $sire_lines->{$sire_line_key}->{color} = $sire_line_color;
    }
  } elsif ($l =~ qr/^(\d+),([^,]+)$/) {
    my $sire_name = $2;
    my $sire_line_key = $1;
    if (defined $sire_lines->{$sire_line_key} ){
      push @{$sire_lines->{$sire_line_key}->{sires}}, $sire_name;
    }
  }
}

foreach my $key (keys %$sire_lines) {
  if (defined $sire_lines->{$key}) {
    my $sires = join("\n", @{$sire_lines->{$key}->{sires}});
    open my $sfh, '>', "${work_dir}/${key}.yml" or die "Can't open file ${work_dir}/${key}.yml";
    print $sfh YAML::XS::Dump($sire_lines->{$key});
    close $fh;
  }
}

