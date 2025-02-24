USE sakila;

### Challenge - Joining on multiple tables ###

### Write SQL queries to perform the following tasks using the Sakila database ###

-- List the number of films per category

SELECT DISTINCT category_id
FROM film_category;

SELECT category_id AS category_of_film, COUNT(film_id) AS num_of_films
FROM film_category
GROUP BY category_id
ORDER BY category_id DESC;

-- Retrieve the store ID, city, and country for each store

SELECT *
FROM store;

SELECT *
FROM address;

SELECT *
FROM city;

SELECT st.store_id, ad.address, ci.city, co.country
FROM store AS st
JOIN address AS ad
ON st.address_id = ad.address_id
JOIN city AS ci
ON ad.city_id = ci.city_id
JOIN country AS co
ON ci.country_id = co.country_id;

-- Calculate the total revenue generated by each store in dollars

SELECT *
FROM payment;

SELECT *
FROM staff;


SELECT sta.staff_id AS store_id, SUM(pa.amount) AS total_revenue
FROM staff AS sta
JOIN payment AS pa
ON sta.staff_id = pa.staff_id
GROUP BY sta.staff_id;

-- Determine the average running time of films for each category

SELECT cat.category_id AS film_category, ROUND(AVG(fi.length),2) AS average_length
FROM film_category as cat
JOIN film as fi
ON cat.film_id = fi.film_id
GROUP BY film_category;

###### BONUS #####

-- Identify the film categories with the longest average running time

SELECT cat.category_id AS film_category, ROUND(AVG(fi.length),2) AS average_length
FROM film_category as cat
JOIN film as fi
ON cat.film_id = fi.film_id
GROUP BY film_category
HAVING ROUND(AVG(fi.length),2) =
	(SELECT MAX(max_length)
    FROM (SELECT ROUND(AVG(length),2) AS max_length
		  FROM film_category AS cat
          JOIN film as fi
          ON cat.film_id = fi.film_id
          GROUP BY cat.category_id) AS subquery);

-- Display the top 10 most frequently rented movies in descending order

SELECT *
FROM rental;

SELECT *
FROM inventory;

SELECT *
FROM film;

SELECT fi.title, COUNT(DISTINCT ren.rental_id) AS n_times_rented
FROM film AS fi
JOIN inventory AS i
ON fi.film_id = i.film_id
JOIN rental AS ren
ON ren.inventory_id = i.inventory_id
GROUP BY fi.title
ORDER BY n_times_rented DESC
LIMIT 10;

-- Determine if "Academy Dinosaur" can be rented from Store 1
SELECT
    film.title AS movie_title,
    store.store_id,
    COUNT(rental.rental_id) AS rental_count
FROM
    film
JOIN
    inventory ON film.film_id = inventory.film_id
JOIN
    rental ON inventory.inventory_id = rental.inventory_id
JOIN
    store ON inventory.store_id = store.store_id
WHERE
    film.title = 'Academy Dinosaur' AND store.store_id = 1
GROUP BY
    film.title, store.store_id;
