-- Churn Rate(%) 구하기
-- 웹사이트 : 사이트에 오늘 방문 ----> 90일 정도 후 방문 후 --
-- 우리 웹사이트는 1주일 기준, 3일 기준, 1달 기준 등 기준점은 모두 상이 
-- 분석하는 사람, 누가 이탈하는지 해서, 보고서를 상급자에 보고 
-- 상급자 회의 소집, 마케팅 플랜, 개발자한테 지시, 각 사용자에게 Push 메세지

USE classicmodels;

-- 현재 테이블의 가장 최근 날짜 
SELECT MAX(orderdate) MX_order
FROM orders
;

-- 현재 테이브의 가장 오래된 날짜
SELECT MIN(orderdate) MN_order
FROM orders
;

-- 각 고객의 마자막 구매일 
SELECT 
	customernumber
    , MAX(orderdate) 마지막구매일
FROM orders
GROUP BY 1
;

-- 현재 시점 2005-06-01
SELECT '2005-06-01';

-- 구하고 싶은 건, 
-- 2006-06-01 기준으로 가장 마지막에 구매한 날짜를 빼서 기간 구하기 
-- DATEDIFF()

SELECT 
	*
    , '2005-06-01' as 오늘날짜
    , DATEDIFF('2005-06-01', 마지막구매일) DIFF
FROM (
	SELECT 
	customernumber
    , MAX(orderdate) 마지막구매일
FROM orders
GROUP BY 1
) A 
;

SELECT 
	*
    , CURRENT_DATE as 오늘날짜
    , DATEDIFF( CURRENT_DATE, 마지막구매일) DIFF
FROM (
	SELECT 
	customernumber
    , MAX(orderdate) 마지막구매일
FROM orders
GROUP BY 1
) A 
;		

-- DIFF를 90일 기준으로 Churn (이탈발생) , Non-Churn (이탈미발생) 

SELECT 
	*
    , '2006-06-01' as 오늘날짜
    , DATEDIFF( '2006-06-01', 마지막구매일) DIFF
    , CASE 
    WHEN DATEDIFF( '2006-06-01', 마지막구매일) >= 90 THEN '이탈발생'
    ELSE '이탈미발생' END  AS Churn
FROM (
	SELECT 
	customernumber
    , MAX(orderdate) 마지막구매일
FROM orders
GROUP BY 1
) A
;		

SELECT
	*
    , CASE 
    WHEN DATEDIFF( '2006-06-01', 마지막구매일) >= 90 THEN '이탈발생'
    ELSE '이탈미발생' END  AS Churn
FROM (
SELECT 
	*
    , CURRENT_DATE as 오늘날짜
    , DATEDIFF( CURRENT_DATE, 마지막구매일) DIFF
FROM (
	SELECT 
	customernumber
    , MAX(orderdate) 마지막구매일
FROM orders
GROUP BY 1
) A 
) A 
;

SELECT 
	*
    , CASE WHEN DIFF >= 90 THEN '이탈발생' 
      ELSE '이탈미발생' 
      END 이탈유무
FROM (
	SELECT 
		*
		, '2005-06-01' AS 오늘날짜
		, DATEDIFF('2005-06-01', 마지막구매일) DIFF
	FROM (
		SELECT 
			customernumber 
			, MAX(orderdate) 마지막구매일
		FROM orders
		GROUP BY 1
	) A
) A
;

SELECT 
	이탈유무
    , COUNT(DISTINCT customernumber) N_CUS
FROM (
	SELECT 
		*
		, CASE WHEN DIFF >= 90 THEN '이탈발생' 
		  ELSE '이탈미발생' 
		  END 이탈유무
	FROM (
		SELECT 
			*
			, '2005-06-01' AS 오늘날짜
			, DATEDIFF('2005-06-01', 마지막구매일) DIFF
		FROM (
			SELECT 
				customernumber 
				, MAX(orderdate) 마지막구매일
			FROM orders
			GROUP BY 1
		) A
	) A
) A
GROUP BY 1
;

CREATE TABLE CLASSICMODELS.CHURN_LIST AS
SELECT CASE WHEN DIFF >= 90 THEN 'CHURN' ELSE 'NON-CHURN' END CHURN_TYPE,
CUSTOMERNUMBER
FROM
(SELECT CUSTOMERNUMBER,
MX_ORDER,
'2005-06-01' END_POINT,
DATEDIFF('2005-06-01',MX_ORDER) DIFF
FROM
(SELECT CUSTOMERNUMBER,
MAX(ORDERDATE) MX_ORDER
FROM CLASSICMODELS.ORDERS
GROUP
BY 1) BASE) BASE
;
-- Churn 고객이 가장 많이 구매한 ProductLine을 구해보자 
-- 

