-- Consulta 1: Películas con clasificación 'R'
SELECT title 
FROM film 
WHERE rating = 'R';

-- Consulta 2: Encuentra los nombres completos de los actores que tengan un actor_id entre 30 y 40.
SELECT actor_id,
    CONCAT(first_name, ' ', last_name) AS full_name
FROM actor
WHERE actor_id BETWEEN 30 AND 40
    
-- Consulta 3: Obtén las películas cuyo idioma coincide con el idioma original.
SELECT film_id, title, language_id, original_language_id
FROM film
WHERE language_id = original_language_id;

-- Consulta 4: Ordena las películas por duración de forma ascendente.
SELECT film_id, title, length
FROM film
ORDER BY length;

-- Consulta 5: Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido.
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM actor
WHERE last_name = 'ALLEN';

-- Consulta 6: Encuentra la cantidad total de películas en cada clasificación y muestra la clasificación junto con el recuento.
SELECT rating,COUNT(*) AS total_peliculas
FROM  film
GROUP BY rating;

-- Consulta 7: Encuentra el título de todas las películas que son 'PG-13' o tienen una duración mayor a 180 minutos (3 horas).
SELECT title, length , rating 
FROM film
WHERE rating = 'PG-13' 
OR length > 180;

-- Consulta 8: Encuentra la desviación estándar y varianza del costo de reemplazo de las películas.
SELECT STDDEV(replacement_cost) AS desviacion_estandar, VAR_SAMP(replacement_cost) AS varianza
FROM film;

-- Consulta 9: Encuentra la mayor y menor duración de una película.
SELECT MAX(length) AS duracion_maxima,  MIN(length) AS duracion_minima
FROM film;

-- Consulta 11: Encuentra el costo del antepenúltimo alquiler ordenado por fecha de alquiler ascendente.
SELECT p.amount AS coste
FROM rental r
JOIN payment p 
ON r.rental_id = p.rental_id
ORDER BY r.rental_date 
OFFSET 2 LIMIT 1; 

-- Consulta 12: Encuentra el título de las películas que no sean ni 'NC-17' ni 'G' en su clasificación.
SELECT title , rating 
FROM film
WHERE rating NOT IN ('NC-17', 'G');

-- Consulta 14: Encuentra el promedio de duración de las películas para cada clasificación.
SELECT rating, AVG(length) AS promedio_duracion
FROM film
GROUP BY rating;

-- Consulta 15: Encuentra el título de todas las películas con duración mayor a 180 minutos.
SELECT title, length 
FROM film
WHERE length > 180;

-- Consulta 16: Calcula el total de dinero generado por la empresa sumando los pagos.
SELECT SUM(amount) AS total_generado
FROM payment;

-- Consulta 17: Muestra los 10 clientes con mayor valor de customer_id.
SELECT customer_id, CONCAT(first_name,' ',last_name) as full_name
FROM customer
ORDER by customer_id DESC
LIMIT 10;

-- Consulta 18: Encuentra el nombre y apellido de los actores que aparecen en la película con título 'Egg Igby'.
SELECT CONCAT(a.first_name, ' ', a.last_name) AS full_name, f.title 
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
WHERE f.title = 'EGG IGBY';

-- Consulta 19: Selecciona todos los nombres únicos de películas.
SELECT distinct title
FROM film;

-- Consulta 20: Encuentra el título de las películas que son comedias y duran más de 180 minutos.
SELECT f.title , c.name as category
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Comedy'
AND f.length > 180;

-- Consulta 21: Encuentra las categorías con promedio de duración > 110 minutos.
SELECT c.name AS categoria, AVG(f.length) AS promedio_duracion
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
GROUP BY c.name
HAVING AVG(f.length) > 110;

-- Consulta 22: Calcula la media de duración del alquiler en días.
SELECT AVG(return_date - rental_date) AS promedio_duracion_alquiler_dias
FROM rental
WHERE return_date IS NOT NULL;

-- Consulta 23: Crea una columna con el nombre y apellidos de todos los actores y actrices.
SELECT CONCAT(first_name, ' ', last_name) AS nombre_completo
FROM actor;

