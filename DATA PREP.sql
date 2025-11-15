-- ORDER DETAILS TABLE --
CREATE TABLE order_details (
	order_details_id INT,
    order_id INT,
    pizza_id VARCHAR(100),
    quantity INT
    );
    
-- ORDERS TABLE --
CREATE TABLE orders (
	order_id INT,
    date DATE,
    time TIME
    );
    
-- PIZZA TYPES TABLE --
CREATE TABLE pizza_types (
	pizza_type_id VARCHAR(100),
    name VARCHAR(100),
    category VARCHAR(100),
    ingredients VARCHAR(100)
    );
    
    
-- PIZZAS TABLE --
CREATE TABLE pizzas (
	pizza_id VARCHAR(100),
    pizza_type_id VARCHAR(100),
    size VARCHAR(100),
    price FLOAT
    );


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/order_details.csv'  
INTO TABLE order_details
FIELDS TERMINATED BY ','
IGNORE 1 LINES;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
IGNORE 1 LINES;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pizza_types.csv'  
INTO TABLE pizza_types
FIELDS TERMINATED BY ','
IGNORE 1 LINES;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pizzas.csv'  
INTO TABLE pizzas
FIELDS TERMINATED BY ','
IGNORE 1 LINES;



