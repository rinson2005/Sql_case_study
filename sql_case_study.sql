CREATE DATABASE QuickCartDB;
USE QuickCartDB;
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    email VARCHAR(100),
    registration_date DATE
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10,2),
    stock_quantity INT
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_status VARCHAR(30),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Order_Items (
    item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    selling_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_method VARCHAR(30),
    payment_status VARCHAR(30),
    amount DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

INSERT INTO Customers VALUES
(1, 'Rahul', 'Trivandrum', 'rahul@gmail.com', '2025-01-10'),
(2, 'Anu', 'Kochi', 'anu@gmail.com', '2025-02-15'),
(3, 'Arun', 'Kollam', 'arun@gmail.com', '2025-03-20'),
(4, 'Meera', 'Trivandrum', 'meera@gmail.com', '2025-04-05'),
(5, 'Priya', 'Kozhikode', 'priya@gmail.com', '2025-05-12'),
(6, 'Kiran', 'Kochi', 'kiran@gmail.com', '2025-06-18');


INSERT INTO Products VALUES
(101, 'Laptop', 'Electronics', 55000, 8),
(102, 'Headphones', 'Electronics', 2500, 25),
(103, 'Smartphone', 'Electronics', 22000, 5),
(104, 'T-Shirt', 'Fashion', 800, 40),
(105, 'Shoes', 'Fashion', 2500, 12),
(106, 'Mixer Grinder', 'Home Appliances', 3500, 6),
(107, 'Office Chair', 'Furniture', 7500, 4);

INSERT INTO Orders VALUES
(1001, 1, '2026-10-01', 'Delivered'),
(1002, 2, '2026-10-02', 'Delivered'),
(1003, 1, '2026-10-05', 'Delivered'),
(1004, 3, '2026-10-07', 'Cancelled'),
(1005, 4, '2026-10-10', 'Delivered'),
(1006, 5, '2026-10-12', 'Pending'),
(1007, 2, '2026-10-15', 'Delivered'),
(1008, 3, '2026-10-18', 'Delivered');

INSERT INTO Order_Items VALUES
(1, 1001, 101, 1, 54000),
(2, 1001, 102, 2, 2300),
(3, 1002, 104, 3, 750),
(4, 1002, 105, 1, 2400),
(5, 1003, 103, 1, 21500),
(6, 1004, 106, 1, 3400),
(7, 1005, 107, 1, 7200),
(8, 1006, 102, 1, 2300),
(9, 1007, 104, 2, 750),
(10, 1008, 106, 2, 3300),
(11, 1008, 105, 1, 2400);

INSERT INTO Payments VALUES
(1, 1001, 'UPI', 'Paid', 58600),
(2, 1002, 'Credit Card', 'Paid', 4650),
(3, 1003, 'UPI', 'Paid', 21500),
(4, 1004, 'Debit Card', 'Refunded', 3400),
(5, 1005, 'UPI', 'Paid', 7200),
(6, 1006, 'Cash on Delivery', 'Pending', 2300),
(7, 1007, 'Credit Card', 'Paid', 1500),
(8, 1008, 'UPI', 'Paid', 9000);


select * from customers;
select * from products;
select * from orders;
select count(*) from customers;
select count(*) from products;
select count(*) from orders;
select distinct(category) from products order by category ;
select * from products where stock_quantity < 10;
select * from orders where order_status = 'cancelled' ;
select * from customers where city ='kollam';

select * from products where unit_price =(select max(unit_price) from products);
select * from products where unit_price =(select min(unit_price) from products);
select sum(stock_quantity) from products;
select sum(quantity*selling_price) as sales_value from order_items;
select avg(selling_price) from order_items as avg_selling_price ;
select order_status,count(*) as order_count from orders group by order_status;

select orders.order_id,customers.customer_name from orders inner join customers on orders.order_id = order_id;
select customers.customer_id,customers.customer_name,count(orders.order_id)
 as no_of_orders from customers 
 left join orders on customers.customer_id=orders.customer_id
 group by customers.customer_id,customers.customer_name;
select customers.customer_id,customers.customer_name,sum(order_items.quantity*order_items.selling_price) 
 as total_spent from customers 
 left join orders  on customers.customer_id=orders.customer_id
 left join order_items on orders.order_id=order_items.order_id
 group by customers.customer_id,customers.customer_name;
select customers.customer_id,customers.customer_name,sum(order_items.quantity*order_items.selling_price) 
 as total_spent from customers 
 left join orders  on customers.customer_id=orders.customer_id
 left join order_items on orders.order_id=order_items.order_id
 group by customers.customer_id,customers.customer_name
 order by total_spent desc limit 1;
select customers.customer_id,customers.customer_name from customers
 left join orders on customers.customer_id=orders.customer_id
 where orders.order_id is null;
select customers.customer_id,customers.customer_name,count(orders.order_id) as order_count from customers
 left join orders on customers.customer_id=orders.customer_id
 group by customers.customer_id,customers.customer_name
 having order_count > 2;
select city,count(*) as customer_count
from customers
group by City 
order by customer_count desc limit 1;
select * from customers
where registration_date < '2025-01-01';
select customers.customer_id,customers.customer_name,count(orders.order_id)
as order_count from customers
inner join orders on customers.customer_id=orders.order_id
group by  customers.customer_id,customers.customer_name
having order_count >1;

select orders.order_id,orders.order_status,payments.payment_status
from orders 
 left join payments on orders.order_id = payments.order_id;
select orders.order_id,orders.order_status,payments.payment_status
from orders 
 left join payments on orders.order_id = payments.order_id
 where payments.payment_status is null 
 or
 payments.payment_status = 'paid';
select * from orders 
where order_status = 'cancelled';
select payment_method,sum(amount) as amount_recieved 
from payments
where payment_status='paid'
group by payment_method;
select payment_status,count(*) as payment_count from payments group by payment_status;
select orders.order_id,payments.payment_status from orders
left join payments on orders.order_id=payments.order_id
where orders.order_status = 'delivered'
AND
(payments.payment_status is null or payments.payment_status = 'paid');
select payment_method,count(*) as usage_count from payments group by payment_method
order by usage_count desc limit 1;