SELECT *
FROM productlines A 	-- products 테이블에 productLine 필드가 있어서 productLines의 테이블까지 사용할 필요가 없음 
	LEFT JOIN products B
    ON A.productLine = B.productLine
    
    LEFT JOIN orderDetails C
    ON B.productCode = C.productCode
    
    LEFT JOIN orders D
    ON C.orderNumber = D.orderNumber
    ;
    
SELECT 
	D.churn_type
	, C.productline,
	COUNT(DISTINCT B.customernumber) BU
FROM orderdetails A
LEFT
JOIN orders B
ON A.ordernumber = B.ordernumber
LEFT
JOIN products C
ON A.productcode = C.productcode
LEFT JOIN CHURN_LIST D
ON B.customernumber = D.customernumber
GROUP
BY 1, 2
HAVING churn_type = 'CHURN'
;

SELECT 
	C.productline,
	COUNT(DISTINCT B.customernumber) BU
FROM orderdetails A
LEFT
JOIN orders B
ON A.ordernumber = B.ordernumber
LEFT
JOIN products C
ON A.productcode = C.productcode
LEFT JOIN CHURN_LIST D
ON B.customernumber = D.customernumber
WHERE D.churn_type = 'CHURN'
GROUP BY 1
;

USE classicmodels;
SELECT 
	*
FROM churn_list;
SELECT 
		D.Churn_Type
	, A.productLine
, COUNT(DISTINCT C.customernumber) BU

FROM products A
LEFT JOIN  orderDetails B
ON A.productCode = B.productCode

LEFT JOIN orders C
ON B.orderNumber = C.orderNumber

LEFT JOIN churn_list D
ON C.customerNumber = D.customerNumber
WHERE D.churn_type = 'CHURN'
GROUP BY 2
;

USE mydata;
SELECT * FROM dataset2
ORDER BY age
;
-- 쇼핑몰, 리뷰 데이터
-- 댓글 분석, 감정 분석

SELECT 
	`Division Name`
    , AVG(RATING) AVG_RATE
FROM dataset2
GROUP BY 1
;

-- Trend의 평균령점이 3.85

-- 세부적인 내용을 확인 해보자 !! 
-- Department Name이 Trend 인 것만 조회 
-- RATING 이 3 점 이하인 것만 조회

SELECT *
FROM dataset2
WHERE `Department Name` = 'Trend'
	AND rating <= 3
;
-- 연령대를 10세 단위로 그룹핑 
-- 10-19세  => 10세
-- CASE WHEN AGE BETWEEN 10 AND 19 THEN '10세'

SELECT CASE WHEN AGE BETWEEN 0 AND 9 THEN '0009'
WHEN AGE BETWEEN 10 AND 19 THEN '1019'
WHEN AGE BETWEEN 20 AND 29 THEN '2029'
WHEN AGE BETWEEN 30 AND 39 THEN '3039'
WHEN AGE BETWEEN 40 AND 49 THEN '4049'
WHEN AGE BETWEEN 50 AND 59 THEN '5059'
WHEN AGE BETWEEN 60 AND 69 THEN '6069'
WHEN AGE BETWEEN 70 AND 79 THEN '7079'
WHEN AGE BETWEEN 80 AND 89 THEN '8089'
WHEN AGE BETWEEN 90 AND 99 THEN '9099' END AGEBAND,
AGE
FROM MYDATA.DATASET2
WHERE `DEPARTMENT NAME` = 'Trend'
AND RATING <= 3

;
-- 쉽게하는 방법
-- 나눗셈을 이용하자 16/10 1, 6, 6을 버린 후 뭔 조작을 하면 될것 같음 

SELECT 
	FLOOR (AGE/10) * 10 as 연령대 -- CAST() 활용하면 형병환 가능 , 문자 <=> 숫자
    , AGE
    , RATING <= 3
FROM DATASET2
GROUP BY 3

;

-- 연령대별 분포 : 평점 3이 이하 리뷰 
--

