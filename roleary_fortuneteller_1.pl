#! perl -w

# Ryan OLeary - "Moderately Complex Perl Program"
# Survey of Perl/Python/PHP - Sect 061
#------------------------------------------------
# roleary_fortuneteller_1.pl
#------------------------------------------------
# This program:
#	Promts and accepts user input.
#	Reads from 2 seperate files.
#	Creates and writes to a third file.
#	Uses subroutines to read and display fortunes
#	as well as calculate the amount of fortunes read.
#----------------------------------------------------
# The aim of this program is to be a fortune teller,
# With a "text adventure" feel. I chose this sort of
# setup, so I could practice opening, and reading files,
# as well as chosing what lines (or not) the program
# references in the files. This program will only run
# if the two files- storytext.txt and fortunes.txt are
# in the same directory as the main program.
#-------------------------------------------------
# fortunes.txt contains all the fortunes the user can be
# read by Perl, the fortune teller, and the program chooses
# a line at random. This file can be edited to have as many 
# fortunes as will fit into system memory, but currently holds
# 20.
#------------------------------------------------------
# storytext.txt contains the narrative. The subprocess is passed
# 2 arguements, what line to start reading, and where to end, and
# it ouputs each line to the console. It is expandable as well.
#------------------------------------------------------
# when the player runs away from the fortune teller, the
# this system opens(and/or creates) a log file called fortunerecord.txt
# and writes to the file: how many fortunes were read, and at what date and time.
#-------------------------------------------------------------

#these variables for recording log.
# $datetime passes time/date to record
# fortunesRead counts how many times
# the fortuneteller gives a fortune

$datetime = localtime();
$fortunesRead = 0;

# Gives creepy intro, which user "hits any key" to advance the narrative.
story(0,4);
waitForKey();
story(5, 7);
waitForKey();
story(9,20);

#begins the fortunetelling experience
mainLoop();



#--------------SUBROUTINES---------------------
# main loop prompts the user input if they would like a fortune, or not,
# if the user does not reply affirmatively, it calls goodbye(). when the user
# enters 'y', it calls get_fortune(), then asks the user if they would like another
# fortune, and calls itself to repeat the process.
sub mainLoop {
	
	print "{Y}es, all other keys exit the booth:\n";
	$answer = <STDIN>;
	chomp($answer);
		if ($answer eq 'y') { 
		getFortune();
		print "Another fortune, my pretty!?\n\n";
		mainLoop();
		}
	else {
	goodBye();
	}
}


# story() is passed 2 arguments, a start line, and end line.
# it opens storytext.txt,(or dies, if not found) saves the content to an array "@storylines"
#then closes the storytext.file. the for loop prints each line
# within the paramaters passed to the console, generating the narrative.

sub story {
	open STORY, "<storytext.txt" or die "Could not open storytext.txt: $!\n";
	@storylines=<STORY>;
	close STORY;
	$startline = $_[0];
	$endline = $_[1]; 
	for ($startline ; $startline <= $endline; $startline += 1) {
		print($storylines[$startline]);
	} 
}

# getFortune opens "fortunes.txt"(or dies, if not found) saves the content to an array "@fortunelist" then
# closes the fortunes.txt file. it then picks a random fortune from the array, and outputs
#it to the console.
sub getFortune {
	open FORTUNES, "<fortunes.txt" or die "Could not open fortunes.txt: $!\n";
	@fortunelist=<FORTUNES>;
	close FORTUNES;
	$randomline= $fortunelist[rand @fortunelist];
	print("Perl gazes into her crystal ball, and says...\n\n");
	print($randomline . "\n");
	$fortunesRead += 1;
}

# recordUsage() opens fortunerecord file, if it doesnt exist, it creates it
# it then writes to the file, on a new line, each time, how many
# fortunes were read to the user, and at what time and date.
sub recordUsage {
	open(my $record,"+>>","fortunerecord.txt");
	print $record ("$fortunesRead" . " fortunes read on " . "$datetime\n")
}



# when called, gives exit message, ends program
sub goodBye {
	recordUsage();
	print("You run away in fear!!! You hear Perl laughing at you as you flee!\n");
	print("Check fortunerecord.txt to see how many fortunes you've been read!\n");
	exit;
}

# waitForKey awats any key press to advance.
# used to break up narrative.

sub waitForKey {
    print "\nPress any key to continue...\n";
    chomp($key = <STDIN>);
}
