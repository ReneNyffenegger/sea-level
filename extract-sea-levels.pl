#!/usr/bin/perl
use warnings;
use strict;
# use Config;

# die unless $Config{shortsize} == 2;
# exit;

open (my $in , '<', "$ENV{digitales_backup}development/Daten/GeoSpatial-etc/ETOPO1/0.25.xyz") or die $!;
#open (my $out, '>', "sea-level.js") or die;
open (my $out, '>', "sea-level.bin") or die;
binmode $out;

# print $out "var z=[";

my $cnt = 0;
for (my $y=  90; $y >= -90; $y -= 0.25) {
for (my $x=-180; $x <  180; $x += 0.25) {

    my $line = <$in>;
    die unless defined $line;
    die "x: $x, y: $y\nline: $line" unless $line =~ /^$x\t$y\t(-?\d+)$/;
    my $z = $1;
#   print $out "$z,";
#   print $out pack('v', $z); # v:  An unsigned short (16-bit), little Endian
    print $out pack('s', $z); # s:  An   signed short (16-bit)
    $cnt ++;

  }
  my $x=180;
  my $line = <$in>; # Read redundant »end« 
  die "x: $x, y: $y\nline: $line" unless $line =~ /^$x\t$y\t(-?\d+)$/;
}

# print $out "];\n";

print "$cnt bytes written\n";
