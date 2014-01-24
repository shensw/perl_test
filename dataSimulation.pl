#simulating the 50 days process

use strict;
use warnings;

use GUI::DB qw(dbConnect query);

#check whether the table exists
sub TableExists
{
	my $dbh = shift;
	my $table = shift;
    my $sth;
	
	$sth = $dbh -> table_info("", "", "$table", "TABLE");
	
	if ($sth->fetch) {
		return 1;
	} else {
		return 0;
	}
}

my $table1 = "mailing";
my $table2 = "daily_count";

my $fillsMail = "fillsMail.pl";
my @input_data = ("2013-05-01.txt", "2013-05-02.txt", "2013-05-03.txt", "2013-05-04.txt", "2013-05-05.txt",
				  "2013-05-06.txt", "2013-05-07.txt", "2013-05-08.txt", "2013-05-09.txt", "2013-05-10.txt",
				  "2013-05-11.txt", "2013-05-12.txt", "2013-05-13.txt", "2013-05-14.txt", "2013-05-15.txt",
				  "2013-05-16.txt", "2013-05-17.txt", "2013-05-18.txt", "2013-05-19.txt", "2013-05-20.txt",
				  "2013-05-21.txt", "2013-05-22.txt", "2013-05-23.txt", "2013-05-24.txt", "2013-05-25.txt",
				  "2013-05-26.txt", "2013-05-27.txt", "2013-05-28.txt", "2013-05-29.txt", "2013-05-30.txt",
				  "2013-05-31.txt", "2013-06-01.txt", "2013-06-02.txt", "2013-06-03.txt", "2013-06-04.txt",
				  "2013-06-05.txt", "2013-06-06.txt", "2013-06-07.txt", "2013-06-08.txt", "2013-06-09.txt",
				  "2013-06-10.txt", "2013-06-11.txt", "2013-06-12.txt", "2013-06-13.txt", "2013-06-14.txt",
				  "2013-06-15.txt", "2013-06-16.txt", "2013-06-17.txt", "2013-06-18.txt", "2013-06-19.txt");
my $updateDaily = "updateDaily.pl";

my $dbh = dbConnect();
my $sql;
my $sth;

#RESET DATABASE
if(TableExists($dbh, $table1))
{
	$sql = "TRUNCATE TABLE mailing";
	query($dbh, $sql);
}

if(TableExists($dbh, $table2))
{
	$sql = "DROP TABLE daily_count";
	query($dbh, $sql);
}

#simulatiing day by day process
# -> fill the mailing table 
# -> update the daily_count table 
# -> manually change the daily count date for simulation 
# -> truncate the mailing table
foreach(@input_data)
{
	system("$fillsMail $_");
	system("$updateDaily");


	my $simulate_date = substr($_,  0,10);
	$sql = "UPDATE daily_count
			SET Date = '$simulate_date'
			WHERE Date = CURDATE()";

	query($dbh, $sql);
	
	$sql = "TRUNCATE TABLE mailing";
	query($dbh, $sql);
	
	print "$simulate_date done\n";
}
$dbh->disconnect;
