CREATE DATABASE SingleStoreChallengeDec2020;
USE SingleStoreChallengeDec2020;

CREATE TABLE Customers (CustomerID VARCHAR(25), Account VARCHAR(25), Tags JSON NOT NULL);

CREATE OR REPLACE PIPELINE LoadFiles AS
LOAD DATA FS '/home/memsql/sampledata/*'
INTO TABLE Customers 
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n';

START PIPELINE LoadFiles FOREGROUND;

-- Incomplete. More to follow...
WITH CTE AS (
  SELECT TO_JSON(Customers.*) AS jsonData
  FROM Customers
)
SELECT *
FROM CTE
