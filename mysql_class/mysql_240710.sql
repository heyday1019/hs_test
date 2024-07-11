USE classicModels;
SELECT 
	A.Orderdate
    , priceeach * quantityordered AS 매출액
FROM ORDERS A 
LEFT JOIN orderdetails B
ON A.ordernumber = B.ordernumber
;

-- GROUP BY 절을 활용해서 
-- 일별 매출액을 구하시요 
SELECT 
	A.Orderdate
    , SUM(priceeach * quantityordered) AS 매출액
FROM ORDERS A 
LEFT JOIN orderdetails B
ON A.ordernumber = B.ordernumber
GROUP BY 1
ORDER BY 1
;

-- 도전 > 위의 내용을 시각화 해보자
-- SUBSTR : Python에서 말하는 슬라이싱 개념 
-- 인덱스 번호가 1부터 시작
SELECT SUBSTR("ABCDE", 1, 2);
SELECT SUBSTR('2003-1-06', 1, 7);

-- 월별 매출액 
SELECT 
	SUBSTR(A.Orderdate, 1, 7) AS 월별
    , SUM(priceeach * quantityordered) AS 매출액
    
FROM ORDERS A 
LEFT JOIN orderdetails B
ON A.ordernumber = B.ordernumber
GROUP BY 1
ORDER BY 1
;
SELECT 
	SUBSTR(A.Orderdate, 1, 4) 년도별
    , SUM(priceeach * quantityordered) 매출액
    
FROM ORDERS A 
LEFT JOIN orderdetails B
ON A.ordernumber = B.ordernumber
GROUP BY 1
ORDER BY 1
;
-- p.91 ) 일자별, 월별, 연도별, 구매자 수 
SELECT
	COUNT( ordernumber) 구매고객수
    , COUNT(DISTINCT ordernumber) 주문건수
FROM
	orders
;

-- 출력 필드명 : 연도, 구매고객수, 매출액
-- 테이블 : orders, orderdetails

SELECT 
	SUBSTR(A.Orderdate, 1, 4) AS 연도별
	, SUM(priceeach * quantityordered) AS 매출액
    , COUNT(distinct B.ordernumber) 구매고객수
    
FROM ORDERS A 
LEFT JOIN orderdetails B
ON A.ordernumber = B.ordernumber
GROUP BY 1
ORDER BY 1
;
SELECT 
	*
    
FROM ORDERS A 
LEFT JOIN orderdetails B
ON A.ordernumber = B.ordernumber
LEFT JOIN products C 
ON B.productCode = C.productCode
;

-- 출력 필드명 : 연도, 구매고객수, 매출액
-- 테이블 : orders, oderdetails
SELECT COUNT(*)
FROM orders A
LEFT JOIN orderdetails B
ON A.ordernumber = B.ordernumber
LEFT JOIN products C 
ON B.productcode = C.productcode
LEFT JOIN productlines D 
ON C.productline = D.productline
;

SELECT COUNT(*)
FROM products A
LEFT JOIN productlines B
ON A.productline = B.productline
LEFT JOIN orderdetails C 
ON A.productcode = C.productcode
LEFT JOIN orders D
ON C.ordernumber = D.ordernumber
;

-- 인당 구매고객 
SELECT 
	SUBSTR(A.Orderdate, 1, 4) AS 연도별
	, SUM(priceeach * quantityordered) AS 매출액
    , COUNT(distinct B.ordernumber) 구매고객수
    , SUM(priceeach * quantityordered) / COUNT(distinct B.ordernumber) 인당구매고객
    
FROM ORDERS A 
LEFT JOIN orderdetails B
ON A.ordernumber = B.ordernumber
GROUP BY 1
ORDER BY 1
;

-- 건당 구매고객 
SELECT 
 C.country 나라
 , C.city 도시
, SUM(priceeach * quantityOrdered) 매출액   
FROM  orders A
LEFT JOIN orderdetails B
ON A.orderNumber = B.orderNumber
LEFT JOIN customers C 
ON C.customerNumber = A.customerNumber
GROUP BY 1,2
ORDER BY 1

;

SELECT
	C.country
    , C.city
    , SUM(B.priceeach * B.quantityordered) AS 매출
