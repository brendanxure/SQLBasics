CREATE TABLE customers (
   customer_id SERIAL PRIMARY KEY,
   name VARCHAR(50) NOT NULL,
   email VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE orders (
   order_id SERIAL PRIMARY KEY,
   customer_id SERIAL NOT NULL REFERENCES customers(customer_id),
   date DATE NOT NULL,
   description VARCHAR(255),
   status VARCHAR(50)
);

INSERT INTO customers (name, email) VALUES 
   ('Andrew', 'andrew.luxmore@durhamcollege.ca'),
   ('James', 'james.bond@mi6.uk');

SELECT customer_id, name, email FROM customers;	

INSERT INTO orders (customer_id, date, description, status) VALUES
   (2, '2024-01-27', 'Invisible car', NULL),
   (1, '2023-12-25', 'Cat toy', 'ON ITS WAY'),
   (2, '2024-01-01', 'Pen that explodes when clicked too much', 'IN SAFETY REVIEW');

SELECT c.name, c.email, orders.date, orders.description, orders.status
	FROM customers AS c
		INNER JOIN orders ON c.customer_id = orders.customer_id;

UPDATE orders 
	SET status = 'UNSAFE' WHERE status = 'IN SAFETY REVIEW';

SELECT date, description, status FROM orders
	WHERE customer_id = 2;

DELETE FROM orders WHERE status = 'UNSAFE';

SELECT date, description, status FROM orders;

ALTER USER andrew WITH ENCRYPTED PASSWORD 'not-my-student-number';