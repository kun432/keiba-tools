#!/usr/bin/env perl

# csv2xls.pl
#
# Copyright (c) 2022 Kuniaki Shimizu
# 
# This software is released under the MIT License.
# see https://github.com/kun432/keiba-tools/blob/main/LICENSE

use strict;
use warnings;
use Encode qw/encode decode/;
use utf8;

my @maru_num = (
  "①",
  "②",
  "③",
  "④",
  "⑤",
  "⑥",
  "⑦",
  "⑧",
  "⑨",
  "⑩",
  "⑪",
  "⑫",
  "⑬",
  "⑭",
  "⑮",
  "⑯",
  "⑰",
  "⑱",
);

while (<STDIN>){
  chomp;
  my @cols = split(",",decode('Shift_JIS', $_));

  # 馬名から先頭1文字取る
  $cols[8] = substr($cols[8],1);

  # 所属
  $cols[9] =~ s/\(栗\)/栗東/g;
  $cols[9] =~ s/\(美\)/美浦/g;

  # 斤量から空白を除去
  $cols[12] =~ s/\s+//g;
  if ($cols[12] =~ /^(\d+)(\D+)$/){
    $cols[12] = $1;
    $cols[11] .= $2;
  }

  # ローテ
  if ($cols[14] =~ /^\-/ ){
    $cols[14] = "短縮";
  } elsif ($cols[14] =~ /^\+/ ){
    $cols[14] = "延長";
  } elsif ($cols[14] =~ /^0/ ){
    $cols[14] = "同距離";
  } else {
    $cols[14] = "初出走";
  } 
  
  # 位置取り
  my $idx = 15;
  for (my $i = 0; $i < 4; $i++){  
    $cols[$idx] =~ s/\s+//g;
    my $tmp_pos = $cols[$idx];
    $idx++;
    my $str_pos = "";
    if ($tmp_pos) {
     $str_pos  = "　" x ($tmp_pos - 1);
     $str_pos .= $maru_num[$tmp_pos - 1];
     $str_pos .= "　" x (18 - $tmp_pos - 1);
    } else {
     $str_pos = "ー" x 18;
    }
    splice @cols, $idx, 0, "\"${str_pos}\"";
    $idx++;
  } 

  #種牡馬名
  $cols[-1] =~ s/"//g;
  $cols[-2] =~ s/"//g;
  $cols[-3] =~ s/"//g;
  $cols[-4] =~ s/"//g;

  my $line = join(",", @cols);
  $line =~ s/\*//g;
  print encode('UTF-8', $line) . "\n";
}
