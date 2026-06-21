#Create database:
CREATE DATABASE onlinebookstore;
#Use database
USE  onlinebookstore;

#Create Tables 
CREATE TABLE Books (
 Book_id INT PRIMARY KEY,
 Title VARCHAR(100),
 Author VARCHAR(50),
 Genre VARCHAR(50),
 Published_Year INT,
 Price NUMERIC(10,2),
 STOCK int
 );
 
 CREATE TABLE customers(
  Customer_id SERIAL PRIMARY KEY,
  Name VARCHAR(100),
  Email VARCHAR(100),
  Phone VARCHAR(15),
  City VARCHAR(50),
  Country VARCHAR (150)
);

CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

#Load data in tables

#1) Retrieve all books in the "Fiction" genre:
SELECT Title,Genre FROM Books
WHERE Genre= "Fiction";

#2) Find books published after the year 1950:
SELECT * FROM Books
WHERE Published_Year > 1950;

#3) List all customers from the Canada
SELECT * FROM Customers
WHERE Country = "Canada";

#4) Show orders placed in November 2023:
SELECT * FROM Orders
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

# 5) Retrieve the total stock of books available:
SELECT SUM(Stock) AS Total_stock FROM Books;

#6) Find the details of the most expensive book:
SELECT Price,Title FROM Books
ORDER BY Price DESC
LIMIT 1;

#7) Show all customers who ordered more than 1 quantity of a book:
SELECT Customer_id,Quantity FROM Orders
WHERE Quantity >1;

#8) Retrieve all orders where the total amount exceeds $20:
SELECT Order_id,Total_Amount FROM Orders
WHERE Total_Amount >20;

#9) List all genres available in the Books table:
SELECT DISTINCT Genre FROM Books;

#10) Find the top 5 book with the lowest stock:
SELECT Book_Id,Title,Stock FROm Books
ORDER BY Stock ASC
LIMIT 5;

# 11) Calculate the total revenue generated from all orders:
SELECT SUM(Total_Amount) AS Total_Revenue FROM Orders;

#12) Retrieve the total number of books sold for each genre:
SELECT b.Genre,SUM(o.Quantity) AS Quantity_Sold FROM Orders o
JOIN Books b ON o.Book_Id=b.Book_Id
GROUP BY Genre
ORDER BY Genre;

#13) Find the average price of books in the "Fantasy" genre:
SELECT Genre,AVG(Price) AS Average_Price FROM Books
WHERE Genre = 'Fantasy';

#14) List customers who have placed at least 2 orders:
SELECT c.Name,o.Customer_Id,COUNT(o.Order_Id) AS Total_count FROM Orders o
JOIN Customers c ON c.Customer_Id=o.Customer_Id
GROUP BY o.Customer_Id,c.Name
HAVING COUNT(o.Order_Id)>=2                #Having uses for aggregate/group conditions & use after group by
ORDER BY o.Customer_id;

#15) Find the most frequently ordered book:
SELECT b.Title,o.Book_Id,COUNT(o.Order_Id) AS Total_Quantity FROM Orders o
JOIN  Books b ON o.Book_Id=b.Book_Id
GROUP BY b.Title,o.Book_Id
ORDER BY COUNT(o.Order_Id) DESC
LIMIT 1;

#16)Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT * FROM Books
WHERE Genre="Fantasy"
ORDER BY Price DESC
LIMIT 3;

#17) Retrieve the total quantity of books sold by each author:
SELECT b.Author,o.Book_Id,SUM(Quantity) FROM Orders o
JOIN Books b ON o.Book_Id=b.Book_Id
GROUP BY b.Author,o.Book_Id
ORDER BY o.Book_Id;

#18) List the cities where customers who spent over $30 are located:
SELECT c.City,SUM(o.Total_Amount)  FROM Orders o
JOIN Customers c ON o.Customer_Id=c.Customer_Id
GROUP BY c.City,o.Customer_Id
HAVING SUM(o.Total_Amount)>30
ORDER BY SUM(o.Total_Amount); 

#19) Find the customer who spent the most on orders:
SELECT c.Name,o.Customer_Id,SUM(o.Total_Amount) AS Total_Amount FROM Orders o
JOIN Customers c ON o.Customer_Id=c.Customer_Id
GROUP BY c.Name,o.Customer_Id
ORDER BY Total_Amount DESC
LIMIT 3;

#20) Calculate the stock remaining after fulfilling all orders:
SELECT b.Title,b.Book_Id,b.Stock,COALESCE(SUM(o.Quantity),0) AS Order_Qty,b.Stock-COALESCE(SUM(o.Quantity),0) AS Balance_Stock FROM Books b
LEFT JOIN Orders o ON b.Book_Id=o.Book_Id
GROUP BY b.Title
ORDER BY b.Book_Id;
 