#fills up the "mailing" table with emails from a file given

use strict;
use warnings;
use GUI::DB qw(dbConnect query);

if ($ARGV[0])
{
    my $emails_file = $ARGV[0];
    my $dbh = dbConnect();


    #grab emails from the daily input files
    open (INPUT, $emails_file) or die "Couldn't open file $emails_file, $!";
    my @emails = <INPUT>;
    close INPUT;
	#removes any trailing string that corresponds to the current value of $/(new line character)
    chomp(@emails);

	#sql statement of the placeholder for bindValues
    my $placeholder = join (', ', ("(?)") x scalar(@emails));
	
	#insert emails addresses into the table
    my $sql = "INSERT INTO mailing VALUES $placeholder";
    query($dbh, $sql, @emails);

    $dbh->disconnect;
}
else
{
    print "proper command: fillsMail.pl emails_file\n";
    exit -1;
}