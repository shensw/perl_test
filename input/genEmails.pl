#randomly generates a number of email addresses base on a domain list

use strict;
use warnings;

use File::RandomLine;
use String::Random qw(random_regex);

if ($ARGV[1])
{
	#grab output file name and the number of emails need to be generated
	my $file_name = $ARGV[0];
	my $num_emails = $ARGV[1];
	open (OUTPUT, ">$file_name") or die "Couldn't open file $file_name, $!";
	
	#randomly select a domain  note: algorithm => "uniform" if uniform result is required
	#return value = a new File::RandomLine object
	my $rand_domain = File::RandomLine->new( "domain_list.txt", { algorithm => "fast" } );
	
	for(1..$num_emails)
	{
		#randomly generated a string by using regular expression, appending the domain
		my $email_addr = random_regex('[a-z0-9_]{4,11}')."@".$rand_domain->next;
		print OUTPUT "$email_addr\n";
	}
	
	close OUTPUT;
}
else
{
	print "proper command: genEmails.pl file_name.txt #_of_emails\n";
	exit -1;
}