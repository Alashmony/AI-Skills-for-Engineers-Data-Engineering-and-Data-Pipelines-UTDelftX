-- create the DB 
--import database 'D:\Courses\edx\db'

CREATE TABLE titles_genres(title_id VARCHAR, genre VARCHAR, PRIMARY KEY(title_id, genre));
CREATE TABLE episodes(episode_id VARCHAR UNIQUE, series_id VARCHAR, season_no SMALLINT, episode_no INTEGER, PRIMARY KEY(episode_id, series_id));
CREATE TABLE persons(person_id VARCHAR PRIMARY KEY UNIQUE, full_name VARCHAR, birth_year SMALLINT, death_year SMALLINT);
CREATE TABLE ratings(title_id VARCHAR PRIMARY KEY UNIQUE, avg_rating FLOAT, num_votes INTEGER);
CREATE TABLE title_person_character(title_id VARCHAR, person_id VARCHAR, character_name VARCHAR, PRIMARY KEY(title_id, person_id, character_name));
CREATE TABLE titles(title_id VARCHAR PRIMARY KEY UNIQUE, title_type VARCHAR, primary_title VARCHAR, original_title VARCHAR, start_year INTEGER, end_year INTEGER, runtime INTEGER);
CREATE TABLE cast_info(title_id VARCHAR, person_id VARCHAR, job_category VARCHAR, PRIMARY KEY(title_id, person_id, job_category));
CREATE TABLE persons_professions(person_id VARCHAR, profession VARCHAR, FOREIGN KEY (person_id) REFERENCES persons(person_id), PRIMARY KEY(person_id, profession));


COPY titles_genres FROM 'D:\Courses\edx\db\titles_genres.csv' (FORMAT 'csv', header 0, delimiter ',', quote '"');
COPY episodes FROM 'D:\Courses\edx\db\episodes.csv' (FORMAT 'csv', header 0, delimiter ',', quote '"');
COPY persons FROM 'D:\Courses\edx\db\persons.csv' (FORMAT 'csv', header 0, delimiter ',', quote '"');
COPY ratings FROM 'D:\Courses\edx\db\ratings.csv' (FORMAT 'csv', header 0, delimiter ',', quote '"');
COPY titles FROM 'D:\Courses\edx\db\titles.csv' (FORMAT 'csv', header 0, delimiter ',', quote '"');
COPY persons_professions FROM 'D:\Courses\edx\db\persons_professions.csv' (FORMAT 'csv', header 0, delimiter ',', quote '"');
COPY cast_info FROM 'D:\Courses\edx\db\cast_info.csv' (FORMAT 'csv', header 0, delimiter ',', quote '"');
COPY title_person_character FROM 'D:\Courses\edx\db\title_person_character.csv' (FORMAT 'csv', header 0, delimiter ',', quote '"');

create index person_id_index_tpc
    on title_person_character (person_id);

create index character_name_index
    on title_person_character (character_name);


create index title_id_index_tpc
    on title_person_character (title_id);

   
--drop index person_id_index_tpc;
--drop index character_name_index;
--drop index title_id_index_tpc;
   
create index full_name_index
    on persons (full_name);


create index person_id_idx_persons
    on persons (person_id);


create index original_title_index
    on titles (original_title);


create index primary_title_index
    on titles (primary_title);


create index title_id_index_tg
    on titles_genres (title_id);

   
   create index episode_id_index
    on episodes (episode_id);


create index series_id_index
    on episodes (series_id);

   
create index person_id_index
    on cast_info (person_id);


create index title_id_index
    on cast_info (title_id);



SELECT full_name FROM persons;

SELECT full_name FROM persons LIMIT 5;

SELECT * FROM titles AS t WHERE t.primary_title='The Matrix'

SELECT * FROM titles AS t
WHERE t.primary_title  LIKE 'Star Wars%' and t.title_type = 'movie'
ORDER BY t.start_year


SELECT * FROM titles AS t WHERE t.title_id ='tt0076759'

