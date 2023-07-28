#!/usr/bin/perl

#################################
# Fri Jun  9 09:30:48 EDT 2006
#################################
#
# This program will convert a unicode utf8 encoded Bangla source text
# file for TeX/LaTeX into bangtex format.
#
# Copyright (C) 2006  Abhijit Dasgupta (takdoom@yahoo.com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#
####################################

#use encoding 'utf8';
use utf8;
use charnames ':full';

use Getopt::Std;

$prog = $0;
$prog =~ s,^.*/,,;

$usage =  "Usage:  $prog [-d] [infile]" ;

die "$usage\n"
	unless getopts('d');
die "$usage\n"
	unless ($#ARGV <= 0);

$UNITOK = 0;
$UNITOK = 1
	if ($opt_d);

$infilehandle = *STDIN;
if ($#ARGV == 0 && "$ARGV[0]" ne "-") {
	die "could not open \"$ARGV[0]\" for reading\n"
		unless (open (FS, $ARGV[0]) == 1);
	$infilehandle = *FS;
}
binmode($infilehandle, ":utf8") || die "Could not set unicode mode\n";


%bangtex = (
# Devnagari DANDA and DOUBLE DANDA
0x964 => ".", 0x965 => "..",
# Chandrabindu, Anuswar, and Bisorgo
0x981 => "NN", 0x982 => "NNG", 0x983 => "{h}",
# Swarabarna
0x985 => "A", 0x986 => "Aa", 0x987 => "{I}", 0x988 => "II",
0x989 => "U", 0x98a => "UU", 0x98b => "RR", 0x98f => "E", 0x990 => "OI",
0x993 => "{O}", 0x994 => "OU",
# Main Banjonbarna
0x995 => "k", 0x996 => "kh", 0x997 => "g", 0x998 => "gh", 0x999 => "NG",
0x99a => "c", 0x99b => "ch", 0x99c => "j", 0x99d => "jh", 0x99e => "NJ",
0x99f => "T", 0x9a0 => "Th", 0x9a1 => "D", 0x9a2 => "Dh", 0x9a3 => "N",
0x9a4 => "t", 0x9a5 => "th", 0x9a6 => "d", 0x9a7 => "dh", 0x9a8 => "n",
0x9aa => "p", 0x9ab => "ph", 0x9ac => "b", 0x9ad => "bh", 0x9ae => "m",
0x9af => "J", 0x9b0 => "r", 0x9b2 => "l", 0x9b6 => "sh", 0x9b7 => "Sh",
0x9b8 => "s", 0x9b9 => "H",
# Kars
0x9be => "a", 0x9bf => "i", 0x9c0 => "ii", 0x9c1 => "u", 0x9c2 => "uu",
0x9c3 => "rR", 0x9c7 => "e", 0x9c8 => "{oi}", 0x9cb => "ea", 0x9cc => "eou",
# HASANTA, Khandatta, and right-ou-kar
0x9cd => ":/", 0x9ce => "t//", 0x9d7 => "ou",
# Doy-shuno-rha, DDHHoy-shunyo-rrha, and Yaw
0x9dc => "rh", 0x9dd => "rhh", 0x9df => "y",
# Numerals
0x9e6 => "0", 0x9e7 => "1", 0x9e8 => "2", 0x9e9 => "3", 0x9ea => "4",
0x9eb => "5", 0x9ec => "6", 0x9ed => "7", 0x9ee => "8", 0x9ef => "9",
# Special punctuation bar, ZWNJ, and ZWJ:
0x9f7 => ".", 0x200c => "", 0x200d => ""
) ;

%bangtexphola = (
0x9a3 => "/N", 0x9a8 => "/n",
0x9ac => "W", 0x9ae => "M", 0x9af => "Y", 0x9b0 => "R", 0x9b2 => "L",
0x9df => "Y", 
);

# Some unicode single-character strings
$ZWNJ = "\x{200C}";
$ZWJ = "\x{200D}";
$Aw = "\x{985}";
$Aaa = "\x{986}";
$CNBND = "\x{981}";
$DNARI = "\x{964}";
$DDNARI = "\x{965}";
$HSNT = "\x{9cd}";
$Yjaw = "\x{9af}";
$Akar = "\x{9be}";
$Raw = "\x{9b0}";

######################
# Character classes
######################

sub InSwarabarna {
  return <<END;
0985\t098c
098f\t0990
0993\t0994
END
}

sub InKars {
  return <<END;
09bc\t09bc
09be\t09c4
09c7\t09c8
09cb\t09cc
09d7\t09d7
END
}

sub InAtoms {
  # chandrabindu, anuswar, bishorgo; Khanda-ta ; numerals
  # Removed HASANTA from this class
  return <<END;
0981\t0983
09ce\t09ce
09e6\t09ef
END
}

sub InPostSticky {
  # Kars, Chandrabindu, HASANTA (these stick to the preceding character)
  # Also adding ZWNJ to class InPostSticky (for Phola)
  return <<END;
+main::InKars
0981\t0981
09cd\t09cd
200c\t200c
END
}

sub InBinaryJoiner {
  # HASANTA seems to be the only unicode bangla binary joiner (for juktakhor)
  return <<END;
09cd\t09cd
END
}

sub InByanjon {
  return <<END;
0995\t09a8
09aa\t09b0
09b2\t09b2
09b6\t09b9
09dc\t09dd
09df\t09df
END
}

sub InYaPhola {
  # Antasta-Ja, Antasta-IYa
  return <<END;
09af\t09af
09df\t09df
END
}

sub InNaPhola {
  # The two Na-s
  return <<END;
09a3\t09a3
09a8\t09a8
END
}

sub InBaMaRaLaPhola {
  # Ba, Ma, Ra, La
  return <<END;
09ac\t09ac
09ae\t09ae
09b0\t09b0
09b2\t09b2
END
}

sub InPholaNotYa {
  # Na, Na, Ba, Ma, Ra, La
  return <<END;
+main::InNaPhola
+main::InBaMaRaLaPhola
END
}

sub InPholaNotNa {
  # Ya, Ba, Ma, Ra, La
  return <<END;
+main::InYaPhola
+main::InBaMaRaLaPhola
END
}

sub InPhola {
  # all Pholas
  return <<END;
+main::InYaPhola
+main::InNaPhola
+main::InBaMaRaLaPhola
END
}

sub InByajonNotPhola {
  # include Na, as that is not really a phola!
  return <<END;
+main::InByanjon
-main::InPholaNotNa
END
}



while(<$infilehandle>) {
	# chomp;
        while (m/(
		# extract token
		\P{Bengali}		# map to self (or code if non-ascii)
					# take care of DANDA and DOUBLE-DANDA
		# | .(?=$ZWNJ)		# map to self (or code if non-ascii)
		#			# take care of DANDA and DOUBLE-DANDA
		| $Aw $CNBND? $HSNT \p{InYaPhola} $CNBND? $Akar
				# map to "$Aw$IFCNBND$HSNT$YAPHOLA$Akar"
		| $Aw $Akar $CNBND?		# map to "$Aaa$IFCNBND"
		| $Aw $CNBND? $Akar		# map to "$Aaa$IFCNBND"
		| \p{InSwarabarna} (?:$CNBND)?	# map to self
		| \p{InAtoms}			# map to self
		| \p{InKars}			# map to self (anomaly)
		| \p{InByanjon} (?!\p{InPostSticky})	# map to self
                # | \p{InByanjon} (?:$CNBND)? (?!(?: $HSNT | \p{InKars}))
		|
		(?: $Raw \p{InBinaryJoiner} (?=\p{InByanjon}))?	# reph, if any
		\p{InByanjon} (?:$CNBND)?		# the character
                (?: \p{InBinaryJoiner} \p{InByajonNotPhola})? # form juktakkhor
		(?:$CNBND)?
		(?: (?:$ZWNJ)? \p{InBinaryJoiner} \p{InPholaNotYa})? # Phola but NonJaPhola
		(?:$CNBND)?	# All chandras should be consolidated here!
		(?: $HSNT (?!\p{InByanjon}))?		# any real Hasanta
		(?: (?:$ZWNJ)? \p{InBinaryJoiner} \p{InYaPhola})? # Ja-Phola
		(?:$CNBND)?
		(?: $HSNT (?!\p{InByanjon}))?		# any real Hasanta
		(?:$CNBND)?
		(?: \p{InKars} )?
		# (?:
		#	(?: $HSNT (?!\p{InByanjon}))	# real Hasanta
		#	|
		#	(?: \p{InKars} )		# Kar
		# )?
		(?:$CNBND)?
		|
		.(?=$ZWNJ)		# map to self (or code if non-ascii)
					# take care of DANDA and DOUBLE-DANDA
		|
		.			# COULD NOT PARSE!!!
		)/gx) {
		# token extracted:
		$tok = "$1" ;
		@ULIST = unpack("U*", $tok);
		@VLIST = unpack("U*", $tok);
		if ($UNITOK == 1) {
			print "\n";
			print join " ",
				grep {$_ = sprintf("%04x", $_)} @VLIST;
			print " : ";
			# next;
		}
		# figure out if token contains chandrabindu
		$IFCNBND = "";
		$IFCNBND = "NN"
			if ($tok =~ /$CNBND/);
		# if ($tok =~ /^.$/) # single-character token
		# if ($#ULIST == 0) # single-character token
		#		($tok =~ m/(?:^. (?: $HSNT | $CNBND )$)/)
		$jotil = "";
		if (($#ULIST == 0) ||
			(($#ULIST == 1) && (($ULIST[1] == 0x981) ||
						($ULIST[1] == 0x9cd)))) {
			# print STDERR "\nSINGLE CHAR\n\n";
			foreach $c (@ULIST) {
				# if ($tok =~ /^\C$/)
				if ($c <= 0xff) {
					$jotil .= chr($c) ;
				} elsif (defined($bangtex{$c})) {
					$jotil .= "$bangtex{$c}" ;
				} else {
					$jotil .= sprintf("\\Ucx{%04x}", $c);
				}
			}
		} elsif ($tok =~ /^$Aw$CNBND?$HSNT\p{InYaPhola}$CNBND?$Akar$/) {
			$jotil .= "A${IFCNBND}Ya";
		} elsif (($tok =~ /^$Aw$Akar$CNBND?$/) ||
			($tok =~ /^$Aw$CNBND?$Akar$/)) {
			$jotil .= "Aa${IFCNBND}";
		} elsif ($tok =~ /^($Raw\p{InBinaryJoiner})?(\p{InByanjon})$CNBND?(\p{InBinaryJoiner}\p{InByajonNotPhola})?$CNBND?($ZWNJ?\p{InBinaryJoiner}\p{InPholaNotYa})?$CNBND?($HSNT(?!\p{InByanjon}))?($ZWNJ?\p{InBinaryJoiner}\p{InYaPhola})?$CNBND?($HSNT(?!\p{InByanjon}))?$CNBND?(\p{InKars})?$CNBND?$/) {
			# print STDERR "\nHERE JOTIL\n\n";
			if ("$1" ne "") { # reph present
				$jotil .= "r/";
			}
			$mainbanj = ord("$2");
			$mainbang = $bangtex{$mainbanj};
			$postbang = "";
			# $jotil .= $bangtex{$mainbanj};
						# $jotil .= "kK"
			if ("$3" ne "") { # juktakkhor present
				@blist = unpack("U*", "$3");
				if ($#blist != 1) {
					print STDERR "ERRRR 1!!!\n";
				} else {
					$postbanj = $blist[1];
					# exceptions for bangtex:
					if ($mainbanj == 0x995 &&
						$postbanj == 0x9b7) {
						$mainbang = "kK";
						$postbang = "";
					} elsif ($mainbanj == 0x9b9 &&
						$postbanj == 0x9a8) {
						$mainbang = "n";
						$postbang = "/H";
					} elsif ($mainbanj == 0x9b9 &&
						$postbanj == 0x9a3) {
						$mainbang = "N";
						$postbang = "/H";
					} elsif ($mainbanj == 0x99c &&
						$postbanj == 0x99e) {
						$mainbang = "g";
						$postbang = "/Y";
					} else {
						$postbang = ("/" . $bangtex{$postbanj});
					}
				}
			}
			$jotil .= ($mainbang . $postbang) ;
			if ("$4" ne "") { # phola present
				@blist = unpack("U*", "$4");
				shift @blist
					if ($blist[0] == 0x200c);
				if ($#blist != 1) {
					print STDERR "ERRRR 2!!!\n";
				} else {
					$jotil .= $bangtexphola{$blist[1]};
				}
			}
			$jotil .= $IFCNBND ;
			if ("$5" ne "") { # real hasanta
				$jotil .= ":/";
			}
			if ("$6" ne "") { # Ya-phola
				$jotil .= "Y";
			}
			if ("$7" ne "") { # real hasanta
				$jotil .= ":/";
			}
			if ("$8" ne "") { # Kar
				$k = ord("$8");
				if ($k == 0x9bf) { # hrashwa-i-kar
					$jotil = "i" . $jotil;
				} elsif ($k == 0x9c7) { # e-kar
					$jotil = "e" . $jotil;
				} elsif ($k == 0x9c8) { # oi-kar
					$jotil = "{oi}" . $jotil;
				} elsif ($k == 0x9cb) { # o-kar
					$jotil = "e" . $jotil . "a";
				} elsif ($k == 0x9cc) { # ou-kar
					$jotil = "e" . $jotil . "ou";
				} else {
					$jotil .= $bangtex{$k};
				}
			}
		} else {
			print STDERR "PARSE ERRRR 3!!!\n";
		}
		if ($UNITOK == 1) {
			$jotil = "(\"" . $jotil . "\")"
		}
		print "$jotil";
	}
	if ($UNITOK == 1) {
		print "\n";	# done processing a line
	}
}

