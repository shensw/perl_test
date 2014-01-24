#randomly generates a number of email addresses base on a domain list

use strict;
use warnings;

use File::Random qw(random_line);
use String::Random qw(random_regex);

if ($ARGV[1])
{
	#grab output file name and the number of emails need to be generated
	my $file_name = $ARGV[0];
	my $num_emails = $ARGV[1];
	open (OUTPUT, ">$file_name") or die "Couldn't open file $file_name, $!";
	
	for(1..$num_emails)
	{
		#randomly select a domain
		my $rand_domain = random_line('domain_list.txt');
		#randomly generated a string by using regular expression 
		my $email_addr = random_regex('[a-z0-9_]{4,11}')."@".$rand_domain;
		print OUTPUT "$email_addr";
	}
	
	close OUTPUT;
}
else
{
	print "proper command: genEmails.pl file_name.txt #_of_emails\n";
	exit -1;
}