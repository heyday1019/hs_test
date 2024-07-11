USE classicmodels; -- 해당 Database를 사용하겠음
CREATE SCHEMA mydata2;
SHOW databases;


USE classicmodels;
SELECT * FROM customers;

SELECT * FROM customers; -- Ctrl + Enter

SELECT * FROM classicmodels.custoers; -- 이렇게 하기 귀찮아 USE로 선언함
USE classicmoels; -- 사용
SHOW tables;
SELECT * FROM customers; -- 간결하게

-- customerNumber, customerName, contactLastName, contactFirstName, phone, addressLine1, addressLine2, city, state, postalCode, country, salesRepEmployeeNumber, creditLimit

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

-- WHERE 조건 : 필터링 
SELECT *
FROM
	customers
WHERE country = 'USA'
;


SELECT *
FROM
	customers
WHERE customerNumber = '112'
;
SELECT database();
USE classicmodels;
SELECT * FROM customers;
SELECT customerNumber as customerNumbers2
FROM customers
WHERE customerNumbers2 = 112;

SELECT *
FROM
	customers
WHERE customerNumber >= 112
;

SELECT *
FROM
	customers
WHERE customerNumber < 112
;

SELECT *
FROM
	customers
WHERE customerNumber <= 112
;
SELECT DATABASE();

-- 문자열과 부동호 연산자 
SELECT state
FROM 
	customers
WHERE 
	state  <>'D'; -- 부호 '<>' 포함되지 않는다 부호 
    
-- WHERE LIKE 연산자
SELECT * FROM customers
WHERE customerName LIKE '% gift %'; -- customerName 컬럼에서 'gift'가 들어간 이름의 열을 출력한다 / like 연산자는 특정 문자열이 들어간 값을 찾을 때 사용 

-- 문자열 검색할 때 가장 유용한것 : 정규분포식을 활용한 검색 
-- 매우 어려움, 근데 무조건 필요함!! 

SELECT * FROM customers
WHERE customerName REGEXP 'La*'; 

-- AND 
-- [문제] country 가 USA 이면서 city NYC 인 고객을 조회하시오
SELECT *
FROM customers
WHERE country = 'USA' AND city = 'NYC';

-- OR 조건 
SELECT *
FROM customers
WHERE country = 'USA' OR contactLastName = 'LEE'
;

-- 테이블 Payments

SELECT * FROM payments;

-- BETWEEN 연산자
SELECT *
FROM
	payments
WHERE 
amount BETWEEN 10000 AND 50000
AND paymentDate BETWEEN '2003-05-20' AND '2004-12-17'
AND checkNumber LIKE '%JM%'
;

-- IN 연산자 
SELECT *
FROM
	offices
WHERE country IN ('USA', 'FRANCE', 'UK')
;
SELECT *
FROM
	offices
WHERE country NOT IN ('USA', 'FRANCE', 'UK')
;
/*
SELECT 필드명 
FROM 테이블명 
WHERE 필드명에 관한 여러조건식 
ORDER BY 필드값 기준 정렬 
GROUP BY 동일한 필드값을 group화 하여 묶음 
*/
-- ORDER BY 절, sort_values(), 정렬
SELECT *
FROM orders
ORDER BY orderNumber ASC -- 오름차순
;

SELECT customerNumber, orderNumber
FROM orders
ORDER BY customerNumber ASC -- 오름차순
;

SELECT customerNumber, orderNumber
FROM orders
ORDER BY 1 ASC, 2 DESC -- 1:customerNumber 은 오름차순 / 2:orderNumber 는 내림차순 
;

-- GROUP BY와 HAVING
SELECT * FROM orders;
SELECT 
	DISTINCT status -- 중복값 제거 
FROM orders
;
SELECT 
	status
FROM 
	orders
GROUP BY
	status
;
SELECT 
	status
    , COUNT(*) AS "갯수"
FROM 
	orders
GROUP BY
	status
HAVING COUNT(*) >= 5 -- MYSQL에서 COUNT(*) 대신 Alias 한 "갯수"도 가능하지만 다른 DBMS마다 다르다 (Oracle, MS-SQL..)
ORDER BY 2 DESC
;

SELECT
	country
    , city
	, COUNT(*)
FROM 
	customers
GROUP BY country 
-- Error Code: 1055. Expression #2 of SELECT list is not in GROUP BY clause and contains nonaggregated column 'classicmodels.customers.city' which is not functionally dependent on columns in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by
;

SELECT
	country
    , city
	, COUNT(*)
FROM 
	customers
GROUP BY country, city
;
SELECT customerNumber as customerNumber2
FROM customers
;
SELECT * FROM customers;