-- Consulta 24: Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.
select rental_date::date AS fecha_alquiler, COUNT(*) AS numero_alquileres
from rental
GROUP by rental_date::date
ORDER by numero_alquileres DESC;

-- Consulta 25: Encuentra las películas con una duración superior al promedio.
SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film);

-- Consulta 26: Averigua el número de alquileres registrados por mes.
SELECT DATE_TRUNC('month', rental_date) AS mes, COUNT(*) AS numero_alquileres, 
FROM rental
GROUP by mes
ORDER BY mes;

-- Consulta 27: Encuentra el promedio, la desviación estándar y varianza del total pagado.
SELECT AVG(amount) AS promedio, STDDEV(amount) AS desviacion_estandar, VAR_SAMP(amount) AS varianza
FROM payment;

-- Consulta 28: ¿Qué películas se alquilan por encima del precio medio?
SELECT title, Rental_rate
FROM film
WHERE rental_rate > (SELECT AVG(rental_rate) FROM film);

-- Consulta 29: Muestra el id de los actores que hayan participado en más de 40 películas.
SELECT actor_id,COUNT(film_id) AS peliculas_participadas
from film_actor
GROUP by actor_id
having COUNT(film_id) > 40;

-- Consulta 30: Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.
SELECT f.film_id, f.title, COUNT(i.inventory_id) AS cantidad_disponible
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
GROUP BY f.film_id, f.title;

-- Consulta 31: Obtener los actores y el número de películas en las que ha actuado.
SELECT a.actor_id,
CONCAT(a.first_name, ' ', a.last_name) AS nombre_completo,
COUNT(fa.film_id) AS numero_peliculas
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP by a.actor_id, a.first_name, a.last_name;

-- Consulta 32: Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.
select f.film_id, f.title,
       CONCAT(a.first_name, ' ', a.last_name) AS nombre_completo_actor
from film f
LEFT JOIN film_actor fa ON f.film_id = fa.film_id
LEFT JOIN actor a ON fa.actor_id = a.actor_id
ORDER by f.film_id;

-- Consulta 33: Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.
SELECT a.actor_id, CONCAT(a.first_name, ' ', a.last_name) AS nombre_completo_actor, f.title AS pelicula
from actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
LEFT JOIN film f ON fa.film_id = f.film_id
ORDER by a.actor_id;

-- Consulta 34: Obtener todas las películas y todos los registros de alquiler.
SELECT f.film_id, f.title, r.rental_id, r.rental_date, r.return_date, r.customer_id
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
ORDER by f.film_id;

-- Consulta 35: Encuentra los 5 clientes que más dinero se hayan gastado.
SELECT c.customer_id, concat(c.first_name,' ', c.last_name),SUM(p.amount) AS total_gastado
FROM customer c
JOIN payment p 
ON c.customer_id = p.customer_id
GROUP by c.customer_id, c.first_name, c.last_name
ORDER by total_gastado DESC
LIMIT 5;

-- Consulta 36: Selecciona todos los actores cuyo primer nombre es 'Johnny'.
SELECT actor_id,concat(first_name,' ',last_name)
FROM actor
WHERE first_name = 'JOHNNY';

-- Consulta 37: Renombra la columna “first_name” como Nombre y “last_name” como Apellido.
SELECT first_name AS Nombre, last_name AS Apellido
FROM actor;

-- Consulta 38: Encuentra el ID del actor más bajo y más alto en la tabla actor.
SELECT MIN(actor_id) AS id_minimo, MAX(actor_id) AS id_maximo
FROM actor;

-- Consulta 39: Cuenta cuántos actores hay en la tabla “actor”.
Select COUNT(*) AS total_actores
From actor;

-- Consulta 40: Selecciona todos los actores y ordénalos por apellido en orden ascendente.
select actor_id, CONCAT(first_name,' ',last_name)
from actor
ORDER by last_name;

-- Consulta 41: Selecciona las primeras 5 películas de la tabla “film”.
select film_id, title
from film
ORDER by film_id
LIMIT 5;

-- Consulta 42: Agrupa los actores por su nombre y cuenta cuántos tienen el mismo nombre. Ordena para ver el nombre más repetido.
select first_name, COUNT(*) AS cantidad
from actor
GROUP by first_name
ORDER by cantidad desc;

