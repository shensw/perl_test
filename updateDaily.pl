Given a table 'mailing':

CREATE TABLE mailing (
	addr VARCHAR(255) NOT NULL
);

The mailing table will initially be empty.  New addresses will be added on a daily basis.  It is expected that the table will store at least 10,000,000 email addresses and 100,000 domains.

Write a perl script that updates another table which holds a daily count of email addresses by their domain name.

Use this table to report the top 50 domains by count sorted by percentage growth of the last 30 days compared to the total.

** NOTE **
- You MUST use the provided DB.pm for all database interaction, and you must use it as it is (DB.pm cannot be modified except for the connection settings).

- The original mailing table should not be modified.

- All processing must be done in Perl (eg. no complex queries or sub-queries)

- Submit a compressed file(tar/zip) with the files required to run your script.
                                                                                                                				BEFORE INSERT
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