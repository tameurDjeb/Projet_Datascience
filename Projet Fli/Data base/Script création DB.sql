
/* Au cas où on veut supprimer une des tables 

DROP TABLE AIRLINES;
DROP TABLE PLANES;
DROP TABLE FLIGHTS;
DROP TABLE WEATHER;
DROP TABLE AIRPORTS;

*/

-- Table AIRLINE

CREATE TABLE AIRLINES(
	carrier varchar2(2),
	name varchar2(50),
	CONSTRAINT PK_AIRLINES PRIMARY KEY (carrier)
);

CREATE TABLE PLANES(
	tailnum varchar2(6),
	year varchar(4),
	type varchar2(50),
	manufacturer varchar2(40),
	model varchar2(20),
	engines integer,
	seats integer,
	speed integer,
	engine varchar2(50),
	CONSTRAINT PK_PLANES PRIMARY KEY (tailnum)
);

CREATE TABLE AIRPORTS(
	faa char(3),
	name VARCHAR2(130),
	lat varchar2(40) ,
	lon varchar2(40),
	alt INTEGER,
	tz INTEGER,
	dst VARCHAR2(1),
	tzone varchar2(40),
	CONSTRAINT PK_AIRPORTS PRIMARY KEY (faa)
	);

CREATE TABLE WEATHER(
    origin char(3),
	year integer,
	month integer,
	day integer,
	hour integer,
	temp varchar2(30),
	dewp varchar2(30),
	humid varchar2(30),
	wind_dir varchar2(30),
	wind_speed varchar2(30),
	wind_gust varchar2(30),
	precip integer,
	pressure varchar2(30),
	visib integer,
	time_hour varchar2(30),
	CONSTRAINT PK_WEATHER PRIMARY KEY (year,month,day,hour,origin),
	CONSTRAINT FK_WEATHER_ORIGIN FOREIGN KEY (origin) REFERENCES AIRPORTS(faa) ON DELETE CASCADE,
    CONSTRAINT CK_MONTH_WEATHER CHECK(1<= month and month <= 12),
    CONSTRAINT CK_DAY_WEATHER CHECK(1<= day and day <= 31),
    CONSTRAINT CK_HOUR_WEATHER CHECK(0<= hour and hour <= 23)
    );
	
	create index IDX_WEATHER_ORIGIN on weather (origin);


CREATE TABLE FLIGHTS (
    id_flights number generated always as IDENTITY,-- Création d'une colonne numérique, à laquelle une valeur croissante est automatiquement attribuée lors de l'INSERT.
    year integer,
	month integer,
	day integer,
	dep_time integer,
	sched_dep_time integer,
	dep_delay integer,
	arr_time integer,
	sched_arr_time integer ,
	arr_delay integer,
	carrier varchar2(2),
	flight INTEGER,
	tailnum varchar2(6),
	origin CHAR(3),
	dest CHAR(3),
	air_time INTEGER,
	distance INTEGER,
	hour integer,
	minute INTEGER,
	time_hour VARCHAR(30),
	CONSTRAINT PK_FLIGHTS PRIMARY KEY (year,month,day,hour,flight),
    CONSTRAINT FK_FLIGHTS_WEATHER FOREIGN KEY (year,month,day,hour,origin) REFERENCES WEATHER(year,month,day,hour,origin) on delete cascade,
    CONSTRAINT FK_FLIGHTS_ORIGIN FOREIGN KEY (origin) REFERENCES AIRPORTS (faa) on delete cascade,
    CONSTRAINT FK_FLIGHTS_DEST FOREIGN KEY (dest) REFERENCES AIRPORTS (faa) on delete cascade,
    CONSTRAINT FK_FLIGHTS_TAILNUM FOREIGN KEY (tailnum) REFERENCES PLANES (tailnum) on delete cascade,
    CONSTRAINT FK_FLIGHTS_CARRIER FOREIGN KEY (carrier) REFERENCES AIRLINES (carrier) on delete cascade
    );

ALTER TABLE FLIGHTS -- Pour reset la valeur à 1 au cas où on drop la 
MODIFY id_flights generated as identity (start with 1);

-- Création d'index

create index IDX_FLIGHTS_WEATHER on FLIGHTS (year,month,day,hour,origin);
create index IDX_FLIGHTS_ORIGIN on FLIGHTS (origin);
create index IDX_FLIGHTS_DEST on FLIGHTS (dest);
create index IDX_FLIGHTS_TAILNUM on FLIGHTS (tailnum);
create index IDX_FLIGHTS_CARRIER on FLIGHTS (carrier);


