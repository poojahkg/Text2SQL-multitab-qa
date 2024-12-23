BEGIN TRANSACTION;
CREATE TABLE Actors (ActorID INTEGER PRIMARY KEY, FirstName TEXT, LastName TEXT);
INSERT INTO "Actors" VALUES(1,'Tom Hanks','Hanks');
INSERT INTO "Actors" VALUES(2,'Leonardo DiCaprio','DiCaprio');
INSERT INTO "Actors" VALUES(3,'Brad Pitt','Pitt');
INSERT INTO "Actors" VALUES(4,'Samuel L. Jackson','Jackson');
INSERT INTO "Actors" VALUES(5,'Johnny Depp','Depp');
CREATE TABLE Directors (DirectorID INTEGER PRIMARY KEY, Name TEXT);
INSERT INTO "Directors" VALUES(1,'Steven Spielberg');
INSERT INTO "Directors" VALUES(2,'Christopher Nolan');
INSERT INTO "Directors" VALUES(3,'Quentin Tarantino');
INSERT INTO "Directors" VALUES(4,'James Cameron');
INSERT INTO "Directors" VALUES(5,'Martin Scorsese');
CREATE TABLE Genres (GenreID INTEGER PRIMARY KEY, Type TEXT);
INSERT INTO "Genres" VALUES(1,'Drama');
INSERT INTO "Genres" VALUES(2,'Action');
INSERT INTO "Genres" VALUES(3,'Thriller');
INSERT INTO "Genres" VALUES(4,'Comedy');
INSERT INTO "Genres" VALUES(5,'Crime');
CREATE TABLE Movie_Genres (MovieID INTEGER, GenreID INTEGER, FOREIGN KEY(MovieID) REFERENCES Movies(MovieID), FOREIGN KEY(GenreID) REFERENCES Genres(GenreID), PRIMARY KEY(MovieID, GenreID));
INSERT INTO "Movie_Genres" VALUES(1,1);
INSERT INTO "Movie_Genres" VALUES(2,2);
INSERT INTO "Movie_Genres" VALUES(3,3);
INSERT INTO "Movie_Genres" VALUES(4,4);
INSERT INTO "Movie_Genres" VALUES(5,5);
CREATE TABLE Movies (MovieID INTEGER PRIMARY KEY, Title TEXT, Running_Time INT, Extended_Version_Length INT, DirectorID INTEGER, FOREIGN KEY(DirectorID) REFERENCES Directors(DirectorID));
INSERT INTO "Movies" VALUES(1,'Schindler''s List',196,215,1);
INSERT INTO "Movies" VALUES(2,'Inception',128,178,2);
INSERT INTO "Movies" VALUES(3,'Pulp Fiction',154,180,3);
INSERT INTO "Movies" VALUES(4,'Avatar',162,270,4);
INSERT INTO "Movies" VALUES(5,'Goodfellas',146,204,5);
CREATE TABLE Roles (RoleID INTEGER PRIMARY KEY, CharacterName TEXT, ActorID INTEGER, MOVIEID INTEGER, FOREIGN KEY(ActorID) REFERENCES Actors(ActorID), FOREIGN KEY(MOVIEID) REFERENCES Movies(MovieID));
INSERT INTO "Roles" VALUES(1,'Indiana Jones',1,1);
INSERT INTO "Roles" VALUES(2,'Cobb',2,2);
INSERT INTO "Roles" VALUES(3,'Jules Winnfield',3,3);
INSERT INTO "Roles" VALUES(4,'Ray Liotta',4,4);
INSERT INTO "Roles" VALUES(5,'Tony Montana',5,5);
COMMIT;
