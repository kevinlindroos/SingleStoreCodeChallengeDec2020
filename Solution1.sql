CREATE DATABASE SingleStoreChallengeDec2020;
USE SingleStoreChallengeDec2020;

CREATE TABLE CustomerTag (CustomerID VARCHAR(25), Account VARCHAR(25), Tag VARCHAR(10));

DELIMITER //
CREATE OR REPLACE PROCEDURE spIngestCustomerData (batch query(pCustomerID VARCHAR(25) NOT NULL, pAccount VARCHAR(25) NOT NULL, pTags JSON NOT NULL))
AS
DECLARE tags ARRAY(JSON);
BEGIN

  FOR row IN COLLECT(batch) LOOP
    tags = JSON_TO_ARRAY(row.pTags);
    FOR tag IN tags LOOP
      INSERT CustomerTag (CustomerID, Account, Tag) 
      VALUES (row.pCustomerID, row.pAccount, REPLACE(tag, '"', ''));
    END LOOP;
  END LOOP;

END;
//
DELIMITER ;

CREATE OR REPLACE PIPELINE LoadFiles AS
LOAD DATA FS '/home/memsql/sampledata/*'
INTO PROCEDURE spIngestCustomerData
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n';

START PIPELINE LoadFiles FOREGROUND;

WITH CTE AS (
  SELECT CustomerTag.Tag AS tag, JSON_AGG(CustomerTag.CustomerID) AS matches
  FROM CustomerTag
  GROUP BY Tag
)
SELECT JSON_AGG(CTE.*)
FROM CTE;
