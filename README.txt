
#METHOD 1:
update_Daily.pl (this method works for real-time usage, but for simulation purpose, I have to truncate the mailing table after updating the data on the new table)

the script creates the daily_count table and update the table with 
daily count of email addresses by their domain name



#METHOD 2
update_Daily_complex.pl (my PC runs out of RAM after the mailing table goes over 10,500,000 mails, not a practical solution I think)

Assuming the "mailing" table will not be emptied after each day,
The number of new daily count is calculated by the difference between "total daily counts" and "current daily counts"
if a domain is already existed in the current daily_count table
   
     new_daily_count = total_daily_count - current_daily_count 

if the difference is 0 means no new entries on this particular domain
otherwise, the domain would be inserted into the table along with it's daily count
therefore the script will not take duplicate daily counts into account. 

NOTE: this method runs quite slow as the mailing table grows (if we can empty the mailing table daily, the performance will be much faster)





daily inputs simulation: