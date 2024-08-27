-- 데이터 트렌드 분석 실전편
-- retail_sales 데이터를 불러온다. 
SELECT * FROM retail_sales;

-- 문제 1. 미국 전체 소매업과 외식업의 매출 트렌드를 검토한다. 
SELECT 
    sales_month
    , sales
FROM retail_sales 
WHERE kind_of_business = 'Retail and food services sales, total'
ORDER BY 1;

-- 문제 2. 시각화를 하면 약간의 노이즈가 보인다. 데이터를 변형한다. 
-- 그러기 위해서는 sales_month에서 연도 값만 가져오는 코드를 작성해야 한다. 
-- EXTRACT() 함수를 활용하여 구해본다. 
SELECT 
    EXTRACT(YEAR FROM sales_month) as sales_year
    , sum(sales) AS sales
FROM retail_sales
WHERE kind_of_business = 'Retail and food services sales, total'
GROUP BY EXTRACT(YEAR FROM sales_month)
ORDER BY 1;

-- 문제 3. 요소 비교
-- 세부 업종별 매출 데이터를 연도별로 표시를 하도록 한다. 
-- 비교 업종은 
-- Men's Clothing Stores & Women's Clothing Stores 
SELECT 
    sales_month
    , kind_of_business
    , sales
FROM retail_sales
WHERE kind_of_business in ('Men''s clothing stores', 'Women''s clothing stores')
ORDER BY 1, 2;

-- 위 쿼리에서 연도만 추출하는 쿼리로 재 수정해본다.  
SELECT 
    EXTRACT(YEAR FROM sales_month) as sales_year
    , kind_of_business
    , SUM(sales) as sales
FROM retail_sales
WHERE kind_of_business in ('Men''s clothing stores', 'Women''s clothing stores')
GROUP BY EXTRACT(YEAR FROM sales_month), kind_of_business
ORDER BY 1, 2;

-- 문제 4: 두 업종 간 매출 차이, 비율, 비율 차이를 계산한다. 
-- 위 쿼리에서 연도만 추출하는 쿼리로 재 수정해본다.  
SELECT 
    EXTRACT(YEAR FROM sales_month) as sales_year
    , SUM(CASE WHEN kind_of_business = 'Men''s clothing stores' 
               THEN sales
               END) AS mens_sales
    , SUM(CASE WHEN kind_of_business = 'Women''s clothing stores'
               THEN sales
               END) AS womens_sales
FROM retail_sales
WHERE kind_of_business in ('Men''s clothing stores', 'Women''s clothing stores')
GROUP BY EXTRACT(YEAR FROM sales_month)
ORDER BY 1;

-- 문제 5. 여성 의류업과 남성 의류업의 연간 매출 차이를 비교한다. 
-- 2020년 데이터는 NULL을 포함하므로 WHERE절에 날짜 조건을 사용해 2020년 이전의 데이터만 사용한다. 
-- 서브쿼리를 이용하는 방식
SELECT 
    sales_year
    , mens_sales - womens_sales AS 남성_여성
    , womens_sales - mens_sales AS 여성_남성
FROM (
    SELECT 
        EXTRACT(YEAR FROM sales_month) as sales_year
        , SUM(CASE WHEN kind_of_business = 'Men''s clothing stores' 
                THEN sales
                END) AS mens_sales
        , SUM(CASE WHEN kind_of_business = 'Women''s clothing stores'
                THEN sales
                END) AS womens_sales
    FROM retail_sales
    WHERE kind_of_business in ('Men''s clothing stores', 'Women''s clothing stores') 
        AND sales_month <= '2019-12-01'
    GROUP BY EXTRACT(YEAR FROM sales_month)
) A
ORDER BY 1;

-- 집계함수끼리도 더하거나 뺄 수 있음
-- 여성 의류업 매출에서 남성 의류업 매출을 뺀 값을 구한다. 
-- 결과 확인 : 연간 매출 차이는 1992년 ~ 1997년 사이에 감소하고 
-- 2007년에 잠시 줄어든 것을 제외하면
-- 2011년까지 계속해서 증가하다가 2019년부터 거의 평평해짐 
SELECT 
    EXTRACT(YEAR FROM sales_month) as sales_year
    , SUM(CASE WHEN kind_of_business = 'Women''s clothing stores' THEN sales END)
    - SUM(CASE WHEN kind_of_business = 'Men''s clothing stores' THEN sales END) AS 여성_남성
FROM retail_sales
WHERE kind_of_business in ('Men''s clothing stores', 'Women''s clothing stores') 
        AND sales_month <= '2019-12-01'
GROUP BY EXTRACT(YEAR FROM sales_month)
ORDER BY 1;

-- 전체 대비 비율 계산
-- 남성 의류업과 여성 의류업의 매출 비율을 계산한다. 
-- 윈도우 함수 사용
SELECT 
    sales_month
    , kind_of_business
    , sales
    , SUM(sales) OVER (PARTITION BY sales_month) AS total_sales
    , ROUND(sales * 100 / SUM(sales) OVER (PARTITION BY sales_month), 2) AS pct_total
FROM retail_sales
WHERE kind_of_business IN ('Men''s clothing stores', 'Women''s clothing stores')
ORDER BY 1, 2
;

-- 문제 6. Sporting goods stores의 비율 변화를 확인한다. 
-- 예) 소비자 물가지수 : CPI
-- PARTITION BY & FIRST_VALUE 활용
SELECT 
    sales_year
    , sales
    , ROUND((sales / FIRST_VALUE(sales) OVER (ORDER BY sales_year) - 1) * 100, 2) AS pct_from_index
FROM (
    SELECT 
        EXTRACT(YEAR FROM sales_month) AS sales_year
        , SUM(sales) AS sales
    FROM retail_sales
    WHERE kind_of_business = 'Sporting goods stores' -- 'Women''s clothing stores'
    GROUP BY EXTRACT(YEAR FROM sales_month)
) A
;

-- 문제 7. 구간 비교
-- 전년 동월, 매출을 비교하는 쿼리를 작성한다. 
-- 구간은 1998-01-01 ~ 2000-12-01
-- 업종은 'Sporting goods stores' 이다. 
SELECT 
    EXTRACT(MONTH FROM sales_month) AS month_number
    , DATE_FORMAT(sales_month, '%M') AS month_name
    , MAX(CASE WHEN EXTRACT(YEAR FROM sales_month) = 1998 THEN sales END) AS sales_1998
    , MAX(CASE WHEN EXTRACT(YEAR FROM sales_month) = 1999 THEN sales END) AS sales_1999
    , MAX(CASE WHEN EXTRACT(YEAR FROM sales_month) = 2000 THEN sales END) AS sales_2000
FROM retail_sales
WHERE kind_of_business = 'Sporting goods stores' 
    AND sales_month BETWEEN '1998-01-01' AND '2000-12-01'
GROUP BY EXTRACT(MONTH FROM sales_month), DATE_FORMAT(sales_month, '%M')
ORDER BY month_number;

-- 17:20분까지 코드 잘 정리하세요~ 