-- Consulta 43: Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
select r.rental_id, r.rental_date, CONCAT(c.first_name, ' ', c.last_name) AS nombre_cliente
from rental r
JOIN customer c 
ON r.customer_id = c.customer_id;

-- Consulta 44: Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
select c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS nombre_cliente, r.rental_id, r.rental_date
from customer c
LEFT JOIN rental r 
ON c.customer_id = r.customer_id

-- Consulta 45: Realiza un CROSS JOIN entre las tablas film y category.
select f.title AS pelicula, c.name AS categoria
from film f
CROSS JOIN category c;
/*
 ¿Aporta valor esta consulta?
No aporta ningún valor. Un CROSS JOIN combina cada película con todas las categorías posibles, sin filtrar si realmente están relacionadas. Esto produce un conjunto de resultados muy grande y poco útil, ya que no refleja las relaciones reales entre películas y categorías.
*/

-- Consulta 46: Encuentra los actores que han participado en películas de la categoría 'Action'.
SELECT distinct CONCAT(a.first_name, ' ', a.last_name) AS nombre_completo
from actor a
JOIN film_actor fa 
ON a.actor_id = fa.actor_id
JOIN film_category fc 
ON fa.film_id = fc.film_id
JOIN category c 
ON fc.category_id = c.category_id
where c.name = 'Action';

-- Consulta 47: Encuentra todos los actores que no han participado en películas.
select CONCAT(a.first_name, ' ', a.last_name) AS nombre_completo
from actor a
LEFT JOIN film_actor fa 
ON a.actor_id = fa.actor_id
where fa.film_id IS NULL;

-- Consulta 48: Selecciona el nombre de los actores y la cantidad de películas en las que han participado.
select CONCAT(a.first_name, ' ', a.last_name) AS nombre_completo,
       COUNT(fa.film_id) AS peliculas_participadas
from actor a
LEFT JOIN film_actor fa 
ON a.actor_id = fa.actor_id
GROUP by a.actor_id, a.first_name, a.last_name;

-- Consulta 49: Crea una vista llamada “actor_num_peliculas” que muestre los nombres de los actores y el número de películas en las que han participado.
CREATE VIEW actor_num_peliculas AS
SELECT
    CONCAT(first_name, ' ', last_name) AS nombre_completo,
    COUNT(fa.film_id) AS numero_peliculas
from actor a
LEFT JOIN film_actor fa 
ON a.actor_id = fa.actor_id
GROUP by a.actor_id, a.first_name, a.last_name;

select *
from actor_num_peliculas

-- Consulta 50: Calcula el número total de alquileres realizados por cada cliente.
select c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS nombre_completo, COUNT(r.rental_id) AS total_alquileres
from customer c
LEFT JOIN rental r 
ON c.customer_id = r.customer_id
GROUP by c.customer_id, c.first_name, c.last_name;

-- Consulta 51: Calcula la duración total de las películas en la categoría 'Action'.
select SUM(f.length) AS duracion_total
from film f
JOIN film_category fc 
ON f.film_id = fc.film_id
JOIN category c 
ON fc.category_id = c.category_id
where c.name = 'Action';

-- Consulta 52: Crea una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente, usando WITH.
WITH total_alquileres AS (
    select c.customer_id, concat(c.first_name,' ',c.last_name), COUNT(r.rental_id) AS total_alquileres
    from customer c
        LEFT JOIN rental r ON c.customer_id = r.customer_id
    GROUP by c.customer_id
)
SELECT * FROM total_alquileres;

-- Consulta 53: Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las películas alquiladas al menos 10 veces, usando CTE.
WITH peliculas_alquiladas_cte AS (
    select f.film_id, f.title, COUNT(r.rental_id) AS veces_alquilada
    from film f
        JOIN inventory i 
        ON f.film_id = i.film_id
        JOIN rental r 
        ON i.inventory_id = r.inventory_id
    GROUP by f.film_id, f.title
    having COUNT(r.rental_id) >= 10
)
SELECT * FROM peliculas_alquiladas_cte;

