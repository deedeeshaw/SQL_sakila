use sakila;

#1a. Display the first and last names of all actors from the table actor.
select first_name, last_name
from actor;

#1b. Display the first and last name of each actor in a single column in upper case letters. 
# Name the column Actor Name
select upper(concat_ws(' ', first_name, last_name))
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

#4a. List the last names of actors, as well as how many actors have that last name.
select last_name as "Last Name", count(last_name) as "# of Actors"
from actor
group by last_name;

#4b. List last names of actors and the number of actors who have that last name, 
#but only for names that are shared by at least two actors
select last_name as "Last Name", count(*) as "# of Actors"
from actor
group by last_name 
having count(*) >=2
;

#4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
#Write a query to fix the record.

update actor
set first_name = "HARPO"
where first_name = "GROUCHO" and last_name = "WILLIAMS";


# 4d. Perhaps we were too hasty in changing GROUCHO to HARPO.
# It turns out that GROUCHO was the correct name after all! 
#In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO
update actor
set first_name = "GROUCHO"
where first_name = "HARPO" and last_name = "WILLIAMS";


#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
show create table address;
-- copy and paste the CREATE TABLE

#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. 
#Use the tables staff and address:
select concat_ws(' ', first_name, last_name) as "Staff Member", address as "Address"
from staff s
join address a
where s.address_id = a.address_id;

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. 
#Use tables staff and payment.
select concat_ws(' ', first_name, last_name) as "Staff Member", sum(amount) as "Total Amount"
from staff s
join payment p
where s.staff_id = p.staff_id and payment_date like "2005-08-%"
group by first_name;

#6c. List each film and the number of actors who are listed for that film.
#Use tables film_actor and film. Use inner join.
select title as "Title", count(actor_id) as "# of Actors"
from film f
join film_actor fa
where f.film_id = fa.film_id
group by title
;

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select count(inventory_id) as "# of Copies of Hunchback Impossible"
from inventory
where film_id IN(
select film_id
from film
where title = "Hunchback Impossible"
);

# 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
# List the customers alphabetically by last name:
select first_name as "Fist Name", last_name as "Last Name", sum(amount)
from customer c
join payment p
where c.customer_id = p.customer_id
group by c.customer_id
order by last_name;

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
#As an unintended consequence, films starting with the letters K and Q have also soared in popularity.
#Use subqueries to display the titles of movies
#starting with the letters K and Q whose language is English.

select title
from film
where title like "Q%" or title like "K%"
and language_id in(
select language_id
from language
where name = "English")
;

#7b. Use subqueries to display all actors who appear in the film Alone Trip.
select concat_ws(" ", first_name, last_name) as "Actors in Alone Trip"
from actor 
where actor_id in
(select actor_id -- 3,12,13,82,100,160,167,187
from film_actor
where film_id in
(select film_id -- 17
from film
where title = "Alone Trip"
))
;

#7c. You want to run an email marketing campaign in Canada, 
#for which you will need the names and email addresses of all Canadian customers. 
#Use joins to retrieve this information.

select 
	first_name, last_name, email, city, country
from customer cu
join address a on cu.address_id = a.address_id
join city c on a.city_id = c.city_id
join country on c.country_id = country.country_id
where country.country = "Canada" -- 20
;

#7d. Sales have been lagging among young families, 
# and you wish to target all family movies for a promotion. 
#Identify all movies categorized as family films.

select title
from film
where film_id in 
(select film_id
from film_category
where category_id in
(select category_id 
from category
where name = "Family" -- 8
))
;

#7e. Display the most frequently rented movies in descending order.
#select title 
#order by title desc

select title, rental_date
from rental
join inventory on rental.inventory_id = inventory.inventory_id
join film on film.film_id = inventory.inventory_id
order by rental_date desc
;

# 7f. Write a query to display how much business, in dollars, each store brought in.
select * from payment
group by staff_id;

select * from staff;

select store.store_id, sum(amount)
from store
join staff on store.store_id = staff.store_id
join payment on payment.staff_id = staff.staff_id
group by store_id
