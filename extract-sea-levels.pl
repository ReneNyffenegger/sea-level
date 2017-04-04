#!/usr/bin/perl
use warnings;
use strict;
# use Config;

# die unless $Config{shortsize} == 2;
# exit;

my $pixel_width_deg = '0.30';

my $xyz_file = "$ENV{digitales_backup}Development/Daten/GeoSpatial-etc/ETOPO1/$pixel_width_deg.xyz";
die "$xyz_file does not exist" unless -f $xyz_file;
open (my $in , '<', $xyz_file) or die $!;
#open (my $out, '>', "sea-level.js") or die;
open (my $out, '>', "sea-level.$pixel_width_deg.bin") or die;
binmode $out;

# print $out "var z=[";

my $cnt = 0;
for (my $y=  90; $y >= -90; $y -= $pixel_width_deg) {
for (my $x=-180; $x <  180; $x += $pixel_width_deg) {

    my $line = <$in>;
    die unless defined $line;
    chomp $line;
    my $line_  = sprintf("%6.3f\t%6.3f", $x, $y);
    die "x: $x, y: $y\nline: $line" unless $line =~ /^$line_\t(-?\d+)$/;
    my $z = $1;
#   print $out "$z,";
#   print $out pack('v', $z); # v:  An unsigned short (16-bit), little Endian
    print $out pack('s', $z); # s:  An   signed short (16-bit)
    $cnt ++;

  }
  my $x=180;
  my $line = <$in>; # Read redundant »end« 
  die unless $line;
  chomp $line;
  my $line_  = sprintf("%6.3f\t%6.3f", $x, $y);
  die "x: $x, y: $y\nline: $line" unless $line =~ /^$line_\t(-?\d+)$/;
}

# print $out "];\n";

print "$cnt bytes written\n";
