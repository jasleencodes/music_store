EASY LEVEL QUESTIONS OF THE PROJECT 

Q1 - WHO IS THE SENIOR MOST EMPLOYEE on job title?
SELECT * FROM employee
ORDER BY levels DESC 
limit 1 


Q2:- WHICH COUNTRIES HAS THE MOST INVOICES ??

SELECT COUNT(*) as c , billing_country
FROM invoice 
GROUP BY billing_country
ORDER BY c DESC 

Q3 - WHAT ARE TOP 3 VALUES OF TOTAL INVOICE ??

SELECT total FROM invoice 
order by total desc 
limit 3

Q4- WHICH CITY HAS THE BEST CUSTOMERS ?? WE WOULD LIKE TO THROW A MUSIC FESTIVAL IN CITY WE MADE THE MOST MONEY . RETURN CITY THE RETURNS THE HIGHEST SUM OF INVOICE TOTALS  , RETURN BOTH CITY NAMES AND SUM OF ALL INVOICE TABLES .

SELECT SUM(total ) as invoice_total,billing_city
FROM invoice 
group by billing_city
order by invoice_total DESC 

Q5 - Who is the best customer , who has spent the most money 

SELECT customer.customer_id , customer.first_name , customer.last_name , SUM (invoice.total) as total
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id 
GROUP BY customer.customer_id
ORDER BY total DESC 
LIMIT 1 

MODERATE LEVEL QUESTIONS OF THE PROJECT 

Q1 - Write querry to return the email , first name , last name and genre of all music lestners , return ordered list alphabetically by email strting with A  

SELECT  email, first_name , last_name 
from customer 
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON  invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN (
SELECT track_id from track 
JOIN  genre on track.genre_id = genre.genre_id
where genre.name like 'ROCK'
)
order by email ;

Q2 - write a query to return name of artist and total track count of top 10 rock bands 

SELECT artist.artist_id , artist.name , COUNT(artist.artist_id) AS number_of_songs
FROM track 
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id=track.genre_id
where genre.name like 'rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC 
limit 10 ;

Q3 - RETURN ALL TRACK NAMES HAVING LENGTH LOGER THAN THE AVERAGE SONG LENGTH 

SELECT name , milliseconds
FROM track 
WHERE milliseconds >( SELECT AVG(milliseconds) as avg_track_length
FROM track )
ORDER BY milliseconds DESC 

ADVANCE LEVEL QUESTIONS OF PROJECT

Q1 - QUERRY TO RETURN CUSTOMER NAME , ARTIST NAME , TOTAL SPENT 

WITH best_selling_artist AS (
	SELECT artist.artist_id AS artist_id, artist.name AS artist_name, SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

Q2- QUERRY TO RETURN COUTRY ALONG THE TOP GENRE

WITH popular_genre AS 
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1

Q3 - querry to determine the customer that has spent the most on music for each year ,along with their country 


WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1

