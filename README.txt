Running and testing Environment: 
Windows 7 professional SP1 64 bit
MySQL Community Server (GPL) 5.6.15 
Perl v5.16.3

1.    genEmails.pl (genEmail_slow.pl - used a slightly different algorithm module, quite slow)
#randomly generates a number of email addresses by regular expression base on a given domain list
#used for preparation of the inputs
#takes 2 arguments: output file name, # of emails needs to be generated

2.    gen_emails_daytoday.bat
#generate 50 days of emails, day by day (2013-05-01 to 2013-06-19) for simulation, 250,000 per day, base on the 100,000 domains in the "domain_list.txt" file.
#total = 12,500,000 email addresses to meet the requirement

3.    dataSimulation.pl
#SIMULATE the real time day by day usage of the 50 days data by:
3.1   fillsMail.pl
# -> fill the mailing table 
3.2   updateDaily.pl (updateDaily_complex.pl)
# -> update the daily_count table 
# -> manually change the daily count date for simulation 
# -> truncate the mailing table

*** The last 2 steps are required for day by day process simulation only, in real time usage, it could be omitted***

3.2 METHOD 1:
update_Daily.pl (this method works for real-time usage, but for simulation purpose, I have to truncate the mailing table after updating the data on the new table)

the script creates the daily_count table and update the table with 
daily count of email addresses by their domain name

3.2 METHOD 2:
update_Daily_complex.pl (my PC runs out of RAM after the mailing table goes over 10,500,000 mails, not a practical solution I think)

Assuming the "mailing" table will not be emptied after each day,
The number of new daily count is calculated by the difference between "total daily counts" and "current daily counts"
if a domain is already existed in the current daily_count table
   
     new_daily_count = total_daily_count - current_daily_count 

if the difference is 0 means no new entries on this particular domain
otherwise, the domain would be inserted into the table along with it's daily count
therefore the script will not take duplicate daily counts into account. 

NOTE: this method runs quite slow as the mailing table grows (if we can empty the mailing table daily, the performance will be much faster)


4    reportTop50.pl
#report the top 50 domains by count 
#sorted by percentage growth of the last 30 days compared to the total
#--------------------For each domain--------------------
#sum_thirty_days = sum of the daily count of last 30 days
#          total = all the domain counts up to date
#           RATE = (total - sum_thirty_days) / sum_thirty_days * 100


output is saved as a txt file: reportTop50.pl > output.txt

NOTE: the actual simulated input data is not included in the submission due to its size