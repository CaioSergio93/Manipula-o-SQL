# lista de 15 exercícios SQL utilizando funções de agregação combinadas com JOIN e INNER JOIN em todas as consultas, aplicadas ao banco de dados Pagila:

Exercício 1: Encontre o total de filmes disponíveis em cada loja.
SELECT s.store_id, COUNT(i.inventory_id) AS total_films
FROM store AS s
INNER JOIN inventory AS i ON s.store_id = i.store_id
GROUP BY s.store_id;

Exercício 2: Calcule a receita total gerada por cada funcionário.
SELECT st.staff_id, SUM(p.amount) AS total_revenue
FROM staff AS st
INNER JOIN payment AS p ON st.staff_id = p.staff_id
GROUP BY st.staff_id;

Exercício 3: Determine o número médio de dias de aluguel por categoria.
SELECT c.name, AVG(f.rental_duration) AS average_rental_duration
FROM category AS c
INNER JOIN film_category AS fc ON c.category_id = fc.category_id
INNER JOIN film AS f ON fc.film_id = f.film_id
GROUP BY c.name;

Exercício 4: Liste o número total de transações realizadas em cada loja.
SELECT s.store_id, COUNT(p.payment_id) AS total_transactions
FROM store AS s
INNER JOIN staff AS st ON s.store_id = st.store_id
INNER JOIN payment AS p ON st.staff_id = p.staff_id
GROUP BY s.store_id;


Exercício 5: Qual é a soma dos pagamentos feitos por cada cliente?
SELECT c.customer_id, SUM(p.amount) AS total_paid
FROM customer AS c
INNER JOIN payment AS p ON c.customer_id = p.customer_id
GROUP BY c.customer_id;


Exercício 6: Determine o número de filmes em cada categoria em cada loja.
SELECT s.store_id, c.name, COUNT(i.inventory_id) AS film_count
FROM store AS s
INNER JOIN inventory AS i ON s.store_id = i.store_id
INNER JOIN film AS f ON i.film_id = f.film_id
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
INNER JOIN category AS c ON fc.category_id = c.category_id
GROUP BY s.store_id, c.name;

Exercício 7: Encontre a maior quantia paga por transação em cada loja.
SELECT s.store_id, MAX(p.amount) AS highest_payment
FROM store AS s
INNER JOIN staff AS st ON s.store_id = st.store_id
INNER JOIN payment AS p ON st.staff_id = p.staff_id
GROUP BY s.store_id;

Exercício 8: Calcule a duração média dos filmes em cada categoria para a loja 2.
SELECT c.name, AVG(f.length) AS average_length
FROM store AS s
INNER JOIN inventory AS i ON s.store_id = i.store_id
INNER JOIN film AS f ON i.film_id = f.film_id
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
INNER JOIN category AS c ON fc.category_id = c.category_id
WHERE s.store_id = 2
GROUP BY c.name;

Exercício 9: Quantos clientes distintos fizeram transações em cada loja?
SELECT s.store_id, COUNT(DISTINCT p.customer_id) AS unique_customers
FROM store AS s
INNER JOIN staff AS st ON s.store_id = st.store_id
INNER JOIN payment AS p ON st.staff_id = p.staff_id
GROUP BY s.store_id;

Exercício 10: Encontre a soma total dos pagamentos feitos por categoria de filme.
SELECT c.name, SUM(p.amount) AS total_revenue
FROM category AS c
INNER JOIN film_category AS fc ON c.category_id = fc.category_id
INNER JOIN film AS f ON fc.film_id = f.film_id
INNER JOIN inventory AS i ON f.film_id = i.film_id
INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
INNER JOIN payment AS p ON r.rental_id = p.rental_id
GROUP BY c.name;

Exercício 11: Qual é a média de duração dos filmes alugados por cada cliente?
SELECT c.customer_id, AVG(f.length) AS average_length
FROM customer AS c
INNER JOIN rental AS r ON c.customer_id = r.customer_id
INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
INNER JOIN film AS f ON i.film_id = f.film_id
GROUP BY c.customer_id;

Exercício 12: Determine o número total de filmes alugados em cada loja por categoria.
SELECT s.store_id, c.name, COUNT(r.rental_id) AS total_rentals
FROM store AS s
INNER JOIN inventory AS i ON s.store_id = i.store_id
INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
INNER JOIN film AS f ON i.film_id = f.film_id
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
INNER JOIN category AS c ON fc.category_id = c.category_id
GROUP BY s.store_id, c.name;

Exercício 13: Calcule a receita média gerada por cada funcionário em cada loja.
SELECT s.store_id, st.staff_id, AVG(p.amount) AS average_revenue
FROM store AS s
INNER JOIN staff AS st ON s.store_id = st.store_id
INNER JOIN payment AS p ON st.staff_id = p.staff_id
GROUP BY s.store_id, st.staff_id;

Exercício 14: Encontre o número total de filmes disponíveis para aluguel em cada categoria.
SELECT c.name, COUNT(i.inventory_id) AS total_inventory
FROM category AS c
INNER JOIN film_category AS fc ON c.category_id = fc.category_id
INNER JOIN film AS f ON fc.film_id = f.film_id
INNER JOIN inventory AS i ON f.film_id = i.film_id
GROUP BY c.name;

Exercício 15: Determine o total de transações e o valor total pago por cada cliente em cada loja.
SELECT s.store_id, c.customer_id, COUNT(p.payment_id) AS total_transactions, SUM(p.amount) AS total_amount
FROM store AS s
INNER JOIN staff AS st ON s.store_id = st.store_id
INNER JOIN payment AS p ON st.staff_id = p.staff_id
INNER JOIN customer AS c ON p.customer_id = c.customer_id
GROUP BY s.store_id, c.customer_id;

# Esses exercícios combinam funções de agregação com JOIN e INNER JOIN para manipular e analisar dados do banco Pagila de maneira mais complexa.