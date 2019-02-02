use sakila;

#1a. Display the first and last names of all actors from the table actor.
select first_name, last_name
from actor;

#1b. Display the first and last name of each actor in a single column in upper case letters. 
# Name the column Actor Name
select concat_ws(' ', first_name, last_name)
as "Actor Name"
from actor;

#2a. You need to find the ID number, first name, and last name of an actor, 
#of whom you know only the first name, "Joe."
#What is one query would you use to obtain this information?
select actor_id, first_name, last_name
from actor
where first_name = "Joe";

#2b. Find all actors whose last name contain the letters GEN
select * 
from actor
where last_name like "%GEN%";

#2c. Find all actors whose last names contain the letters LI.
#This time, order the rows by last name and first name, in that order:
select *
from actor
where last_name like "%LI%"
order by last_name, first_name;

#2d. Using IN, display the country_id and country columns of the following countries: 
#Afghanistan, Bangladesh, and China
select country_id, country
from country
where country IN ("Afghanistan", "Bangladesh", "China");

#3a. You want to keep a description of each actor. 
#You don't think you will be performing queries on a description, 
#so create a column in the table actor named description and use the data type BLOB
alter table actor
add column description BLOB;

#3b. Very quickly you realize that entering descriptions for each actor is too much effort. 
#Delete the description column.
alter table actor
drop column description;

