#!/usr/bin/perl -w
# by Hoang Le P, 28/1/14 8:28AM

#dung cai nay de in mau ra man hinh
use Term::ANSIColor qw(:constants);

#main script here
#####################################################################
if (@ARGV == 0){usageAndDie();}
while (@ARGV > 0) { #while there are arguments left
	if ($ARGV[0] eq '?' || $ARGV[0] eq '/?' || $ARGV[0] eq '-h' || $ARGV[0] eq '--help' ) {usageAndDie();}
	$_ = shift(@ARGV);
	tr/A-Z/a-z/;  #convert to lower case
	if ($_ eq '--flowfox') {print "flow fox \n";flowfox(); exit;}	
	if ($_ eq '--tesummary') {print "tesummarry\n";tesummary(); exit;}
	if ($_ eq '--awk') {print "Count Tool\n";awk(); exit;}
	
	#if ($_ eq '-c') {next;}
}

#####################################################################

sub usageAndDie{

print "#==============================================================================#\n";
print "# Decoder speedup tool                                                         #\n";
print "# Coded by : Hoang Le P \(hoang.p.le\@ericsson.com\)                              #\n";
print "#==============================================================================#\n";


print "Usage:\n";
print " $0 OPTION\n";
print "Parameter Options:\n";
print "--help         : Help\n";	
print "--flowfox      : Decode to flowfox format \n";
print "--tesummary    : Decode to tesummary format\n";
print "--awk          : Count string in firststring and endstring\n";

exit;
}


sub tesummary{
	
system("ls /home/ephucle/tool_script/decoder/log | grep -i _r > /home/ephucle/tool_script/decoder/list.txt");
open(my $in,  "<",  "/home/ephucle/tool_script/decoder/list.txt")  or die "Can't open list.txt: $!";
my @lines = <$in>; 	
	
	foreach(@lines){	

$filename= substr($_, 0, -1);
print $filename;  #remove last charactor

print "\nStart decode";
chdir ("/home/ephucle/tool_script/decoder/log");
system("~/decoder/tesummary.pl -f ./$filename -o ~/tool_script/decoder/log/$filename.tesummary.txt");
		
}

print GREEN, "\n\n\>\> Output saved to ~/tool_script/decoder/log/$filename.tesummary.txt \n", RESET;


system("rm /home/ephucle/tool_script/decoder/list.txt");
}

sub flowfox{
system("ls /home/ephucle/tool_script/decoder/log | grep _d > /home/ephucle/tool_script/decoder/list.txt");
open(my $in,  "<",  "/home/ephucle/tool_script/decoder/list.txt")  or die "Can't open list.txt: $!";
my @lines = <$in>; 	

	
	foreach(@lines){	

	$filename= substr($_, 0, -1);
	print $filename;  #remove last charactor
	print "\nTo find Start time and end time, decode log by flow.pl first \n";
	#print "\nStart decode\n";
	
	print "start time:";		
	$starttime = <>;
	chop($starttime);
	
	print "\nend time:";
	$endtime = <>;
	chop($endtime);		
	chdir ("/home/ephucle/tool_script/decoder/log");
	system("~/decoder/flowfox.pl -f ./$filename -o ./$filename.html --start $starttime --end $endtime");

	}

#system("ls -l ~/tool_script/decoder/log | grep -i _d");
print GREEN, "\>\> Output saved to ~/tool_script/decoder/log/$filename.html  \n", RESET;
system("rm /home/ephucle/tool_script/decoder/list.txt");
}


sub awk{
	
	print "Begin string:";		
	$begin_string = <>;
	chop($begin_string);
	
	print "End string:";		
	$end_string = <>;
	chop($end_string);
	
	
	
	system("ls /home/ephucle/tool_script/decoder/log/awk | grep -v awk > /home/ephucle/tool_script/decoder/list.txt");
	open(my $in,  "<",  "/home/ephucle/tool_script/decoder/list.txt")  or die "Can't open list.txt: $!";
	my @lines = <$in>; 	

	
	foreach(@lines){	
	$filename= substr($_, 0, -1);
	chdir ("/home/ephucle/tool_script/decoder/log/awk");
	print "Statis about \"$begin_string\" in file $filename as below:\n";
	system("cat ./$filename |awk 'BEGIN\{FS=\"$begin_string\"\}\{print \$2\}' | awk 'BEGIN\{FS=\"$end_string\"\}\{print \$1\}' | sort | uniq -c | tee ./$filename.awk.txt");
	
	}
	system("rm /home/ephucle/tool_script/decoder/list.txt");
	print "\n\>\> Output saved to:";
	print GREEN, " ~/tool_script/decoder/log/$filename.awk.txt  \n", RESET;
	
}
