BEGIN TRANSACTION;
CREATE TABLE Actor (ActorID INTEGER PRIMARY KEY AUTOINCREMENT, FirstName TEXT, LastName TEXT, DateOfBirth DATE, Nationality TEXT);
INSERT INTO "Actor" VALUES(1,'Keanu','Reeves','1964-09-02','Canadian');
INSERT INTO "Actor" VALUES(2,'Tom Hanks','1956-07-09','American','American');
INSERT INTO "Actor" VALUES(3,'John Travolta','1954-02-18','American','American');
INSERT INTO "Actor" VALUES(4,'Leonardo DiCaprio','1974-11-11','American','American');
INSERT INTO "Actor" VALUES(5,'Robin Williams','1951-07-21','American','American');
CREATE TABLE Cast (CastID INTEGER PRIMARY KEY AUTOINCREMENT, MovieID INTEGER, ActorID INTEGER, Role TEXT, FOREIGN KEY(MovieID) REFERENCES Movie(MovieID), FOREIGN KEY(ActorID) REFERENCES Actor(ActorID));
INSERT INTO "Cast" VALUES(1,1,1,'Neo');
INSERT INTO "Cast" VALUES(2,1,NULL,'Morpheus');
INSERT INTO "Cast" VALUES(3,3,NULL,'Vincent Vega');
INSERT INTO "Cast" VALUES(4,4,NULL,'Cobb');
INSERT INTO "Cast" VALUES(5,5,NULL,'Forrest Gump');
CREATE TABLE Director (DirectorID INTEGER PRIMARY KEY AUTOINCREMENT, FirstName TEXT, LastName TEXT, BirthYear INT, DeathYear INT);
INSERT INTO "Director" VALUES(1,'Christopher','Nolan',1970,NULL);
INSERT INTO "Director" VALUES(2,'Frank','Darabont',1959,NULL);
INSERT INTO "Director" VALUES(3,'Quentin','Tarantino',1963,NULL);
INSERT INTO "Director" VALUES(4,'Christopher','McQuarrie',1967,NULL);
INSERT INTO "Director" VALUES(5,'Robert','Zemeckis',1945,NULL);
CREATE TABLE "Documentary" (DocumentaryID INTEGER PRIMARY KEY AUTOINCREMENT, Title TEXT, Context TEXT, DirectorID INTEGER, FOREIGN KEY(DirectorID) REFERENCES Director(DirectorID));
INSERT INTO "Documentary" VALUES(1,'Apollo 11','Space Race Era',5);
INSERT INTO "Documentary" VALUES(2,'Blue Planet II','Anthropocene',4);
INSERT INTO "Documentary" VALUES(3,'Planet Earth','Holocene',3);
INSERT INTO "Documentary" VALUES(4,'Wild Africa','Holocene',2);
INSERT INTO "Documentary" VALUES(5,'The Hunt for Bin Laden','War on Terror Era',1);
CREATE TABLE Genre (GenreID INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT);
INSERT INTO "Genre" VALUES(1,'Action');
INSERT INTO "Genre" VALUES(2,'Comedy');
INSERT INTO "Genre" VALUES(3,'Drama');
INSERT INTO "Genre" VALUES(4,'Horror');
INSERT INTO "Genre" VALUES(5,'Romance');
CREATE TABLE Movie (MovieID INTEGER PRIMARY KEY AUTOINCREMENT, Title TEXT, ReleaseDate DATE, Rating REAL, GenreID INTEGER, FOREIGN KEY(GenreID) REFERENCES Genre(GenreID));
INSERT INTO "Movie" VALUES(1,'The Matrix','1999-03-31',8.7,1);
INSERT INTO "Movie" VALUES(2,'The Shawshank Redemption','1994-09-22',9.3,3);
INSERT INTO "Movie" VALUES(3,'Pulp Fiction','1994-10-14',8.9,1);
INSERT INTO "Movie" VALUES(4,'Inception','2010-07-16',8.8,1);
INSERT INTO "Movie" VALUES(5,'Forrest Gump','1994-07-06',8.8,3);
DELETE FROM "sqlite_sequence";
INSERT INTO "sqlite_sequence" VALUES('Genre',5);
INSERT INTO "sqlite_sequence" VALUES('Movie',5);
INSERT INTO "sqlite_sequence" VALUES('Actor',5);
INSERT INTO "sqlite_sequence" VALUES('Cast',5);
INSERT INTO "sqlite_sequence" VALUES('Director',5);
INSERT INTO "sqlite_sequence" VALUES('Documentary',5);
COMMIT;