FROM orders A
LEFT JOIN orderdetails B
ON A.ordernumber = B.ordernumber
LEFT JOIN customers C 
ON A.customernumber = C.customernumber
GROUP BY 1, 2
ORDER BY 1, 2
;

-- CASE WHEN
-- 조건문, IF-ELSE를 대신함 
-- 북미 VS 비북미 매출액 비교
SELECT
	CASE WHEN country IN ('USA' , 'Canada') THEN 'North America'
    ELSE 'Other' END country_grp
FROM customers
;

SELECT
	CASE WHEN country IN ('USA', 'Canada' ) THEN '북미'
		WHEN country IN ('France', 'Germany' ) THEN '유럽'
    ELSE 'Other' END country_grp
    , SUM(B.priceeach * B.quantityordered) AS 매출
FROM orders A
LEFT JOIN orderdetails B
ON A.ordernumber = B.ordernumber
LEFT JOIN customers C 
ON A.customernumber = C.customernumber
GROUP BY 1
ORDER BY 1
;

-- p.103, 매출 TOP5 국가 및 매출 
-- row_number, rank, dense_rank

CREATE TABLE CLASSICMODELS.STAT AS
SELECT C.COUNTRY,
SUM(PRICEEACH*QUANTITYORDERED) SALES
FROM CLASSICMODELS.ORDERS A
LEFT
JOIN CLASSICMODELS.ORDERDETAILS B
ON A.ORDERNUMBER = B.ORDERNUMBER
LEFT
JOIN CLASSICMODELS.CUSTOMERS C
ON A.CUSTOMERNUMBER = C.CUSTOMERNUMBER
GROUP
BY 1
ORDER
BY 2 DESC
;
SELECT * FROM stat;
SELECT 
	country
    ,sales
    , DENSE_RANK() OVER(ORDER BY SALES DESC) RNK
FROM stat
WHERE RNK BETWEEN 1 AND 5
; -- 에러가 납니다. 

-- QUERY 실행하는 순서 
-- FROM ==> WHERE ==> GROUP BY ==> HAVING ==> SELECT

CREATE TABLE stat_rnk as
SELECT 
	country
    ,sales
    , DENSE_RANK() OVER(ORDER BY SALES DESC) RNK
FROM stat
;


SELECT *
FROM stat_rnk
WHERE RNK BETWEEN 1 AND 5
;

-- 서브쿼리 
SELECT * FROM employees;
SELECT * FROM offices;

-- USA에 거주하는 직원의 이름을 출력하세요 

SELECT lastName, firstName, country
FROM employees A 
LEFT JOIN offices B 
ON A.officeCode = B.officeCode
WHERE country = 'USA' 
;

SELECT lastName, firstName
FROM employees
WHERE officeCode IN (
	SELECT officeCode
    FROM offices
    WHERE country = 'USA' 
    )
;
SELECT OfficeCode
FROM offices
where country = 'USA'
;

-- 문제, amount가 최대값인 것을 조회하세요 
-- 조회해야할 필드명 : customerName, checkNumber, amount 

-- 메인쿼리 
SELECT * FROM payments;
SELECT 
	customerNumber, checkNumber, amount 
FROM payments;

-- 서브쿼리 
SELECT MAX(amount) FROM payments;

SELECT * FROM payments;

SELECT 
	customerNumber, checkNumber, amount 
FROM payments
WHERE amount = (select MAX(amount) From payments)
;

-- 테이블 : customers, orders
-- 문제 : 전체의 고객중에서 주문을 하지 않은 고객을 찾으세요!!
-- 조회해야 할 필드명 : customerName 
-- 메인쿼리 : 고객명 조회 from customers
-- 서브궈리 : 주문한 고객 from orders


-- 메인 쿼리 
SELECT customerName
FROM customers;

-- 서브쿼리
SELECT DISTINCT customerNumber
FROM orders;

SELECT customerName
FROM customers
WHERE customerNumber NOT IN (
SELECT DISTINCT customerNumber
FROM orders)
;

-- 인라인 뷰 : FROM
SELECT 
	orderNumber
    , count(ordernumber) as items
FROM orderdetails
group by 1
;

