
1
select first_name , last_name , title , levels, 
rank() over ( order by title desc )
from employee 
order by levels desc 
--OR 
select * from employee 
order by levels desc

--INSIGHTS 
--MADAN MOHAN IS THE SENIOR MOST EMPLOYEE AS A SENIOR GENERAL MANAGER ON LEVEL BASED 


2
select count(*) , billing_country from invoice 
group by billing_country 
order by count desc 
limit 3;

--INSIGHTS 
--USA COUNTRY HAS THE MOST INVOICE 


3
select sum (total ) as "invoice_total" , billing_city 
from invoice
group by billing_city 
order by invoice_total desc
limit 3 ;

--INSIGHTS
--TOP 3 CITY HAVE THE BEST CUSTOMER 


4
select c.customer_id , c.first_name , c.last_name , c.city , sum (i.total) as "total"
from customer as c 
inner join invoice as i
on c.customer_id = i.customer_id 
group by c.customer_id 
order by total desc
limit 3 ;

--INSIHTS
--R MADHAV ARE THE BEST CUSTOMER ( TOTAL INVOICE ) 







SELECT  email,first_name, last_name
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN(
	SELECT track_id FROM track
	JOIN genre ON track.genre_id = genre.genre_id
	WHERE genre.name LIKE 'Rock' 
)
ORDER BY email;



SELECT DISTINCT email AS Email,first_name AS FirstName, last_name AS LastName
from customer
join invoice on invoice.customer_id  = customer.customer_id 
join invoice_line on invoice_line.invoice_id  = invoice.invoice_id 
join track on track.track_id = invoice_line.track_id 
join genre on genre.genre_id = track.genre_id 
where genre.name like 'Rock'
order by email ;





SELECT artist.artist_id, artist.name,COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC
LIMIT 10;


select name , milliseconds from track 
where milliseconds > (
select avg(milliseconds) as avg_milliseconds 
from track )
order by milliseconds desc ;



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
SELECT * FROM popular_genre WHERE RowNo <= 







WITH RECURSIVE
	sales_per_country AS(
		SELECT COUNT(*) AS purchases_per_genre, customer.country, genre.name, genre.genre_id
		FROM invoice_line
		JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
		JOIN customer ON customer.customer_id = invoice.customer_id
		JOIN track ON track.track_id = invoice_line.track_id
		JOIN genre ON genre.genre_id = track.genre_id
		GROUP BY 2,3,4
		ORDER BY 2
	),
	max_genre_per_country AS (SELECT MAX(purchases_per_genre) AS max_genre_number, country
		FROM sales_per_country
		GROUP BY 2
		ORDER BY 2)

SELECT sales_per_country.* 
FROM sales_per_country
JOIN max_genre_per_country ON sales_per_country.country = max_genre_per_country.country
WHERE sales_per_country.purchases_per_genre = max_genre_per_country.max_genre_number;
