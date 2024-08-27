-- 테이블 생성 
USE testdB;

CREATE TABLE vehicles (
	vehicleId INT
    , year INT NOT NULL
    , make VARCHAR(100) NOT NULL, 
    PRIMARY KEY(vehicleId)
)
;

-- 필드 1개 추가 
-- ALTER TABLE 명령어 
ALTER TABLE vehicles
ADD model VARCHAR(100) NOT NULL
;

DESCRIBE vehicles;

-- COLOR 필드추가 
ALTER TABLE vehicles
ADD COLOR varchar(100) NOT NULL
;


-- 테이블 생성 시, 테이블 정의서 or 명세서 
ALTER TABLE vehicles
ADD NOTE varchar(100)
;
-- ALTER TABLE ~ MODIFY
ALTER TABLE vehicles
MODIFY NOTE varchar(100) NOT NULL;

-- 컬럼명 변경

ALTER TABLE vehicles
CHANGE COLUMN NOTE vehicleCondition varchar(50) NOT NULL
;

-- 컬럼만 삭제 
ALTER TABLE vehicles
DROP COLUMN vehicleCondition
;

DESCRIBE vehicles;

-- 테이블명 변경
ALTER TABLE vehicles
RENAME TO CARs;

DESC vehicles;
DESC cars;

COMMIT;

SHOW DATABASES;

USE book_ratings;
CREATE TABLE books(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100),
    author VARCHAR(100),
    genre VARCHAR(100),
    release_year YEAR(4)
);

-- DROP books;

SELECT *
FROM books
;
DESC books;