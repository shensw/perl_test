#report the top 50 domains by count 
#sorted by percentage growth of the last 30 days compared to the total

use strict;
use warnings;
use GUI::DB qw(dbConnect query);


#grab the top 50 domains by count from daily_count table
#		@return_array =	Top50byCount($dbh)
sub Top50byCount
{
	my $dbh = shift;
	my $sql = "SELECT Domain, SUM(Addr_daily_count) as Total FROM daily_count 
			   GROUP BY Domain
			   ORDER BY Total
			   DESC LIMIT 50";
	return my @top50_domains = query($dbh, $sql);
}

#Calculate the percentage growth of the last 30 days compared to the total
#attach the result as a new column to the input array of top 50 domain by count
#		 @result = GrowthRate($dbh, @top50)
#from what I understand it is calculated by: 
#--------------------For each domain--------------------
#sum_thirty_days = sum of the daily count of last 30 days
#          total = all the domain counts up to date
#           RATE = (total - sum_thirty_days) / sum_thirty_days * 100
sub GrowthRate
{
	my $dbh = shift;
	my @top50 = @_;

	foreach(@top50)
	{
		#simulation purpose use '2013-06-19' instead of CURDATE()
		my $sql = "SELECT SUM(Addr_daily_count) as Thirty_day_counts FROM daily_count
				   WHERE Domain = ? 
				   AND Date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)";
				   
		my @sum_hashref = query($dbh, $sql, $_->{'Domain'});
		my $sum_thirty_days = $sum_hashref[0]{'Thirty_day_counts'};
		
		#insert the 'percentage growth rate' into the top 50 array as a new column in hash format
		$_->{'Growth_rate'} = ($_->{'Total'} - $sum_thirty_days) / $sum_thirty_days * 100;
		#printf "%.1f \n", $_->{'Growth_rate'};
	}	
	
	return @top50;
}


my $dbh = dbConnect();
my $sql;

#grab the top 50 domains by count
my @top50 =	Top50byCount($dbh);
#Calculate the percentage growth
my @result = GrowthRate($dbh, @top50);

#sort numerically ascending by percentage growth
@result = sort { $b->{Growth_rate} <=> $a->{Growth_rate} } @result;

#output the result
printf "+-------------------------+-------------+----------+\n";
printf "|          Domain         | Total count | %% Growth |\n";
printf "+-------------------------+-------------+----------+\n";

foreach(@result)
{
	printf "| %-24s|    %-8s |   %.1f   |\n", $_->{'Domain'}, $_->{'Total'}, $_->{'Growth_rate'};
}

printf "+-------------------------+-------------+----------+\n";

$dbh->disconnect();
