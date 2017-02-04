#!/usr/bin/perl

use File::Find;
use File::Spec::Functions;
use File::Basename;
use strict;
use warnings;
my ($directory1, $directory2) = @ARGV;

# About the script
# Find missing files in directory2 that are in directory1
# and check the ownership and permissions for the files that are in both

find(\&hashfiles, $directory1);

# Find missing files in directory1 that are in directory2
find(\&missingfiles, $directory2);


#subroutines
sub missingfiles {
   my $file2 = $File::Find::name;
   (my $file1 = $file2) =~ s/^$directory2/$directory1/;
   if (-e $file1){
     # do nothing
   }
   else{
     print "$file1 is absent in $directory1\n";
  }
}

sub hashfiles {
  my $file1 = $File::Find::name;
  (my $file2 = $file1) =~ s/^$directory1/$directory2/;
  if (-e $file2){

     my $mode1 = (stat($file1))[2] ;
     my $mode2 = (stat($file2))[2] ;

     my $uid1 = (stat($file1))[4] ;
     my $uid2 = (stat($file2))[4] ;

     print "Permissions for $file1 and $file2 are not the same\n" if ( $mode1 != $mode2 );
     print "Ownership for $file1 and $file2 are not the same\n" if ( $uid1 != $uid2 );
  }
  else{
      print "$file2 is absent in $directory2\n";
  }
}