-- Consulta 54: Encuentra el título de las películas alquiladas por ‘Tammy Sanders’ que aún no se han devuelto.
select f.title
from film f
    JOIN inventory i 
    ON f.film_id = i.film_id
    JOIN rental r 
    ON i.inventory_id = r.inventory_id
    JOIN customer c 
    ON r.customer_id = c.customer_id
where c.first_name = 'TAMMY'
    AND c.last_name = 'SANDERS'
    AND r.return_date IS NULL
ORDER by f.title;

-- Consulta 55: Encuentra los nombres de los actores que han actuado en películas de la categoría ‘Sci-Fi’.
SELECT distinct a.first_name, a.last_name, C."name"
from actor a
    JOIN film_actor fa 
    ON a.actor_id = fa.actor_id
    JOIN film_category fc 
    ON fa.film_id = fc.film_id
    JOIN category c 
    ON fc.category_id = c.category_id
where c.name = 'Sci-Fi'
ORDER by a.last_name;

-- Consulta 56: Encuentra los nombres y apellidos de los actores que han actuado en películas alquiladas después del primer alquiler de 'Spartacus Cheaper'.
WITH fecha_spartacus AS (
    SELECT MIN(r.rental_date) AS primera_fecha
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    WHERE f.title = 'SPARTACUS CHEAPER'
)
SELECT distinct first_name, a.last_name
from actor a
    JOIN film_actor fa ON a.actor_id = fa.actor_id
    JOIN inventory i ON fa.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    CROSS JOIN fecha_spartacus fs
where r.rental_date > fs.primera_fecha
ORDER by a.last_name;

-- Consulta 57: Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’.
select CONCAT(a.first_name, ' ', a.last_name) AS nombre_completo
from actor a
WHERE
    NOT EXISTS (
        SELECT 1
        FROM film_actor fa
        JOIN film_category fc ON fa.film_id = fc.film_id
        JOIN category c ON fc.category_id = c.category_id
        WHERE fa.actor_id = a.actor_id
          AND c.name = 'Music'
    )
ORDER by a.last_name;

-- Consulta 58: Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.
SELECT distinct f.title
from film f
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
where (r.return_date - r.rental_date) > INTERVAL '8 days';

-- Consulta 59: Encuentra el título de todas las películas que son de la misma categoría que 'Animation'.
SELECT distinct f.title
from film f
    JOIN film_category fc 
    ON f.film_id = fc.film_id
where fc.category_id = (
        SELECT category_id
        FROM category
        WHERE name = 'Animation'
    );

-- Consulta 60: Encuentra los nombres de las películas con la misma duración que 'Dancing Fever'.
select title
from film
where length = (
        SELECT length
        FROM film
        WHERE title = 'DANCING FEVER'
        LIMIT 1
    )
ORDER by title;

-- Consulta 61: Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.
select c.customer_id, c.first_name, c.last_name
from customer c
    JOIN rental r 
    ON c.customer_id = r.customer_id
    JOIN inventory i 
    ON r.inventory_id = i.inventory_id
GROUP by c.customer_id, c.first_name, c.last_name
having COUNT(DISTINCT i.film_id) >= 7
ORDER by c.last_name;

-- Consulta 62: Encuentra la cantidad total de películas alquiladas por categoría.
select c.name AS categoria, COUNT(r.rental_id) AS total_alquileres
from category c
    JOIN film_category fc ON c.category_id = fc.category_id
    JOIN inventory i ON fc.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
GROUP by c.name
ORDER by c.name;

-- Consulta 63: Encuentra el número de películas por categoría estrenadas en 2006.
select c.name AS categoria, COUNT(f.film_id) AS cantidad_peliculas
from category c
    JOIN film_category fc ON c.category_id = fc.category_id
    JOIN film f ON fc.film_id = f.film_id
where f.release_year = 2006
GROUP by c.name
order by c.name;

-- Consulta 64: Obtén todas las combinaciones posibles de trabajadores con las tiendas.
select s.staff_id, s.first_name, s.last_name, st.store_id, st.manager_staff_id 
from staff s
CROSS JOIN store st;

-- Consulta 65: Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
select c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_peliculas_alquiladas
from customer c
    LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP by c.customer_id, c.first_name, c.last_name
ORDER by total_peliculas_alquiladas DESC;






