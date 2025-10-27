
--1
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_name TEXT,
    customer_email TEXT,
    product_name TEXT,
    product_price NUMERIC(10,2)
);

--normalized ->
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    price NUMERIC(10,2) NOT NULL
);

CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(id),
    product_id INT REFERENCES products(id)
);

--2
CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT,
    product_name TEXT,
    PRIMARY KEY (order_id, product_id)
);

--normalized ->
CREATE TABLE orders (
    id SERIAL PRIMARY KEY
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE order_items (
    order_id INT REFERENCES orders(id),
    product_id INT REFERENCES products(id),
    quantity INT NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (order_id, product_id)
);

--3
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name TEXT,
    city TEXT,
    region TEXT
);

--normalized ->
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name TEXT NOT null,
    city_id INT REFERENCES cities(id) ON DELETE SET NULL
);

CREATE TABLE regions (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE cities (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    region_id INT NOT NULL REFERENCES regions(id) ON DELETE CASCADE
);