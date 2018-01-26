
/************************************************* Question 1 ************************************************************/

/*1a. You need a list of all the actors who have Display the first and last names of all actors from the table actor.*/

USE sakila;

SELECT first_name, last_name 
FROM actor;


/*1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.*/

USE sakila;

SELECT CONCAT(UPPER(first_name), " ", UPPER(last_name)) as actor_name
FROM actor;

/************************************************* Question 2 ************************************************************/

/*2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe."
 What is one query would you use to obtain this information?*/
 
USE sakila;
 
SELECT actor_id, first_name, last_name 
	FROM actor
	WHERE first_name = "JOE";

/*2b. Find all actors whose last name contain the letters GEN:*/

USE sakila;
 
SELECT actor_id, first_name, last_name 
	FROM actor
	WHERE last_name like "%GEN%";

/*2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:*/

USE sakila;
 
SELECT actor_id, first_name, last_name 
	FROM actor
	WHERE last_name like "%LI%"
ORDER BY last_name, first_name;

/*2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:*/

SELECT *
	FROM country
	WHERE country in ("Afghanistan", "Bangladesh", "China");

/************************************************* Question 3 ************************************************************/

/*3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.*/

USE sakila;

ALTER TABLE actor ADD COLUMN middle_name CHAR(10) NULL AFTER first_name;

/*3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.*/

ALTER TABLE actor MODIFY middle_name blob;

/*3c. Now delete the middle_name column.*/

ALTER TABLE actor drop middle_name;


/************************************************* Question 4 ************************************************************/

/*4a. List the last names of actors, as well as how many actors have that last name.*/

USE sakila;

SELECT last_name, COUNT(actor_id) AS last_name_count
	FROM actor
	GROUP BY last_name;
 
/*4b. List last names of actors and the number of actors who have that last name, but only for names that are 
shared by at least two actors*/

SELECT last_name, COUNT(actor_id) AS last_name_count
	FROM actor
	GROUP BY last_name
	HAVING COUNT(actor_id) >= 2;

/*4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's
 second cousin's husband's yoga teacher. Write a query to fix the record.*/
 
UPDATE actor 
	SET first_name =  "HARPO"
	WHERE first_name =  "GROUCHO" and last_name = "WILLIAMS";
 
SELECT * FROM actor
	WHERE first_name = "HARPO";
 
 
/*4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all!
 In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first
 name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE 
 THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)*/

UPDATE actor 
SET 
    first_name = CASE
        WHEN first_name = 'HARPO' THEN 'GROUCHO'
        WHEN first_name = 'GROUCHO' THEN 'MUCHO GROUCHO'
    END
WHERE
    actor_id = 172;

/************************************************* Question 5 **************************************************************/
/*5a. You cannot locate the schema of the address table. Which query would you use to re-create it?*/

USE sakila;

CREATE TABLE address (
	address_id INTEGER(11) AUTO_INCREMENT NOT NULL,
    address varchar(50),
    address2 varchar(50),
    district varchar(20),
    city_id integer(5),
    postal_code varchar(10),
    phone varchar(20),
    location geometry,
    last_update timestamp
);

/************************************************* Question 6 **************************************************************/

/*6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff 
and address:*/

SELECT a.first_name, a.last_name, b.address
	FROM staff a LEFT JOIN address b 
		ON a.address_id = b.address_Id;

/*6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.*/

SELECT a.staff_id, a.first_name, a.last_name, SUM(b.amount) AS Total_amount 
	FROM staff a LEFT JOIN payment b
		ON a.staff_id = b.staff_id 
	GROUP BY b.staff_id;

/*6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.*/

SELECT a.film_id, a.title, COUNT(b.actor_id) AS number_of_actors
	FROM film a INNER JOIN film_actor b
		ON a.film_id = b.film_id 
	GROUP BY  b.film_id ;

/*6d. How many copies of the film Hunchback Impossible exist in the inventory system?*/

SELECT a.film_id, a.title, COUNT(b.inventory_id) AS number_of_copies
	FROM film a LEFT JOIN inventory b
		ON a.film_id = b.film_id 
	WHERE title = "Hunchback Impossible"
	GROUP BY b.film_id ;

