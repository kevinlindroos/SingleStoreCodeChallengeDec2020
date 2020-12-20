CREATE DATABASE SingleStoreChallengeDec2020;
USE SingleStoreChallengeDec2020;

CREATE TABLE Customers (CustomerID VARCHAR(25), Account VARCHAR(25), Tags JSON NOT NULL);

CREATE OR REPLACE PIPELINE LoadFiles AS
LOAD DATA FS '/home/memsql/sampledata/*'
INTO TABLE Customers 
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n';

START PIPELINE LoadFiles FOREGROUND;

-- Solved
WITH CTE AS (
  SELECT table_col AS tag, JSON_AGG(CustomerID) AS matches
  FROM Customers
  JOIN TABLE(JSON_TO_ARRAY(Customers.Tags))
  GROUP BY tag
  ORDER BY COUNT(CustomerID) DESC
)
SELECT JSON_AGG(CTE.*)
FROM CTE
