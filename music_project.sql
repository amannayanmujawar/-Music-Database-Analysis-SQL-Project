create database music_database;

use music_database;

select * from album;

-- Question Set 1:- Easy
-- Q 1) Who is the senior most employee based on job title?

select * from employee 
order by levels 
desc limit 1;

 -- Q 2) which countries have the most Invoice ?
 
 select count(*) as c ,billing_country 
 from invoice 
 group by billing_country
 order by  c desc;
 
 -- Q3) what are top 3 values of total invoice 
 
 select total from invoice 
 order by total desc
 limit 3;
 
 -- Q 4) which city has the customers? we would like to throw a promotional  music festival in the city 
 -- we made the most money. write a query that returns one city that has the highest sum of invoice totals.
 -- Returns both the city name and sum of all invoice totals
 
 select sum(total) as invoice_total ,billing_city 
 from invoice
 group by billing_city
 order by  invoice_total desc;
 
 -- 5) Whos is the best customer ? THe customer who has spent the most Money
 --  will be declared the best customer .write a query that returns 
 -- the person who has spent the most money.
 
 select customer.customer_id , customer.first_name, customer.last_name , sum(invoice.total) as total
 from customer
 JOIN invoice ON customer.customer_id = invoice.customer_id
 group by customer.customer_id,customer.first_name , customer.last_name
 order by total desc
 limit 1;
 
 -- Question Set 2 :- Moderate 
 
 -- Q 1) write query to return the email ,first name ,last name, and Genre 
 -- of all Rock music listeners .
 -- Return your list ordered alphabetically by email starting with A
 
 SELECT DISTINCT email,first_name,last_name FROM customer
 JOIN INVOICE ON CUSTOMER.CUSTOMER_ID = INVOICE.CUSTOMER_ID
 JOIN INVOICE_LINE ON INVOICE.INVOICE_ID = INVOICE_LINE.INVOICE_ID
 WHERE TRACK_ID IN(
 SELECT TRACK_ID FROM TRACK 
 JOIN GENRE ON TRACK.GENRE_ID = GENRE.GENRE_ID
 WHERE GENRE.NAME LIKE 'Rock'
 )
 ORDER BY EMAIL;
 
 -- Q 2) Let's invite the artist who have written the most rock music in our dataset .
 -- write a query that returns the artist name and total track 
 -- count of the top 10 rock bands 
 
 SELECT ARTIST.ARTIST_ID,ARTIST.NAME,COUNT(ARTIST.ARTIST_ID) AS NUMBER_OF_SONGS
 FROM TRACK
 JOIN ALBUM ON ALBUM.ALBUM_ID = TRACK.ALBUM_ID
 JOIN ARTIST ON ARTIST.ARTIST_ID = ALBUM.ARTIST_ID
 JOIN GENRE ON GENRE.GENRE_ID = TRACK.GENRE_ID
 WHERE GENRE.NAME LIKE 'Rock'
 GROUP BY ARTIST.ARTIST_ID,ARTIST.NAME
 ORDER BY NUMBER_OF_SONGS DESC
 LIMIT 10;
 
 -- Q3) Return all the track names that have a song leangth longer than the 
 -- average song leangth .Return the name and milliseconds for each track 
 -- order by the song leangth with the longest songs  listed first 
 
 SELECT NAME , MILLISECONDS
 FROM TRACK
 WHERE MILLISECONDS > (SELECT AVG(MILLISECONDS) AS AVG_TRACK_LENGTH FROM TRACK)
 ORDER BY MILLISECONDS DESC;
 
 -- Question set 3 - Advance
 
 -- Q 1) Find how much amount spent by each customer on artists? 
 -- write a query to return customer name,artist name and total spent
 
 WITH BEST_SELLING_ARTIST AS(
 SELECT ARTIST.ARTIST_ID AS ARTIST_ID ,ARTIST.NAME AS ARTIST_NAME,
 SUM(INVOICE_LINE.UNIT_PRICE*INVOICE_LINE.QUANTITY)
 FROM INVOICE_LINE
 JOIN TRACK ON TRACK.TRACK_ID = INVOICE_LINE.TRACK_ID
 JOIN ALBUM ON ALBUM.ALBUM_ID = TRACK.ALBUM_ID
 JOIN ARTIST ON ARTIST.ARTIST_ID = ALBUM.ARTIST_ID
 GROUP BY 1,2
 ORDER BY 3 DESC
 LIMIT 1 )
 SELECT CUSTOMER.CUSTOMER_ID,CUSTOMER.FIRST_NAME,CUSTOMER.LAST_NAME,BEST_SELLING_ARTIST.ARTIST_NAME,
 SUM(INVOICE_LINE.UNIT_PRICE*INVOICE_LINE.QUANTITY) AS AMOUNT_SPENT
 FROM INVOICE
 JOIN CUSTOMER  ON CUSTOMER.CUSTOMER_ID = INVOICE.CUSTOMER_ID
 JOIN INVOICE_LINE ON INVOICE_LINE.INVOICE_ID = INVOICE.INVOICE_ID
 JOIN TRACK ON TRACK.TRACK_ID = INVOICE_LINE.TRACK_ID
 JOIN ALBUM ON ALBUM.ALBUM_ID = TRACK.ALBUM_ID
 JOIN BEST_SELLING_ARTIST ON BEST_SELLING_ARTIST.ARTIST_ID = ALBUM.ARTIST_ID
 GROUP BY 1,2,3,4
 ORDER BY 5 DESC;
 
 -- Q) 2 We want find out the popular music genre for each country .
 -- we determin the most popular genre as the genre with the highest amount of purchses 
 -- write a query that returns each country along with the top genre 
 -- For countries where the maximum number of purchases is shared returns all genres is shared retuens all genres
 
 WITH POPULAR_GENRE AS (
 SELECT COUNT(INVOICE_LINE.QUANTITY) AS PURCHASES,CUSTOMER.COUNTRY,GENRE.NAME,GENRE.GENRE_ID,
 ROW_NUMBER() OVER(PARTITION BY CUSTOMER.COUNTRY 
 ORDER BY COUNT(INVOICE_LINE.QUANTITY) DESC) AS ROWNO
 FROM INVOICE_LINE
 JOIN INVOICE ON INVOICE.INVOICE_ID = INVOICE_LINE.INVOICE_ID
 JOIN CUSTOMER ON CUSTOMER.CUSTOMER_ID = INVOICE.CUSTOMER_ID
 JOIN TRACK ON TRACK.TRACK_ID = INVOICE_LINE.TRACK_ID
 JOIN GENRE ON GENRE.GENRE_ID = TRACK.GENRE_ID
 GROUP BY 2,3,4
 ORDER BY 2 ASC, 1 DESC
 )
 SELECT * FROM POPULAR_GENRE WHERE ROWNO <= 1;
 
 -- Q) WRITE a query that determines the customer that spent the most on music for each country.
 -- write a query that returns the country along with the top customer and how much they spent .
 --  for countries where teh top amount spent.for countries where the top customer and how 
 -- much they spent.for countries where the top amount spent is shared ,
 -- provide all  customers who spent this amount
 
 WITH CUSTOMER_WITH_COUNTRY AS (
 SELECT CUSTOMER.CUSTOMER_ID,FIRST_NAME,LAST_NAME,BILLING_COUNTRY,
 SUM(TOTAL) AS TOTAL_SPENDING,
 ROW_NUMBER() OVER (PARTITION BY BILLING_COUNTRY ORDER BY SUM(TOTAL) DESC) AS ROWNO
 FROM INVOICE
 JOIN CUSTOMER ON CUSTOMER.CUSTOMER_ID = INVOICE.CUSTOMER_ID
 GROUP BY 1,2,3,4
 ORDER BY 4 ASC,5 DESC)
 SELECT * FROM CUSTOMER_WITH_COUNTRY WHERE ROWNO <= 1; 