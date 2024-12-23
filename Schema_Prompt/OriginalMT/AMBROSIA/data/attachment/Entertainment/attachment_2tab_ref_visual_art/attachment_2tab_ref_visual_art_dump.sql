BEGIN TRANSACTION;
CREATE TABLE Artist(ArtistID INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT);
INSERT INTO "Artist" VALUES(1,'Vincent van Gogh');
INSERT INTO "Artist" VALUES(2,'Leonardo da Vinci');
INSERT INTO "Artist" VALUES(3,'Jackson Pollock');
INSERT INTO "Artist" VALUES(4,'Ansel Adams');
INSERT INTO "Artist" VALUES(5,'Georgia O''Keeffe');
CREATE TABLE Exhibition(ExhibitionId INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT, StartDate DATE, EndDate DATE);
INSERT INTO "Exhibition" VALUES(1,'Impressionism Art Showcase','2021-01-01','2021-02-28');
INSERT INTO "Exhibition" VALUES(2,'Abstract Expressionism Art Exhibit','2021-03-01','2021-04-30');
INSERT INTO "Exhibition" VALUES(3,'Modern Photography Collection','2021-05-01','2021-06-30');
INSERT INTO "Exhibition" VALUES(4,'Surrealistic Visions','2021-07-01','2021-08-31');
INSERT INTO "Exhibition" VALUES(5,'Contemporary Landscapes','2021-09-01','2021-10-31');
CREATE TABLE Gallery(GalleryId INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT);
INSERT INTO "Gallery" VALUES(1,'MoMA - Museum of Modern Art');
INSERT INTO "Gallery" VALUES(2,'National Portrait Gallery');
INSERT INTO "Gallery" VALUES(3,'Metropolitan Museum of Art');
INSERT INTO "Gallery" VALUES(4,'Tate Modern');
INSERT INTO "Gallery" VALUES(5,'Guggenheim Museum');
CREATE TABLE PainterOfPaintings(ArtistId INTEGER, PaintingId INTEGER, FOREIGN KEY(ArtistId) REFERENCES Artist(ArtistId), FOREIGN KEY(PaintingId) REFERENCES Painting(PaintingId));
INSERT INTO "PainterOfPaintings" VALUES(1,1);
INSERT INTO "PainterOfPaintings" VALUES(2,2);
INSERT INTO "PainterOfPaintings" VALUES(3,3);
INSERT INTO "PainterOfPaintings" VALUES(4,5);
INSERT INTO "PainterOfPaintings" VALUES(5,4);
CREATE TABLE Painting(PaintingID INTEGER PRIMARY KEY AUTOINCREMENT, Title TEXT, Year INT, Description TEXT, GalleryId INTEGER, FOREIGN KEY (GalleryId) REFERENCES Gallery(GalleryId));
INSERT INTO "Painting" VALUES(1,'Starry Night',1889,'A depiction of the view from the east-facing window of Van Gogh’s asylum room at Saint-Rémy.',1);
INSERT INTO "Painting" VALUES(2,'Mona Lisa',1503,'A portrait of a woman by Leonardo da Vinci.',2);
INSERT INTO "Painting" VALUES(3,'Guernica',1937,'A powerful anti-war painting created by Pablo Picasso after the bombing of Guernica during the Spanish Civil War.',3);
INSERT INTO "Painting" VALUES(4,'The Starry Night Express',1960,'This painting is inspired by Vincent van Gogh’s famous work “Starry Night”.',4);
INSERT INTO "Painting" VALUES(5,'American Buffalo',1948,'A photograph showcasing the power and beauty of nature.',5);
CREATE TABLE PhotographerOfPhotos(ArtistId INTEGER, PhotoId INTEGER, FOREIGN KEY(ArtistId) REFERENCES Artist(ArtistId), FOREIGN KEY(PhotoId) REFERENCES Photography(PhotoId));
INSERT INTO "PhotographerOfPhotos" VALUES(1,1);
INSERT INTO "PhotographerOfPhotos" VALUES(2,2);
INSERT INTO "PhotographerOfPhotos" VALUES(3,3);
INSERT INTO "PhotographerOfPhotos" VALUES(4,4);
INSERT INTO "PhotographerOfPhotos" VALUES(5,5);
CREATE TABLE Photography(PhotoId INTEGER PRIMARY KEY AUTOINCREMENT, Title TEXT, Year INT, Description TEXT, GalleryId INTEGER, FOREIGN KEY (GalleryId) REFERENCES Gallery(GalleryId));
INSERT INTO "Photography" VALUES(1,'Empire State Building at Night',1931,'A black and white photograph capturing the iconic Empire State Building lit up at night.',1);
INSERT INTO "Photography" VALUES(2,'Yosemite National Park',1940,'A breathtaking landscape photograph taken by Ansel Adams.',2);
INSERT INTO "Photography" VALUES(3,'Central Park in Winter',1940,'A serene photo of Central Park covered in snow.',3);
INSERT INTO "Photography" VALUES(4,'San Francisco Golden Gate Bridge',1950,'A stunning shot of the Golden Gate Bridge at sunset.',4);
INSERT INTO "Photography" VALUES(5,'New York City Skyline',1960,'A panoramic view of the New York City skyline.',5);
DELETE FROM "sqlite_sequence";
INSERT INTO "sqlite_sequence" VALUES('Artist',5);
INSERT INTO "sqlite_sequence" VALUES('Painting',5);
INSERT INTO "sqlite_sequence" VALUES('Photography',5);
INSERT INTO "sqlite_sequence" VALUES('Exhibition',5);
INSERT INTO "sqlite_sequence" VALUES('Gallery',5);
COMMIT;
