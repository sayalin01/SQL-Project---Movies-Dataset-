-- SQL Project to analyse the Movies dataset available with various tables 
-- Using the SQL queries for Data Manipulation 


-- Creating the Database
create database sql_projects;

-- Using the database
use sql_projects;

-- Exploring all the available tables 
select * from actor;  
select * from cast; 
select * from director;
select * from genres;
select * from movie;  
select * from movie_direction; 
select * from movie_genres;
select * from ratings;
select * from reviewer;

# Below are the queries that are written to get insights from the datasets

-- Q1.  Write a query where it should contain all the data of the 
-- movies which were released after 1995 having their movie
-- duration greater than 120 and should be including A in their
-- movie title.

select * from movie 
where mov_year > 1995 
and mov_time > 120
and mov_title like '%a%';

-- Q2. Write an SQL query to find the actors who played a role in the 
-- movie 'Chinatown'. Fetch all the fields of actor table. (Hint: Use 
-- the IN operator)

select a.act_id , a.act_fname ,a.act_lname, a.act_gender , m.mov_title
from actor as a
inner join cast as c on a.act_id = c.act_id
inner join movie as m on c.mov_id = m.mov_id
where mov_title in ('Chinatown') 
group by 1;


select act_id , act_fname , act_lname ,act_gender from actor where act_id in
(select act_id from cast where mov_id in 
(select mov_id from movie where mov_title = 'Chinatown'));

-- Q3. Write an SQL query for extracting the data from the ratings 
-- table for the movie who got the maximum number of ratings.

select m.mov_title, max(r.num_o_ratings) as max_ratings 
from movie as m
inner join ratings as r on m.mov_id = r.mov_id
group by 1
order by 2 desc;

-- Q4. Write an SQL query to determine the Top 7 movies which were 
-- released in United Kingdom. Sort the data in ascending order 
-- of the movie year.

select mov_id, mov_title, mov_year, mov_time, mov_lang, mov_dt_rel, mov_rel_country 
from movie where mov_rel_country ='UK' 
order by 3 limit 7;


-- Q5. Set the language of movie language as 'Chinese' for the movie 
-- which has its existing language as Japanese and their movie 
-- year was 2001.
update movie set mov_lang='Chinese' where mov_lang='Japanese' and mov_year=2001;

select * from movie;
update movie
set mov_lang = 'Chinese'
where  mov_year = 2001 and mov_lang = 'Japanese' ;
set sql_safe_updates =0;

-- Q6. Print genre title, maximum movie duration and the count the 
-- number of movies in each genre

select g.gen_title, max(m.mov_time)as max_duratn, count(m.mov_title) as movies_count
from movie as m
inner join movie_genres as mg on m.mov_id = mg.mov_id
inner join genres as g on mg.gen_id = g.gen_id
group by 1;

select g.gen_title , max(m.mov_time) as max_duration, count(m.mov_id) as movie_count
from genres as g 
left join movie_genres as mg on(g.gen_id = mg.gen_id)
left join movie as m on(mg.mov_id = m.mov_id)
group by 1
order by 3 desc;

-- Q7. Create a view which should contain the first name, last name, 
-- title of the movie & role played by particular actor.

create view movie_details as (
select a.act_fname, a.act_lname, m.mov_title, c.role as role_played
from actor as a 
inner join cast as c on(a.act_id = c.act_id)
inner join movie as m on(m.mov_id = c.mov_id));

-- Q8. Display the movies that were released before 31st March 1995.
select * from movie where mov_dt_rel < '1995-03-31' ;
select * from movie where mov_dt_rel <'31/03/1995';
select * from movie where mov_dt_rel < '31-03-1995';

-- Q9. Write a query which fetch the first name, last name & role 
-- played by the actor where output should all exclude Male 
-- actors

select a.act_id, a.act_fname, a.act_lname, a.act_gender, c.role
from actor as a 
inner join cast as c on a.act_id = c.act_id
where act_gender != 'M';

-- Q10. Insert five rows into the cast table where the ids for movie 
-- should be 936,939,942,930,941 and their respective roles 
-- should be Darth Vader, Sarah Connor, Ethan Hunt, Travis 
-- Bickle, Antoine Doinel & their actor ids should be set up as 
-- 126,140,135,131,144.

insert into cast (mov_id, role,act_id) values
(936,'Darth Vader',126),
(939,'Sarah Connor',140),
(942,'ethan hunt',135),
(930,'Travis bickle',131),
(941,'Antoine Doinel',144);

-- Q11. From the following table, 
-- write a SQL query to find out who was cast in the movie 'Annie Hall'. 
-- Return actor first name, last name and role.

SELECT act_fname, act_lname, role
FROM actor
JOIN cast ON actor.act_id = cast.act_id
JOIN movie ON cast.mov_id = movie.mov_id AND movie.mov_title = 'Annie Hall';

-- Q12. From the following table,
-- write a SQL query to calculate the average movie length and count the number of movies in each genre.
-- Return genre title, average time and number of movies for each genre.
 
SELECT gen_title as Genre_title, AVG(mov_time) as avg_movie_time, COUNT(gen_title) as Genre_count
FROM movie
JOIN  movie_genres
JOIN  genres
GROUP BY gen_title
order by 2 desc;

-- Q13. From the following tables, write a SQL query to find the years when most of the ‘Mystery Movies’ produced.
-- Count the number of generic title and compute their average rating.
-- Group the result set on movie release year, generic title. 
-- Return movie year, generic title, number of generic title and average rating.

SELECT m1.mov_year, g1.gen_title as Genre_title, COUNT(g1.gen_title) as count, AVG(r1.rev_stars) as Avg_ratings
FROM movie m1
JOIN movie_genres mg1 ON m1.mov_id = mg1.mov_id
JOIN genres g1 ON mg1.gen_id = g1.gen_id
JOIN ratings r1 ON m1.mov_id = r1.mov_id
JOIN movie m2 ON m1.mov_year = m2.mov_year
JOIN movie_genres mg2 ON m2.mov_id = mg2.mov_id
JOIN genres g2 ON mg2.gen_id = g2.gen_id
WHERE g1.gen_title = 'Mystery' 
      AND g2.gen_title = 'Mystery'
GROUP BY m1.mov_year, g1.gen_title;

-- Q14. From the following table, write a SQL query to find the directors who have directed films in a variety of genres. 
-- Group the result set on director first name, last name and generic title. 
-- Sort the result-set in ascending order by director first name and last name. 
-- Return director first name, last name and number of genres movies.

SELECT d.dir_fname, d.dir_lname, g.gen_title, COUNT(g.gen_title)
FROM director d
JOIN movie_direction md ON d.dir_id = md.dir_id
JOIN movie_genres mg ON md.mov_id = mg.mov_id
JOIN genres g ON mg.gen_id = g.gen_id
GROUP BY d.dir_fname, d.dir_lname, g.gen_title
ORDER BY d.dir_fname, d.dir_lname;

select * from actor; 
select * from cast;
select * from director;
select * from genres;
select * from movie;
select * from movie_direction;
select * from movie_genres;
select * from ratings;
select * from reviewer;