SELECT 
	FLOOR (AGE/10) * 10 as 연령대 -- CAST() 활용하면 형병환 가능 , 문자 <=> 숫자
    , COUNT(*) as CNT

FROM DATASET2
WHERE rating <= 3 AND `DEPARTMENT NAME` = 'Trend'
GROUP BY 1
ORDER BY 2 DESC
;
-- 50대 3점 이하 Trend 리뷰만 추출 

SELECT *
FROM DATASET2
WHERE `DEPARTMENT NAME` = 'Trend' AND rating <= 3 AND  Age between 50 and 59 limit 10
;

SELECT *
FROM DATASET2
WHERE `DEPARTMENT NAME` = 'Trend'
	AND rating <= 3
    AND AGE Between 50 and 59
;
SELECT `DEPARTMENT NAME`,
	clothingID
    , AVG(rating) AVG_RATE
FROM dataset2
GROUP BY 1, 2
;

SELECT *
	, ROW_NUMBER() OVER(PARTITION BY `DEPARTMENT NAME` ORDER BY AVG_RATE) RNK
FROM ( 
	SELECT `DEPARTMENT NAME`,
	clothingID
    , AVG(rating) AVG_RATE
FROM dataset2
GROUP BY 1, 2
) A
;

SELECT *
	, ROW_NUMBER() OVER(ORDER BY AVG_RATE) RNK
FROM ( 
	SELECT `DEPARTMENT NAME`,
	clothingID
    , AVG(rating) AVG_RATE
FROM dataset2
GROUP BY 1, 2
) A
;

-- 위 결과를 토대로, 
-- 1-10위 데이터 조회 필터링

SELECT * 
FROM (
	SELECT *
		, ROW_NUMBER() OVER(PARTITION BY `DEPARTMENT NAME` ORDER BY AVG_RATE)  RNK
	FROM ( 
		SELECT `DEPARTMENT NAME`,
		clothingID
		, AVG(rating) AVG_RATE
	FROM dataset2
	GROUP BY 1, 2
	) A
) A
WHERE RNK <= 10
;

CREATE TABLE mydata.stat AS
SELECT *
FROM (
	SELECT 
		*
		, ROW_NUMBER() OVER(PARTITION BY `Department Name` ORDER BY AVG_RATE) RNK
	FROM (
		SELECT 
			`Department Name`
			, ClothingID
			, AVG(rating) AVG_RATE
		FROM dataset2
		GROUP BY 1, 2
	) A
) A
WHERE RNK BETWEEN 1 AND 10
;

SELECT ClothingID From Stat
WHERE `Department Name` = 'Bottoms' 
;

SELECT * FROM dataset2;

-- 문제 Departmet 에서 Bottoms 불만족 (1위~10위인 리뷰 텍스트) stat 테이블에 가공되어 있음 를 가져오시오
-- 해당 ClothingID에 해당하는 리뷰 텍스트

-- 메인쿼리 : dataset2 에서 review text만 가져오기
-- 서브쿼리 : stat 테이블에 Department가 bottom인 ClothingID

SELECT `review text`
FROM dataset2
WHERE clothingid IN (
	SELECT clothingid 
	FROM stat
	WHERE `department name` = 'bottoms'
)
;

SELECT clothingid 
FROM stat
WHERE `department name` = 'bottoms'
;

SELECT 
    SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END) N_SIZE
    , COUNT(*) N_TOTAL
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END) / COUNT(*) AS ratio
FROM dataset2
;
SELECT SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END ) N_SIZE,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%LARGE%' THEN 1 ELSE 0 END ) N_LARGE,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%LOOSE%' THEN 1 ELSE 0 END ) N_LOOSE,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%SMALL%' THEN 1 ELSE 0 END ) N_SMALL,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%TIGHT%' THEN 1 ELSE 0 END ) N_TIGHT,
SUM(1) N_TOTAL
FROM MYDATA.DATASET2
;

-- SELECT clothingID, 1 FROM dataset2;
USE titanic;
SELECT * FROM titanic;
-- 중복값 유무확인 
-- 요인별 생존 여부 집계 
SELECT survived From titanic; -- 0은 사망 / 1은 생존

-- 성별에 따른 승객수와 생존자 수 구하기 
-- 비율도 같이 구해보기 

SELECT 
	SEX
    , count(passengerID) '승객수'
    , sum(survived) '생존자수'
    , round(sum(survived) / count(passengerID)*100, 3) "비율(%)"
FROM titanic

