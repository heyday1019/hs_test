USE classicmodels; -- 해당 Database를 사용하겠음
CREATE SCHEMA mydata2;
SHOW databases;


SELECT * FROM customers; -- Ctrl + Enter

SELECT * FROM classicmodels.custoers; -- 이렇게 하기 귀찮아 USE로 선언함
USE classicmoels; -- 사용
SHOW tables;
SELECT * FROM customers; -- 간결하게


-- 현재 사용중인 스키마를 확인
SELECT DATABASE();
USE sakila;

--
DESC customers;

-- SELECT  : 필드를 선택하다 
SELECT * FROM customers;
SELECT customerNumber, customerName, contactFirstNaem FROM customers;
SELECT 
	customerNumber
    , customerName
    , contactFirstName
FROM
	customers
;
-- customerNumber, customerName, contactLastName, contactFirstName, phone, addressLine1, addressLine2, city, state, postalCode, country, salesRepEmployeeNumber, creditLimit

