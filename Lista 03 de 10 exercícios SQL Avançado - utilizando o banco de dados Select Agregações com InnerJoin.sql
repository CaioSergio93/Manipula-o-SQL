# lista 03 - Avançada de exercícios SQL utilizando SELECT, subconsultas, agregações, INNER JOIN, e outras estruturas de armazenamento como CTE (Common Table Expressions) e VIEW. Esses exercícios são desenhados para explorar funcionalidades complexas do SQL e são baseados no banco de dados Pagila.

# 1. Exercício 1:
# Crie uma consulta que retorne o nome da categoria e a média de duração dos filmes (length) 
# em cada categoria, mas apenas para as categorias onde a duração média dos filmes seja 
# superior à média geral de duração dos filmes.

SELECT c.name, AVG(f.length) AS average_length
FROM category AS c
INNER JOIN film_category AS fc ON c.category_id = fc.category_id
INNER JOIN film AS f ON fc.film_id = f.film_id
GROUP BY c.name
HAVING AVG(f.length) > (SELECT AVG(length) FROM film);


# 2. Exercício 2:
# Encontre os clientes que fizeram mais do que 10 locações (rental) e que possuem um valor 
# total pago (amount) acima da média geral, mostrando o ID do cliente, o número de locações 
# e o valor total pago.

SELECT c.customer_id, COUNT(r.rental_id) AS rental_count, SUM(p.amount) AS total_paid
FROM customer AS c
INNER JOIN rental AS r ON c.customer_id = r.customer_id
INNER JOIN payment AS p ON r.rental_id = p.rental_id
GROUP BY c.customer_id
HAVING COUNT(r.rental_id) > 10 AND SUM(p.amount) > (SELECT AVG(amount) FROM payment);


# 3. Exercício 3:
# Crie uma VIEW que exibe o total de filmes disponíveis e alugados em cada loja, 
# por categoria. Use essa VIEW para encontrar as categorias com mais de 50 filmes 
# disponíveis na loja 1.

CREATE VIEW store_category_inventory AS
SELECT s.store_id, c.name AS category_name, COUNT(i.inventory_id) AS total_inventory, 
       COUNT(r.rental_id) AS total_rented
FROM store AS s
INNER JOIN inventory AS i ON s.store_id = i.store_id
INNER JOIN film AS f ON i.film_id = f.film_id
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
INNER JOIN category AS c ON fc.category_id = c.category_id
LEFT JOIN rental AS r ON i.inventory_id = r.inventory_id
GROUP BY s.store_id, c.name;

SELECT category_name, total_inventory 
FROM store_category_inventory 
WHERE store_id = 1 AND total_inventory > 50;



# 4. Exercício 4:
# Utilize uma CTE para calcular a receita total gerada por cada categoria em todas as lojas. 
# Depois, filtre as categorias que geraram mais de 10.000 em receita total.

WITH category_revenue AS (
   SELECT c.name AS category_name, SUM(p.amount) AS total_revenue
   FROM category AS c
   INNER JOIN film_category AS fc ON c.category_id = fc.category_id
   INNER JOIN film AS f ON fc.film_id = f.film_id
   INNER JOIN inventory AS i ON f.film_id = i.film_id
   INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
   INNER JOIN payment AS p ON r.rental_id = p.rental_id
   GROUP BY c.name
)
SELECT category_name, total_revenue 
FROM category_revenue
WHERE total_revenue > 10000;


# 5. Exercício 5:
# Encontre os funcionários (staff) que geraram o maior número de transações em cada loja. 
# Mostre o nome do funcionário, a loja e o número de transações.

SELECT st.first_name, st.last_name, st.store_id, COUNT(p.payment_id) AS transaction_count
FROM staff AS st
INNER JOIN payment AS p ON st.staff_id = p.staff_id
GROUP BY st.store_id, st.staff_id
HAVING COUNT(p.payment_id) = (
    SELECT MAX(transaction_count) 
    FROM (SELECT COUNT(payment_id) AS transaction_count 
          FROM payment 
          WHERE store_id = st.store_id 
          GROUP BY staff_id) AS subquery
);


# 6. Exercício 6:
# Usando subconsultas correlacionadas, mostre os filmes cujo preço de aluguel (rental_rate) 
# é maior que a média dos filmes da mesma categoria.

SELECT f.title, f.rental_rate
FROM film AS f
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
WHERE f.rental_rate > (SELECT AVG(f2.rental_rate) 
                       FROM film AS f2 
                       INNER JOIN film_category AS fc2 ON f2.film_id = fc2.film_id 
                       WHERE fc2.category_id = fc.category_id);


# 7. Exercício 7:
# Crie uma consulta que retorne o total de filmes alugados por cada cliente, e classifique 
# os clientes que estão no top 5 em termos de número de locações.

WITH customer_rentals AS (
    SELECT c.customer_id, COUNT(r.rental_id) AS total_rentals
    FROM customer AS c
    INNER JOIN rental AS r ON c.customer_id = r.customer_id
    GROUP BY c.customer_id
)
SELECT customer_id, total_rentals
FROM customer_rentals
ORDER BY total_rentals DESC
LIMIT 5;


# 8. Exercício 8:
# Liste as categorias e a soma das durações (length) dos filmes em cada categoria que 
# possuem mais de 5 filmes com duração superior a 120 minutos.

SELECT c.name AS category_name, SUM(f.length) AS total_length
FROM category AS c
INNER JOIN film_category AS fc ON c.category_id = fc.category_id
INNER JOIN film AS f ON fc.film_id = f.film_id
WHERE f.length > 120
GROUP BY c.name
HAVING COUNT(f.film_id) > 5;


# 9. Exercício 9:
# Crie uma consulta que retorne o total de filmes disponíveis em cada loja por cada 
# categoria, considerando apenas as categorias que têm pelo menos 3 filmes 
# alugados atualmente.

SELECT s.store_id, c.name AS category_name, COUNT(i.inventory_id) AS total_inventory
FROM store AS s
INNER JOIN inventory AS i ON s.store_id = i.store_id
INNER JOIN film AS f ON i.film_id = f.film_id
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
INNER JOIN category AS c ON fc.category_id = c.category_id
WHERE c.category_id IN (
    SELECT fc.category_id
    FROM film_category AS fc
    INNER JOIN inventory AS i ON fc.film_id = i.film_id
    INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
    GROUP BY fc.category_id
    HAVING COUNT(r.rental_id) >= 3
)
GROUP BY s.store_id, c.name;


# 10. Exercício 10:
# Usando subconsultas e agregações, encontre os filmes que possuem a maior diferença 
# entre a duração do filme (length) e a média de duração dos filmes na mesma categoria.

SELECT f.title, f.length, 
       f.length - (SELECT AVG(f2.length) 
                   FROM film AS f2 
                   INNER JOIN film_category AS fc2 ON f2.film_id = fc2.film_id 
                   WHERE fc2.category_id = fc.category_id) AS length_difference
FROM film AS f
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
ORDER BY length_difference DESC
LIMIT 10;

# Fim lista 03 - Avançada de exercícios SQL utilizando SELECT, subconsultas, agregações, INNER JOIN, e outras estruturas de armazenamento como CTE (Common Table Expressions) e VIEW. Esses exercícios são desenhados para explorar funcionalidades complexas do SQL e são baseados no banco de dados Pagila.