/*6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer.
 List the customers alphabetically by last name: ![Total amount paid](Images/total_payment.png)*/

SELECT a.first_name, a.last_name, SUM(b.amount) AS total_paid 
	FROM customer a LEFT JOIN payment b
		ON a.customer_id = b.customer_id 
	GROUP BY b.customer_id 
	ORDER BY a.last_name;

/************************************************* Question 7 *****************************************************************/

/*7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films 
starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies 
starting with the letters K and  Q whose language is English.*/

SELECT title
	FROM film 
	WHERE (title like 'Q%' or title like 'K%')
	and language_id IN 
(
	SELECT language_id
		FROM language
		WHERE name = 'ENGLISH'
);

/*7b. Use subqueries to display all actors who appear in the film Alone Trip.*/

SELECT first_name, last_name
	FROM actor
	WHERE actor_id IN 
(
	SELECT actor_id
		FROM film_actor
		WHERE film_id IN 

		(
			SELECT film_id
				FROM film
				WHERE title = 'Alone Trip'
        )
);

/*7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all 
Canadian customers. Use joins to retrieve this information.*/

SELECT a.first_name, a.last_name, a.email, d.country
	FROM customer a LEFT JOIN address b 
		ON a.address_id = b.address_id
	LEFT JOIN city c 
		ON b.city_id = c.city_id
	LEFT JOIN country d 
		ON c.country_id = d.country_id
	WHERE country = 'Canada';


/*7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies
 categorized as famiy films.*/

SELECT a.title, c.name 
	FROM film a 
	LEFT JOIN film_category b
		ON a.film_id = b.film_id
	LEFT JOIN category c
		ON b.category_id = c.category_id
	WHERE c.name = 'Family';

/*7e. Display the most frequently rented movies in descending order.*/

SELECT a.film_id, a.title, COUNT(c.rental_id) AS count_rental
	FROM film a LEFT JOIN inventory b
		ON a.film_id = b.film_id
	LEFT JOIN rental c
		ON b.inventory_id = c.inventory_id
	GROUP BY a.film_id
ORDER BY count(c.rental_id) DESC; 

/*7f. Write a query to display how much business, in dollars, each store brought in.*/

SELECT a.store_id, SUM(c.amount) AS total_amount
 	FROM store a LEFT JOIN customer b
		ON a.store_id = b.store_id
	LEFT JOIN payment c
		ON b.customer_id = c.customer_id
	GROUP BY a.store_id
; 

/*7g. Write a query to display for each store its store ID, city, and country.*/

SELECT a.store_id, c.city, d.country
	FROM store a LEFT JOIN address b
		ON a.address_id = b.address_id
	LEFT JOIN city c 
		ON b.city_id = c.city_id
    LEFT JOIN country d
		ON c.country_id = d.country_id ;

/*7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, 
film_category, inventory, payment, and rental.)*/

SELECT  a.film_id, sum(c.amount) as gross_revenue, e.name as Genere
	FROM inventory a LEFT JOIN rental b
		ON a.inventory_id = b.inventory_id
	LEFT JOIN payment c
		ON b.rental_id = c.rental_id
	LEFT JOIN film_category d
		ON a.film_id = d.film_id
	LEFT JOIN category e
		ON d.category_id = e.category_id
	GROUP BY e.category_id
ORDER BY sum(c.amount) DESC
LIMIT 5	;

/************************************************* Question 8 *********************************************************************/

/*8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the 
solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.*/

CREATE VIEW executive AS
SELECT  a.film_id, sum(c.amount) as gross_revenue, e.name as Genere
	FROM inventory a LEFT JOIN rental b
		ON a.inventory_id = b.inventory_id
	LEFT JOIN payment c
		ON b.rental_id = c.rental_id
	LEFT JOIN film_category d
		ON a.film_id = d.film_id
	LEFT JOIN category e
		ON d.category_id = e.category_id
	GROUP BY e.category_id
ORDER BY sum(c.amount) DESC
LIMIT 5	;

/*8b. How would you display the view that you created in 8a?*/

SELECT * FROM executive;

/*8c. You find that you no longer need the view top_five_genres. Write a query to delete it.*/

DROP VIEW executive;








