-- Active: 1742637680988@@127.0.0.1@5432@shop
create TABLE books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    author VARCHAR(50) NOT NULL,
    price NUMERIC(8, 2) CHECK (price >= 0),
    stock INTEGER,
    published_year INTEGER CHECK (published_year >= 0)
);

drop TABLE books;
-- insert data on book table
INSERT into
    books (
        id,
        title,
        author,
        price,
        stock,
        published_year
    )
values (
        1,
        'The Pragmatic Programmer',
        'Andrew Hunt',
        40.00,
        10,
        1999
    ),
    (
        2,
        'Clean Code',
        'Robert C. Martin',
        35.00,
        5,
        2008
    ),
    (
        3,
        'You Don''t Know JS',
        'Kyle Simpson',
        30.00,
        8,
        2014
    ),
    (
        4,
        'Refactoring',
        'Martin Fowler',
        50.00,
        3,
        1999
    ),
    (
        5,
        'Database Design Principles',
        'Jane Smith',
        20.00,
        0,
        2018
    );

SELECT * from books;

-- create customers
create table customers (
    id SERIAL PRIMARY key,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(30) not NULL UNIQUE,
    joined_date DATE DEFAULT current_Date
);

alter Table customers alter joined_date set DEFAULT CURRENT_DATE

drop Table customers

-- insert customer table
INSERT INTO
    customers (id, name, email, joined_date)
VALUES (
        1,
        'Alice',
        'alice@email.com',
        '2023-01-10'
    ),
    (
        2,
        'Bob',
        'bob@email.com',
        '2022-05-15'
    ),
    (
        3,
        'Charlie',
        'charlie@email.com',
        '2023-06-20'
    );

DROP Table customers;

select * FROM customers;

--  orders create table
create table orders (
    id SERIAL PRIMARY KEY,
    customer_id int REFERENCES customers (id),
    book_id int REFERENCES books (id),
    quantity int check (quantity >= 0),
    order_date TIMESTAMP DEFAULT current_timestamp
)
-- insert order

INSERT INTO
    orders (
        id,
        customer_id,
        book_id,
        quantity,
        order_date
    )
VALUES (1, 1, 2, 1, '2024-03-10'),
    (2, 2, 1, 1, '2024-02-20'),
    (3, 1, 3, 2, '2024-03-05');

-- show all order
SELECT * FROM orders;

--  assigment question answer

-- question no 1
-- Find books that are out of stock.
SELECT title from books WHERE stock = 0;

-- question 2
-- Retrieve the most expensive book in the store.
select * from books WHERE price = ( SELECT max(price) FROM books );

-- question 3
-- Find the total number of orders placed by each customer.
select customers.name, count(orders.id) as total_orders
from customers
    LEFT JOIN orders ON customers.id = orders.customer_id
GROUP BY
    customers.id
HAVING
    count(orders.id) > 0
order by count(orders.id) desc;

-- question 4
-- Calculate the total revenue generated from book sales.

SELECT sum(orders.quantity * books.price)
from orders
    join books USING (id)

-- question 5
-- List all customers who have placed more than one order.
select customers.name, count(orders.id) as orders_count
from customers
    LEFT JOIN orders ON customers.id = orders.customer_id
     
GROUP BY
    customers.id
HAVING
    count(orders.id) > 1
order by count(orders.id) desc;

-- question 6
-- Find the average price of books in the store.


SELECT round(avg(price), 2) as avg_book_price FROM books;

-- question 7
-- Increase the price of all books published before 2000 by 10% 
update books
set
    price = ROUND(price * (1.10), 2)
WHERE
    published_year < 2000;

SELECT * FROM books;

SELECT * FROM customers;
-- question 8
-- Delete customers who haven't placed any orders.

DELETE FROM customers USING customers cus
LEFT JOIN orders odr ON cus.id = odr.customer_id
WHERE
    odr.id IS NULL;