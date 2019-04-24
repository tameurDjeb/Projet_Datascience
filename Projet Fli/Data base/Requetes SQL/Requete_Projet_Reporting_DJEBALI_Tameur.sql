--Question 2. Combien y-a-t-il : 
--d’aéroports,

select count(*) as nbaeroport 
from airports;

--de compagnies,
select count(*) as nbcompagnie 
from airports;
--de destinations,

select count(distinct dest) as nbdest 
from flights;

--d’avions, 
select count(*) as nbavion
from planes;

--Question 3 
--Quel est l’aéroport de départ le plus emprunté ?

select name,origin,nbdeporigin
from airports a ,
(select count(origin) as nbdeporigin, origin
from flights 
group by origin) b
where a.faa=b.origin
order by nbdeporigin desc
fetch first 1 rows only;

--Quelles sont les 10 destinations les plus (moins) prisées ?

select name,dest,nbdest
from airports a ,
(select count(dest) as nbdest, dest
from flights 
group by dest) b
where a.faa=b.dest
order by nbdest
fetch first 10 rows only;

--Quelle sont les 10 avions qui ont le plus (moins) décollé ?  

select flight,nbflights
from 
(select count(flight) as nbflights, flight
from flights 
group by flight) 
order by nbflights
fetch first 10 rows only;

--Question 4 : 

--Trouver combien chaque compagnie a desservi de destination ; 
select name,b.carrier,nbdest
from airlines a ,(select count (dest) as nbdest,carrier
from flights
group by carrier) b
where a.carrier=b.carrier
order by nbdest;

--Question 5
--Trouver tous les vols ayant atterri à Houston (IAH ou HOU) (indice : 9313) 

select *
from flights 
where dest = 'IAH' or dest = 'HOU'; 

--Combien de vols partent de NYC airports vers Seattle (indice : 3923 vols)

select *
from flights 
where origin = 'NYC' and dest = 'SEA';

--Combien de compagnies desservent cette destination (indice : 5 compagnies) et combien d’avions “uniques” (indice : 935 avions) ? 

select count(distinct carrier) as nbcarrier,count (distinct tailnum)
from flights 
where dest = 'SEA';

--Question 6

--Trouver le nombre de vols unique par destination voir l’aperçu.

select name,nbvols_unique
from (select dest,count(*) nbvols_unique
      from flights a
      group by dest) a
inner join airports b on a.dest=b.faa
order by  nbvols_unique desc ;

--Trier les vols suivant la destination, l’aéroport d’origine, la compagnie dans un ordre alphabétique croissant (en réalisant les jointures nécessaires pour obtenir les noms des explicites des aéroports) ?

SELECT DISTINCT airports_dest,airports_origin,name_carrier,origin,dest,carrier,a.flight

FROM (SELECT name as airports_dest,dest,flight
from flights a
inner join airports b on a.dest=b.faa) a,
(SELECT name as airports_origin,origin,flight
from flights a
inner join airports b on a.origin=b.faa) b,
(SELECT name as name_carrier,c.carrier,flight
from flights a
inner join airlines c on a.carrier=c.carrier) c
where a.flight=b.flight
and b.flight=c.flight
ORDER BY airports_dest,airports_origin,name_carrier,origin,dest,carrier,a.flight
 ; 

--Question 7

--Quelles sont les compagnies qui n'opèrent pas sur tous les aéroports d’origine ?

select name,b.carrier,nb_origin
from airlines a ,
(select count (distinct origin) as nb_origin , carrier
from flights a
having count (distinct origin)  < (select count (distinct origin) from flights) -- on recupere le nombre d'aeroport d'origine distinct 
group by carrier) b 
where a.carrier=b.carrier;

--Quelles sont les compagnies qui desservent l’ensemble de destinations ?

select name,b.carrier,nb_dest
from airlines a ,
(select count (distinct dest) as nb_dest , carrier
from flights a
having count (distinct dest)  <= (select count (distinct dest) from flights) -- on recupere le nombre d'aeroport d'origine distinct 
group by carrier) b 
where a.carrier=b.carrier;

-- Faire un tableau où l’on récupère l’ensemble des origines et des destinations pour l’ensemble des compagnies.

select nb_origin,b.carrier,name,nb_dest
from airlines a,
(select count (distinct origin) as nb_origin , carrier,count(distinct dest) nb_dest
from flights a
group by carrier) b 
where a.carrier=b.carrier
order by nb_dest desc;

-- Question 9 
-- Filtrer le vol pour trouver ceux exploités par United, American ou Delta
select *
from flights
where carrier in ('UA','AA','DL');
