-- MySQL Homework --

use sakila;

-- 1a. Display the first and last names of all actors from the table actor 

select first_name, last_name 
from actor;

-- 1b. Display the first and last name of each actor in a single column in 
-- upper case letters. Name the column Actor Name. 

select concat(first_name, ' ', last_name)
as 'ACTOR NAME' 
from actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, 
-- of whom you know only the first name, "Joe." What is one query would you use 
-- to obtain this information?

select actor_id, first_name, last_name 
from actor
where first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN

select actor_id, first_name, last_name
from actor
where last_name like '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. 
-- This time, order the rows by last name and first name, in that order.

select actor_id, last_name, first_name
from actor
where last_name like '%LI%';

-- 2d. Using IN, display the country_id and country columns of the 
-- following countries: Afghanistan, Bangladesh, and China.

select country_id, country
from country
where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. 
-- You don't think you will be performing queries on a description, 
-- so create a column in the table actor named description and use the data type BLOB 
-- (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).

alter table actor
add column description blob after first_name;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. 
-- Delete the description column.

alter table actor drop column description;

 -- 4a. List the last names of actors, as well as how many actors have 
 -- that last name.

 select last_name
 count(*) as count from actor 
 group by last_name;
 
 -- 4b. List last names of actors and the number of actors who have 
 -- that last name, but only for names that are shared by at least two actors.

 select last_name
 count(*) as count from actor
 group by last_name
 having count (last_name) > 2;

 -- 4c. The actor HARPO WILLIAMS was accidentally entered in 
 -- the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's 
 -- husband's yoga teacher. Write a query to fix the record.

 update actor
 set first_name = 'Harpo' 
 where first_name = 'Groucho' 
 and last_name = 'Williams' 

 -- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns 
 -- out that GROUCHO was the correct name after all! In a single query, if 
 -- the first name of the actor is currently HARPO, change it to GROUCHO. 
 -- Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what 
 -- the actor will be with the grievous error. 

 update actor
 set first_name = if(first_name = 'Harpo', 'Groucho', 'Mucho Groucho')
 where actor_id = 172

 -- 5a. You cannot locate the schema of the address table. Which query would 
 -- you use to re-create it?

 show create table sakila.address

 -- 6a. Use JOIN to display the first and last names, as well as the address, of 
 -- each staff member. 

 select staff.first_name, 
	    staff.last_name, 
	    address.address, 
from staff
inner join address
using (address_id);

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. 

select staff.first_name, 
	   staff.last_name, 
	   sum(payment.amount)
from staff
inner join payment
using (staff_id)
where payment_date between '2005-08-01' and '2005-08-31'
group by staff.staff_id
order by staff.last_name;

-- 6c. List each film and the number of actors who are listed for that film. 

select film.title, 
	   count(film_actor.actor_id)
from film
inner join film_actor
using (film_id)
group by film.title
order by film.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

select count(inventory_id)
from inventory
where film_id in (
	select film_id
    from film
    where title = 'Hunchback Impossible'
);

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
-- List the customers alphabetically by last name.

select customer.first_name, 
	   customer.last_name, 
	   sum(payment.amount)
from customer
inner join payment
using (customer_id)
group by customer_id
order by customer.last_name;

--7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q have also 
-- soared in popularity. Use subqueries to display the titles of movies starting with 
-- the letters K and Q whose language is English.

select title from film
where film_id in (
	select film_id from film
	where title like 'Q%'
	or title like 'K%'
	and language_id = 1
);

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.

select first_name, last_name from actor
where actor_id in (
	select actor_id 
    from film_actor
    where film_id in (
		select film_id
		from film
		where title = 'Alone Trip'
    )
);

-- 7c. You want to run an email marketing campaign in Canada, for which you will 
-- need the names and email addresses of all Canadian customers. 

select customer.first_name, 
	   customer.last_name, 
       customer.email
from customer
inner join address
using (address_id)
    inner join city
    using (city_id)
        inner join country
        using (country_id)
        where country.country = 'Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all 
-- family movies for a promotion. Identify all movies categorized as famiy films.

select title from film
where film_id in (
	select film_id
    from film_category
    where category_id in (
		select category_id
        from category
        where name = 'family'
	)
);

-- 7e. Display the most frequently rented movies in descending order.

select film.film_id, 
       film.title,
       count(rental.inventory_id) as NumRents
from rental 
inner join inventory 
using (inventory_id)
	inner join film 
	using (film_id)
group by film.film_id, film.title
order by NumRents desc;

-- 7f. Write a query to display how much business, in dollars, each store brought in.

select store.store_id, 
	   sum(payment.amount)
from store
inner join customer
using (store_id)
	inner join payment
	using (customer_id)   
group by store.store_id
order by store.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.

select store.store_id,
	   city.city, 
	   country.country
from store
inner join address
using (address_id)
	inner join city
	using (city_id)
		inner join country
		using (country_id)
group by store.store_id
order by store.store_id;

-- 7h. List the top five genres in gross revenue in descending order. 

select category.name, 
	   sum(payment.amount)
from payment
inner join rental
using (rental_id)
	inner join inventory
    using (inventory_id)
		inner join film_category 
        using (film_id)
			inner join category
			using (category_id)
group by category.name
order by sum(payment.amount) desc
limit 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the 
-- top five genres by gross revenue. Use the solution from the problem above to create a view. 

create view TopRevenueByCategory as 
select category.name, 
	   sum(payment.amount)
from payment
inner join rental
using (rental_id)
	inner join inventory
    using (inventory_id)
		inner join film_category 
        using (film_id)
			inner join category
			using (category_id)
group by category.name
order by sum(payment.amount) desc
limit 5;

-- 8b. How would you display the view that you created in 8a?

select * from TopRevenueByCategory;

-- 8c. You find that you no longer need the view TopRevenueByCategory. Write a query to delete it.

drop view TopRevenueByCategory;