-- 각 주문건당 최소, 최대, 평균을 구하고 싶습니다.
SELECT
MIN(items), MAX(items), AVG(items)
FROM (
	SELECT 
		orderNumber
		, count(ordernumber) as items
	FROM orderdetails
	group by 1
) A
;

-- stat 테이블 저장
-- stat_rnk 테이블 저장

SELECT *
FROM stat_rnk
WHERE RNK BETWEEN 1 AND 5
;
-- 위 쿼리 결과는 동일
-- 인라인 뷰 서브쿼리가 2번 사용됨 

SELECT *
FROM
(SELECT COUNTRY,
SALES,
DENSE_RANK() OVER(ORDER BY SALES DESC) RNK
FROM
(SELECT C.COUNTRY,
SUM(PRICEEACH*QUANTITYORDERED) SALES
FROM CLASSICMODELS.ORDERS A
LEFT
JOIN CLASSICMODELS.ORDERDETAILS B
ON A.ORDERNUMBER = B.ORDERNUMBER
LEFT
JOIN CLASSICMODELS.CUSTOMERS C
ON A.CUSTOMERNUMBER = C.CUSTOMERNUMBER
GROUP
BY 1) A) A
WHERE RNK <= 5
;

-- 
SELECT C.COUNTRY,
SUBSTR(A.ORDERDATE,1,4) YY,
COUNT(DISTINCT A.CUSTOMERNUMBER) BU_1,
COUNT(DISTINCT B.CUSTOMERNUMBER) BU_2,
COUNT(DISTINCT B.CUSTOMERNUMBER)/COUNT(DISTINCT A.CUSTOMERNUMBER)
RETENTION_RATE
FROM CLASSICMODELS.ORDERS A
LEFT
JOIN CLASSICMODELS.ORDERS B
ON A.CUSTOMERNUMBER = B.CUSTOMERNUMBER AND SUBSTR(A.ORDERDATE,1,4)
= SUBSTR(B.ORDERDATE,1,4)-1
LEFT
JOIN CLASSICMODELS.CUSTOMERS C
ON A.CUSTOMERNUMBER = C.CUSTOMERNUMBER
GROUP
BY 1,2
;

-- 셀프 조인 
SELECT *
FROM orders A
LEFT JOIN orders B
ON A.customerNumber = B.customerNumber
	AND SUBSTR(A.orderdate,1, 4) = SUBSTR(B.orderdate,1 ,4) -1
;

SELECT *
FROM orders A
LEFT JOIN orders B
ON A.customerNumber = B.customerNumber
	AND SUBSTR(A.orderdate,1, 4) = SUBSTR(B.orderdate,1 ,4) -1
    
-- BEST SELLER
-- 미국 고객의 Retention Rate 가 제일 높음 확인
-- 미국에 집중 
-- 미국의 TOP5 차량 모델 추출을 부탁   
-- 차량모델별로 매출이 가장 잘 나온 것 Top5
-- 차량모델별로 매출액 구하기 

SELECT * 
FROM orders A
LEFT JOIN customers B
ON A.customerNumber = B.customerNumber
LEFT JOIN orderDetails C
ON A.orderNumber = C.orderNumber
LEFT JOIN products D
ON C.productCode = D.productCode
-- WHERE B.country = 'USA'
;

SELECT * 
FROM (
	SELECT 
		* 
		, ROW_NUMBER() OVER(ORDER BY Sales DESC) RNK
	FROM (
		SELECT 
			D.productName
			, SUM(C.priceeach * C.quantityordered) AS Sales
		FROM orders A
		LEFT JOIN customers B
		ON A.customernumber = B.customernumber
		LEFT JOIN orderdetails C
		ON A.ordernumber = C.ordernumber
		LEFT JOIN products D
		ON C.productcode = D.productcode
		WHERE B.country = 'USA'
		GROUP BY 1
	) A 
) A
WHERE RNK BETWEEN 1 AND 5
;
SELECT 
			D.productName
			, SUM(C.priceeach * C.quantityordered) AS Sales
FROM orders A
RIGHT JOIN customers B
ON A.customerNumber = B.customerNumber
RIGHT JOIN orderDetails C
ON A.orderNumber = C.orderNumber
RIGHT JOIN products D
ON C.productcode = D.productcode
WHERE B.country = 'USA'
;