BEGIN TRANSACTION;
CREATE TABLE Airlines (Airline_ID INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT);
INSERT INTO "Airlines" VALUES(1,'United Airlines');
INSERT INTO "Airlines" VALUES(2,'Delta Airlines');
INSERT INTO "Airlines" VALUES(3,'American Airlines');
INSERT INTO "Airlines" VALUES(4,'Southwest Airlines');
INSERT INTO "Airlines" VALUES(5,'Alaska Airlines');
CREATE TABLE Airports (Airport_ID INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT, City TEXT, Country TEXT);
INSERT INTO "Airports" VALUES(1,'Los Angeles International Airport','Los Angeles','USA');
INSERT INTO "Airports" VALUES(2,'Hartsfield-Jackson Atlanta International Airport','Atlanta','USA');
INSERT INTO "Airports" VALUES(3,'Dallas/Fort Worth International Airport','Dallas','USA');
INSERT INTO "Airports" VALUES(4,'Seattle-Tacoma International Airport','Seattle','USA');
INSERT INTO "Airports" VALUES(5,'Denver International Airport','Denver','USA');
CREATE TABLE Buildings (Building_ID INTEGER PRIMARY KEY AUTOINCREMENT, Terminal_ID INTEGER, Floor_Level INTEGER, FOREIGN KEY(Terminal_ID) REFERENCES Terminals(Terminal_ID));
INSERT INTO "Buildings" VALUES(1,1,2);
INSERT INTO "Buildings" VALUES(2,1,3);
INSERT INTO "Buildings" VALUES(3,2,4);
INSERT INTO "Buildings" VALUES(4,3,2);
INSERT INTO "Buildings" VALUES(5,3,3);
CREATE TABLE Flights (Flight_ID INTEGER PRIMARY KEY AUTOINCREMENT, FlightNumber TEXT, DepartureTime DATETIME, ArrivalTime DATETIME, SourceAirport INTEGER, DestinationAirport INTEGER, Airline_ID INTEGER, FOREIGN KEY(SourceAirport) REFERENCES Airports(Airport_ID), FOREIGN KEY(DestinationAirport) REFERENCES Airports(Airport_ID));
INSERT INTO "Flights" VALUES(1,'UA123','2023-04-01 07:00:00','2023-04-01 09:00:00',1,2,1);
INSERT INTO "Flights" VALUES(2,'DL456','2023-04-01 10:00:00','2023-04-01 12:00:00',2,3,2);
INSERT INTO "Flights" VALUES(3,'AA789','2023-04-01 13:00:00','2023-04-01 15:00:00',3,4,3);
INSERT INTO "Flights" VALUES(4,'SW101','2023-04-01 16:00:00','2023-04-01 18:00:00',4,5,4);
INSERT INTO "Flights" VALUES(5,'AS246','2023-04-01 19:00:00','2023-04-01 21:00:00',5,1,5);
CREATE TABLE ShopItems (Item_ID INTEGER PRIMARY KEY AUTOINCREMENT, Shop_ID INTEGER, ItemName TEXT, Price DECIMAL(10,2), Quantity INTEGER, FOREIGN KEY(Shop_ID) REFERENCES Shops(Shop_ID));
INSERT INTO "ShopItems" VALUES(1,1,'Water Bottle',2.99,50);
INSERT INTO "ShopItems" VALUES(2,1,'Snack Box',5.99,100);
INSERT INTO "ShopItems" VALUES(3,2,'Magazine',4.99,200);
INSERT INTO "ShopItems" VALUES(4,3,'Chocolate Bar',1.99,250);
INSERT INTO "ShopItems" VALUES(5,4,'Newspaper',1.49,300);
CREATE TABLE Shops (Shop_ID INTEGER PRIMARY KEY AUTOINCREMENT, Building_ID INTEGER, Terminal_Building TEXT, Floor_Level INTEGER, FOREIGN KEY(Building_ID) REFERENCES Buildings(Building_ID));
INSERT INTO "Shops" VALUES(1,1,'Baggage Claim',1);
INSERT INTO "Shops" VALUES(2,1,'Concourse A Food Court',2);
INSERT INTO "Shops" VALUES(3,2,'Concourse B Retail',3);
INSERT INTO "Shops" VALUES(4,3,'Concourse C Lounge',4);
INSERT INTO "Shops" VALUES(5,4,'Concourse D Newsstand',1);
CREATE TABLE Terminals (Terminal_ID INTEGER PRIMARY KEY AUTOINCREMENT, Airport_ID INTEGER, Name TEXT, FOREIGN KEY(Airport_ID) REFERENCES Airports(Airport_ID));
INSERT INTO "Terminals" VALUES(1,1,'Terminal 1');
INSERT INTO "Terminals" VALUES(2,1,'Terminal 2');
INSERT INTO "Terminals" VALUES(3,2,'Maynard H. Jackson Jr. International Terminal');
INSERT INTO "Terminals" VALUES(4,3,'Terminal A');
INSERT INTO "Terminals" VALUES(5,3,'Terminal B');
DELETE FROM "sqlite_sequence";
INSERT INTO "sqlite_sequence" VALUES('Airlines',5);
INSERT INTO "sqlite_sequence" VALUES('Flights',5);
INSERT INTO "sqlite_sequence" VALUES('Airports',5);
INSERT INTO "sqlite_sequence" VALUES('Terminals',5);
INSERT INTO "sqlite_sequence" VALUES('Buildings',5);
INSERT INTO "sqlite_sequence" VALUES('Shops',5);
INSERT INTO "sqlite_sequence" VALUES('ShopItems',5);
COMMIT;
