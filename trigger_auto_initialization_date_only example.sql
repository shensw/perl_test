CREATE TABLE daily_count 
			(
				ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
                Domain VARCHAR(255) NOT NULL,
                Addr_daily_count INT,
                Registered_date DATE
			);

			
/*
The statement following FOR EACH ROW defines the trigger body; 
that is, the statement to execute each time the trigger activates, 
which occurs once for each row affected by the triggering event.
*/
CREATE TRIGGER daily_count_before_insert
BEFORE INSERT
ON daily_count
FOR EACH ROW
SET NEW.Registered_date = CURDATE();


insert into daily_count (Domain, Addr_daily_count) VALUES ("hello.com", 15);

update daily_count
set Registered_date = "2013-05-01"
where Registered_date = "2014-01-20";