##
# Creates the daily_count table and update the table with
# daily count of email addresses by their domain name
##

use strict;
use warnings;

use GUI::DB qw(dbConnect query);

#
#Check to see if the daily_count table exists
#		dailyTableExists($dbh)
#
sub dailyTableExists
{
	my $dbh = shift;
    my $sth;
	
	$sth = $dbh -> table_info("", "", "daily_count", "TABLE");
	
	if ($sth->fetch) {
		return 1;
	} else {
		return 0;
	}

}

my $dbh = dbConnect();
my $sql;

#create the daily_count table if it doesn't exist
#the TRIGGER modifies the Registered date format to show date only (w/o time displayed)
if (!dailyTableExists($dbh))
{
    $sql = "CREATE TABLE daily_count 
			(
                Domain VARCHAR(255) NOT NULL,
                Addr_daily_count INT,
                Date DATE,
				CONSTRAINT PK_Domain_date PRIMARY KEY (Domain, Date)
			)";
	query($dbh, $sql);
		
	print "TABLE: daily_count CREATED.\n";
	
	$sql = "CREATE 
				TRIGGER daily_count_before_insert
				BEFORE INSERT
				ON daily_count FOR EACH ROW
				SET NEW.Date = CURDATE()";
	query($dbh, $sql);
}

#grab data from mailing table
#each returning data is a reference to a hash containing 
#field name ("addr") and field value pairs
$sql = "SELECT * FROM mailing";
my @emails = query($dbh, $sql); #hashed *need to dereference it*

#Domain and Daily_count would store in this hash variable as pairs of (key/value)
#(Domains, Daily_count)
my %domainCount;

#print $emails[0]->{'addr'};  or  print $emails[0]->{addr}; quote is not necessary

#use the first matching pattern $1 which is domain here as the key
#and counting them by incrementing the value of these keys
foreach(@emails){
    if ($_->{'addr'} =~ /@(\w+.*)/){
        $domainCount{$1}++;  
    }
}

#sql statement of the placeholder for bindValues
my $placeholder = join (', ', ("(?,?)") x scalar(keys(%domainCount)));

#insert the counted data into the corresponding columns
$sql = "INSERT INTO daily_count (Domain, Addr_daily_count) VALUES $placeholder";
query($dbh, $sql, %domainCount);

$dbh->disconnect();