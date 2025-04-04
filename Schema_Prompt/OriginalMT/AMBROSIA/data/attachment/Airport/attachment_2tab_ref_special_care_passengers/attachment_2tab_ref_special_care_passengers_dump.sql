BEGIN TRANSACTION;
CREATE TABLE Assistant (AssistantID INTEGER PRIMARY KEY, Name TEXT, ContactInfo TEXT);
INSERT INTO "Assistant" VALUES(1,'Clare Allen','clareallen@assistant.com; +1-234-567-8900');
INSERT INTO "Assistant" VALUES(2,'David Johnson','davidjohnson@assistant.com; +1-345-678-9012');
CREATE TABLE Booking (BookingID INTEGER PRIMARY KEY, FlightID INTEGER, PassengerID INTEGER, UMID INTEGER, SNPID INTEGER, FOREIGN KEY (FlightID) REFERENCES Flight (FlightID), FOREIGN KEY (PassengerID) REFERENCES Passenger (PassengerID), FOREIGN KEY (UMID) REFERENCES UnaccompaniedMinor (UMID), FOREIGN KEY (SNPID) REFERENCES "DisabledPassenger" (SNPID));
INSERT INTO "Booking" VALUES(1,1,1,1,NULL);
INSERT INTO "Booking" VALUES(2,2,2,NULL,1);
INSERT INTO "Booking" VALUES(3,3,3,2,2);
INSERT INTO "Booking" VALUES(4,4,4,1,NULL);
INSERT INTO "Booking" VALUES(5,5,5,NULL,1);
CREATE TABLE "DisabledPassenger" (SNPID INTEGER PRIMARY KEY, PassengerID INTEGER, AssistantID INTEGER, FOREIGN KEY (PassengerID) REFERENCES Passenger (PassengerID), FOREIGN KEY (AssistantID) REFERENCES Assistant (AssistantID));
INSERT INTO "DisabledPassenger" VALUES(1,3,1);
INSERT INTO "DisabledPassenger" VALUES(2,4,2);
CREATE TABLE Flight (FlightID INTEGER PRIMARY KEY, Origin TEXT, Destination TEXT, DepartureTime TIMESTAMP);
INSERT INTO "Flight" VALUES(1,'JFK','LAX','2023-04-01 08:00:00');
INSERT INTO "Flight" VALUES(2,'ORD','ATL','2023-04-02 10:00:00');
INSERT INTO "Flight" VALUES(3,'SEA','DEN','2023-04-03 12:00:00');
INSERT INTO "Flight" VALUES(4,'IAH','MIA','2023-04-04 14:00:00');
INSERT INTO "Flight" VALUES(5,'DFW','PHX','2023-04-05 16:00:00');
CREATE TABLE Passenger (PassengerID INTEGER PRIMARY KEY, Email TEXT, PhoneNumber VARCHAR(15) UNIQUE, FullName TEXT);
INSERT INTO "Passenger" VALUES(1,'johnsmith@email.com','555-123-4567','John Smith');
INSERT INTO "Passenger" VALUES(2,'janedoe@email.com','555-987-6543','Jane Doe');
INSERT INTO "Passenger" VALUES(3,'alicejohnson@email.com','555-432-1234','Alice Johnson');
INSERT INTO "Passenger" VALUES(4,'bobwilliams@email.com','555-654-3219','Bob Williams');
INSERT INTO "Passenger" VALUES(5,'emmabrown@email.com','555-111-2222','Emma Brown');
CREATE TABLE UnaccompaniedMinor (UMID INTEGER PRIMARY KEY, PassengerID INTEGER, AssistantID INTEGER, FOREIGN KEY (PassengerID) REFERENCES Passenger (PassengerID), FOREIGN KEY (AssistantID) REFERENCES Assistant (AssistantID));
INSERT INTO "UnaccompaniedMinor" VALUES(1,1,1);
INSERT INTO "UnaccompaniedMinor" VALUES(2,2,2);
COMMIT;
