BEGIN TRANSACTION;
CREATE TABLE Albums (AlbumID INTEGER PRIMARY KEY, AlbumTitle TEXT, ReleaseDate DATE, ARTISTID INTEGER, FOREIGN KEY(ARTISTID) REFERENCES Artists(ArtistID));
INSERT INTO "Albums" VALUES(1,'21','2011-02-24',1);
INSERT INTO "Albums" VALUES(2,'Beyonce','2016-04-07',2);
INSERT INTO "Albums" VALUES(3,'Goodbye Yellow Brick Road','1973-05-08',3);
INSERT INTO "Albums" VALUES(4,'FutureSex/LoveSound','2006-11-12',4);
INSERT INTO "Albums" VALUES(5,'The Fame','2008-09-01',5);
CREATE TABLE Artists (ArtistID INTEGER PRIMARY KEY, ArtistName TEXT);
INSERT INTO "Artists" VALUES(1,'Adele');
INSERT INTO "Artists" VALUES(2,'Beyonce');
INSERT INTO "Artists" VALUES(3,'Elton John');
INSERT INTO "Artists" VALUES(4,'Justin Timberlake');
INSERT INTO "Artists" VALUES(5,'Lady Gaga');
CREATE TABLE Events (EventID INTEGER PRIMARY KEY, EventName TEXT, StartDateTime TIMESTAMP, EndDateTime TIMESTAMP, VenueID INTEGER, TICKETID INTEGER, FOREIGN KEY(VenueID) REFERENCES Venues(VenueID), FOREIGN KEY(TICKETID) REFERENCES Tickets(TicketID));
INSERT INTO "Events" VALUES(1,'Adele Concert','2023-06-10 19:00:00','2023-06-10 22:30:00',1,1);
INSERT INTO "Events" VALUES(2,'Beyonce World Tour','2023-07-15 20:00:00','2023-07-15 23:30:00',2,2);
INSERT INTO "Events" VALUES(3,'Elton John Farewell Tour','2023-08-20 19:00:00','2023-08-20 22:30:00',3,3);
INSERT INTO "Events" VALUES(4,'Justin Timberlake Man Of The Woods Tour','2023-09-15 20:00:00','2023-09-15 23:30:00',4,4);
INSERT INTO "Events" VALUES(5,'Lady Gaga Jazz & Piano Tour','2023-10-20 19:00:00','2023-10-20 22:30:00',5,5);
CREATE TABLE Performances (PerformanceID INTEGER PRIMARY KEY, EventID INTEGER, ArtistID INTEGER, PerformanceStartTime TIMESTAMP, PerformanceEndTime TIMESTAMP, FOREIGN KEY(EventID) REFERENCES Events(EventID), FOREIGN KEY(ArtistID) REFERENCES Artists(ArtistID));
INSERT INTO "Performances" VALUES(1,1,1,'2023-06-10 19:30:00','2023-06-10 22:00:00');
INSERT INTO "Performances" VALUES(2,2,2,'2023-07-15 20:30:00','2023-07-15 23:00:00');
INSERT INTO "Performances" VALUES(3,3,3,'2023-08-20 19:30:00','2023-08-20 22:00:00');
INSERT INTO "Performances" VALUES(4,4,4,'2023-09-15 20:30:00','2023-09-15 23:00:00');
INSERT INTO "Performances" VALUES(5,5,5,'2023-10-20 19:30:00','2023-10-20 22:00:00');
CREATE TABLE "Tickets" (TicketID INTEGER PRIMARY KEY, EventID INTEGER, Quantity INT , Sale_Date DATE, Price DECIMAL(5,2), FOREIGN KEY(EventID) REFERENCES Events(EventID));
INSERT INTO "Tickets" VALUES(1,1,100,'2023-06-01',49.99);
INSERT INTO "Tickets" VALUES(2,2,200,'2023-07-01',59.99);
INSERT INTO "Tickets" VALUES(3,3,150,'2023-08-01',69.99);
INSERT INTO "Tickets" VALUES(4,4,250,'2023-09-01',79.99);
INSERT INTO "Tickets" VALUES(5,5,300,'2023-10-01',89.99);
CREATE TABLE Venues (VenueID INTEGER PRIMARY KEY, Name TEXT, Address TEXT);
INSERT INTO "Venues" VALUES(1,'Madison Square Garden','New York, NY');
INSERT INTO "Venues" VALUES(2,'Staples Center','Los Angeles, CA');
INSERT INTO "Venues" VALUES(3,'Wembley Stadium','London, UK');
INSERT INTO "Venues" VALUES(4,'Royal Arena','Copenhagen, Denmark');
INSERT INTO "Venues" VALUES(5,'Barclays Centre','Brooklyn, NY');
COMMIT;
