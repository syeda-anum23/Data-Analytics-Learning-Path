select * from books;
alter table books
rename column MyUnknownColumn to book_id;

select * from launches;
alter table launches
rename column MyUnknownColumn to launch_id;

select * from dim_date;

												-- Top 10 expensive books
select title, price "Expensive Books" 
from books
order by price desc
limit 10;

										-- Success rate of launches by year
select year(date_utc) 'Launch Year', sum(case when success = 1 then 1 else 0 end) 'Success Rate', 
count(*) 'Total Launches',   ROUND(SUM(success = 1) * 100.0 / COUNT(*), 2) AS success_rate
from launches
group by year(date_utc)
order by `Success Rate` desc;

									-- Running total launches (window function)
select year(l.date_utc) as Year, count(l.launch_id) as Launches,
sum(count(l.launch_id)) over (order by year(l.date_utc) desc) as 'Running Total'
from launches l
where year(date_utc)>2010
group by year(l.date_utc);

										-- CTE: launches with last rocket used
with launch_rocket as (
select rocket, date_utc
from launches
order by date_utc desc
limit 1
)
select * from launch_rocket;

											-- Average price by rating
select avg(price), rating
from books
group by rating
order by rating desc;

											-- Most available books
select title, availability
from books
order by availability desc
limit 10;

										-- Average availability by rating
select avg(availability), rating
from books
group by rating
order by rating desc;

											-- Price distribution by rating
select rating, avg(price) as 'Average Price', count(*) as 'Number of books' 
from books 
group by rating
order by rating desc;

											-- Cheapest vs most expensive book per rating
select max(price) as Expensive, min(price) as Cheapest, rating
from books
group by rating
order by rating desc;

											-- Count of books by rating
select count(title) as 'Books Count', rating
from books
group by rating
order by rating desc;

												-- Most used rockets.
select name, count(*) as Rockets
from launches
group by name
order by `Rockets` desc;