SELECT t.primary_title, r.avg_rating, r.num_votes
FROM titles AS t JOIN ratings AS r ON t.title_id=r.title_id
WHERE
t.title_type='movie' AND t.start_year = 2021 AND r.num_votes > 10000
ORDER BY r.avg_rating DESC
LIMIT 100


SELECT t.start_year, AVG(r.avg_rating) as average_rating , COUNT(r.avg_rating) as number_of_movies
FROM titles AS t JOIN ratings AS r ON t.title_id=r.title_id
WHERE
t.title_type='movie' AND r.num_votes > 10000
GROUP BY t.start_year
ORDER BY t.start_year DESC


---------------------------------Assignments ----------------------------------------------------------
-- Write a query which lists all names (>”primary title”) of all titles released in 1999

select primary_title  
from main.titles 
where start_year = 1999


select DISTINCT title_type from titles

select * from main.titles 

--Write a query which returns the number of movies (not tv shows, etc) released in 2021
select count(DISTINCT t.original_title) number_of_movies 
from main.titles t
where title_type in ('tvMovie', 'movie') and start_year = 2021


--Write a query which counts all movies released in the 2000s (i.e., from 2000 to 2009).

select count(distinct primary_title) num_titles
from main.titles 
where title_type in ('tvMovie', 'movie')  and start_year BETWEEN 2000 and 2009

--Write a query which lists all title types (e.g, movie, tvShow, etc) found in the database.
select DISTINCT title_type from titles

--Write a query which creates a statistic, counting how many titles of each type were released in 2021.

select title_type, count(*) titles_count 
from titles t
group by 1

--List all years (without duplicates) when a title containing the words “Star Wars” in its primary title was/will be introduced, and sort them in increasing order.

select DISTINCT t.start_year 
from main.titles t
where lower(primary_title) like '%star wars%'
order by 1

-- Create a statistic, listing all years in which a Star Wars video
-- game (e.g, video game with Star Wars somewhere in its primary title) was released,
-- and count the number of games for those years.  Order by year.

--Query shows all games created in this year
with sw_years as (select DISTINCT t.start_year 
from main.titles t
where lower(primary_title) like '%star wars%' and t.title_type = 'videoGame')
select t.start_year, count(*) games_released
from main.titles t
inner join sw_years sw on t.start_year = sw.start_year
where t.title_type = 'videoGame'
GROUP by 1
ORDER by 1

--Query shows star wars games in each year
select  t.start_year, count(*) games_released
from main.titles t
where lower(primary_title) like '%star wars%' and t.title_type = 'videoGame' 
GROUP by 1
order by 1

--Write a query which finds all persons which are involved with the “The Matrix” movie.  
--List their full name and job, e.g.: “Keanu Reeves, actor”. Order by their full name

select DISTINCT p.full_name 
from main.persons p
inner join main.cast_info c on c.person_id = p.person_id 
inner join main.titles t on t.title_id = c.title_id 
where lower(t.original_title) = 'the matrix' and t.title_type in ('movie', 'tvMovie') 
order by 1

SELECT * from main.cast_info 

-- List all information about TV show episodes (title_type = ‘tvEpisode’)
-- produced (job_category = ‘producer’) by ‘Ridley Scott’, 
-- sorted by descending start year. Show only the first 5 results.

select * 
from main.titles t
join main.cast_info c on t.title_id = c.title_id 
join main.persons p on c.person_id = p.person_id 
where p.full_name = 'Ridley Scott' and job_category = 'producer' and t.title_type = 'tvEpisode'
order by t.start_year DESC 
limit 5

-- List the distinct names (primary_title) of all series which have at least 100 episodes.

select primary_title, count(e.episode_id) episodes_count
from main.titles t
join main.episodes e on e.series_id = t.title_id 
GROUP BY 1
HAVING count(e.episode_id) >= 100

-- Write a query which exports the primary tittle and average rating of all movies released in 2021 into a CSV file.

COPY (
select t.primary_title , r.avg_rating 
from main.titles t
join main.ratings r on t.title_id = r.title_id  
where t.start_year = 2021 and t.title_type in ('movie', 'tvMovie')) to 'D:\Courses\edx\ratings.csv' (HEADER, DELIMETER ',');