GROUP BY 1
;
-- 연령대별 승객수, 생존자수, 비율 구하기

SELECT 
	FLoor(AGE/10)*10 as 연령대
    -- hometown
    , sum(survived) '생존자수'
    , round(sum(survived) / count(passengerID)*100, 1) "비율(%)"

From titanic
GROUP BY 1
order by 1
;
-- 연령대별-성별 승객수, 생존자수, 비율 구하기

SELECT 
	FLoor(AGE/10)*10 as 연령대
    , SEX
    , sum(survived) '생존자수'
    , round(sum(survived) / count(passengerID)*100, 1) "비율(%)"

From titanic

GROUP BY 1,2
HAVING sex = 'female'
order by 1,2
;
-- 연령대별 남자 여자 각각의 생존율과 차이를 출력하라 
-- 인라인뷰에 조인문 만들기 
SELECT 
	A.연령대
    , A.Ratio as '여성생존자 비율(%)'
   , B.Ratio  as '남성생존자 비율(%)'
    , ROUND(A.Ratio  - B.Ratio , 2) AS DIFF
	
FROM (
	SELECT 
	FLoor(AGE/10)*10 as 연령대
    , SEX
    , sum(survived) '생존자수'
    , round(sum(survived) / count(passengerID)*100, 1) Ratio 

From titanic

GROUP BY 1,2
HAVING sex = 'female'
order by 1,2
    ) A 
    
    LEFT JOIN 
    (
    SELECT 
	FLoor(AGE/10)*10 as 연령대
    , SEX
    , sum(survived) '생존자수'
    , round(sum(survived) / count(passengerID)*100, 1) Ratio 
    

From titanic

GROUP BY 1,2
HAVING sex = 'male'
order by 1,2
) B
ON A.연령대 = B.연령대
;

SELECT 
	A.AGEBAND
    , A.ratio AS M_RATIO
    , B.ratio AS F_RATIO
    , ROUND(B.ratio - A.ratio, 2) AS DIFF
FROM (
	SELECT 
		FLOOR(AGE/10) * 10 AGEBAND 
		, sex
		, COUNT(passengerid) AS 승객수
		, SUM(survived) AS 생존자수
		, ROUND(SUM(survived) / COUNT(passengerid), 3) AS ratio
	 FROM titanic
	 GROUP BY 1, 2
	 HAVING sex = 'male'
	 ORDER BY 1, 2
) A
LEFT JOIN 
(
	SELECT 
		FLOOR(AGE/10) * 10 AGEBAND 
		, sex
		, COUNT(passengerid) AS 승객수
		, SUM(survived) AS 생존자수
		, ROUND(SUM(survived) / COUNT(passengerid), 3) AS ratio
	 FROM titanic
	 GROUP BY 1, 2
	 HAVING sex = 'female'
	 ORDER BY 1, 2
) B
ON A.AGEBAND = B.AGEBAND
;

-- 필드명 embarked
-- 승선 항구별 승객수
-- 승선 항구별 , 성별 승객 수
-- 승선 항구별, 성별 승객 비중(%) (결과표는 아래)
-- 인라인뷰 테이블 결합

SELECT embarked
	, sex
	, COUNT(passengerid) AS 승객수
FROM titanic
GROUP BY 1, 2
ORDER BY 1, 2
;

SELECT 
	A.Embarked
    , A.sex
    , ROUND(A.승객수 / B.승객수, 2) AS "승객비율(%)"
FROM (
SELECT embarked
	, sex
	, COUNT(passengerid) AS 승객수
FROM titanic
GROUP BY 1, 2
ORDER BY 1, 2
)A
LEFT JOIN
(SELECT embarked
	, sex
	, COUNT(passengerid) AS 승객수
FROM titanic
GROUP BY 1, 2
ORDER BY 1, 2
)B
ON A.embarked = B.embarked
;
SELECT 
	A.embarked
    , A.sex
    , A.승객수
    , B.승객수
    , ROUND(A.승객수 / B.승객수, 2) AS ratio
FROM (
	SELECT 
		embarked
		, sex
		, COUNT(passengerid) 승객수
	FROM titanic
	GROUP BY 1, 2
	ORDER BY 1, 2
) A 
LEFT JOIN (
	SELECT 
		embarked
		, COUNT(passengerid) 승객수
	FROM titanic
	GROUP BY 1
	ORDER BY 1
) B
ON A.embarked = B.embarked
;