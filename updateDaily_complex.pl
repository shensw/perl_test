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
#i.e. to dereference it: print $emails[0]->{'addr'}; 
$sql = "SELECT * FROM mailing";
my @emails = query($dbh, $sql);

#Domain and Daily_count would store in this hash variable as pairs of (key/value)
#(Domains, Daily_count)
my %new_domainCount;

#use the first matching pattern $1 which is domain here as the key
#and counting them by incrementing the value of these keys
foreach(@emails){
    if ($_->{'addr'} =~ /@(\w+.*)/){
        $new_domainCount{$1}++;  
    }
}

#grab current domain count in the daily_count table
#dereferencing it into an hash variable
#use to calculate the new daily domain count
$sql = "SELECT Domain, Addr_daily_count FROM daily_count";
my @curDcount = query($dbh, $sql);
my %cur_domainCount;

foreach(@curDcount)
{
	$cur_domainCount{$_->{'Domain'}} = $_->{'Addr_daily_count'};
}


#if the domain name is already existed in the current table
#take the difference between "new daily counts" and "current daily counts"
#  if the difference is 0 (means no new entries on this domain)
#  remove this entry
foreach(keys %cur_domainCount)
{
	$new_domainCount{$_} = $new_domainCount{$_} - $cur_domainCount{$_};
	if ($new_domainCount{$_} == 0)
		{
			delete $new_domainCount{$_};
		}
}

#update the daily_count table if there are new entries
if(%new_domainCount)
{
	#sql statement of the placeholder for bindValues
	my $placeholder = join (', ', ("(?,?)") x scalar(keys(%new_domainCount)));

	#insert the counted data into the corresponding columns
	$sql = "INSERT INTO daily_count (Domain, Addr_daily_count) VALUES $placeholder";
	query($dbh, $sql, %new_domainCount);
}

$dbh->disconnect();