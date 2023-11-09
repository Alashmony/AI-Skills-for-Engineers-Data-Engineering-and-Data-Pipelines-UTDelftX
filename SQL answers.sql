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

