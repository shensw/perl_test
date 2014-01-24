#fills up the "mailing" table with emails from a file given

use strict;
use warnings;
use GUI::DB qw(dbConnect query);

if ($ARGV[0])
{
    my $emails_file = $ARGV[0];
    my $dbh = dbConnect();


    #Getting emails list from the file
    open (MAILF, $emails_file) or die "\nERROR: Cannot open specified file: $!\n";
    my @emails = <MAILF>;
    close MAILF;
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
    print "\nproper command: fillsMail.pl emails_file\n";
    exit -1;
}