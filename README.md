# SingleStore Code Challenge December 2020

## Files
  - file1.txt (data for the first row)
  - file2.txt (data for the second row)
  - file3.txt (data for the third row)
  - Solution1.sql (initial solution)
  - Solution2.sql (working on a more elegant solution)

## Notes

Solution2.sql will be posted when I'm finished with a more elegant solution to the problem. I would prefer to load the data like this (without a stored procedure):

```sql
CREATE TABLE Customers (CustomerID VARCHAR(25), Account VARCHAR(25), Tags JSON NOT NULL);

CREATE OR REPLACE PIPELINE LoadFiles AS
LOAD DATA FS '/home/memsql/sampledata/*'
INTO TABLE Customers 
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n';
```

...then output the results with a single query. I'm working on this.