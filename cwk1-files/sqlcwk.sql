/*
@author Aidan Hardiman

This is an sql file to put your queries for SQL coursework. 
You can write your comment in sqlite with -- or /* * /

To read the sql and execute it in the sqlite, simply
type .read sqlcwk.sql on the terminal after sqlite3 musicstore.db.
*/

/* =====================================================
   WARNNIG: DO NOT REMOVE THE DROP VIEW
   Dropping existing views if exists
   =====================================================
*/
DROP VIEW IF EXISTS vNoCustomerEmployee; 
DROP VIEW IF EXISTS v10MostSoldMusicGenres; 
DROP VIEW IF EXISTS vTopAlbumEachGenre; 
DROP VIEW IF EXISTS v20TopSellingArtists; 
DROP VIEW IF EXISTS vTopCustomerEachGenre; 

/*
============================================================================
Task 1: Complete the query for vNoCustomerEmployee.
DO NOT REMOVE THE STATEMENT "CREATE VIEW vNoCustomerEmployee AS"
============================================================================
*/
CREATE VIEW vNoCustomerEmployee AS
SELECT EmployeeId, FirstName, LastName, Title
FROM employees
WHERE EmployeeId NOT IN (SELECT SupportRepId FROM customers);


/*
============================================================================
Task 2: Complete the query for v10MostSoldMusicGenres
DO NOT REMOVE THE STATEMENT "CREATE VIEW v10MostSoldMusicGenres AS"
============================================================================
*/
CREATE VIEW v10MostSoldMusicGenres AS
SELECT g.Name AS Name, SUM(ii.Quantity) AS Sales 
FROM genres g
JOIN tracks t ON g.genreId = t.GenreId
JOIN invoice_items ii ON t.TrackId = ii.TrackId
GROUP BY g.Name
ORDER BY Sales DESC
LIMIT 10;


/*
============================================================================
Task 3: Complete the query for vTopAlbumEachGenre
DO NOT REMOVE THE STATEMENT "CREATE VIEW vTopAlbumEachGenre AS"
============================================================================
*/
CREATE VIEW vTopAlbumEachGenre AS
SELECT
   g.Name AS Genre,
   a.Title AS Album,
   ar.Name AS Artist,
   SUM(ii.Quantity) AS Sales
FROM genres g
JOIN tracks t ON g.GenreId = t.GenreId
JOIN albums a ON t.AlbumId = a.AlbumId
JOIN artists ar ON a.ArtistId = ar.ArtistId
JOIN invoice_items ii ON t.TrackId = ii.TrackId
GROUP BY g.Name;


/*
============================================================================
Task 4: Complete the query for v20TopSellingArtists
DO NOT REMOVE THE STATEMENT "CREATE VIEW v20TopSellingArtists AS"
============================================================================
*/

CREATE VIEW v20TopSellingArtists AS
SELECT 
   ar.Name AS Artist,
   COUNT(DISTINCT a.AlbumId) AS TotalAlbum,
   SUM(ii.Quantity) AS TrackSold
FROM artists ar
JOIN albums a ON ar.ArtistId = a.ArtistId
JOIN tracks t ON a.AlbumId = t.AlbumId
JOIN invoice_items ii ON t.TrackId = ii.TrackId
GROUP BY ar.ArtistId
ORDER BY TrackSold DESC
LIMIT 20;


/*
============================================================================
Task 5: Complete the query for vTopCustomerEachGenre
DO NOT REMOVE THE STATEMENT "CREATE VIEW vTopCustomerEachGenre AS" 
============================================================================
*/
CREATE VIEW vTopCustomerEachGenre AS
SELECT
   g.name AS Genre,
   c.FirstName || ' ' || c.LastName AS TopSpender,
   ROUND(MAX(sp.TotalSpending), 2) AS TotalSpending
FROM genres g
JOIN tracks t ON g.GenreId = t.GenreId
JOIN albums a ON t.AlbumId = a.AlbumId
JOIN invoice_items ii ON t.TrackId = ii.TrackId
JOIN invoices inv ON ii.InvoiceId = inv.InvoiceId
JOIN customers c ON inv.CustomerId = c.CustomerId
JOIN (
    SELECT
        g.GenreId,
        c.CustomerId,
        SUM(ii.Quantity * ii.UnitPrice) AS TotalSpending
    FROM genres g
    JOIN tracks t ON g.GenreId = t.GenreId
    JOIN albums a ON t.AlbumId = a.AlbumId
    JOIN invoice_items ii ON t.TrackId = ii.TrackId
    JOIN invoices inv ON ii.InvoiceId = inv.InvoiceId
    JOIN customers c ON inv.CustomerId = c.CustomerId
    GROUP BY g.GenreId, c.CustomerId
) AS sp ON g.GenreId = sp.GenreId AND c.CustomerId = sp.CustomerId
GROUP BY g.GenreId
ORDER BY g.Name;