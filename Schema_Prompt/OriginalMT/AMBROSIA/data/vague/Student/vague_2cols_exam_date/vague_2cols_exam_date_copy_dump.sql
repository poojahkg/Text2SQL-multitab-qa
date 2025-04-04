BEGIN TRANSACTION;
CREATE TABLE Addresses (AddressID INTEGER PRIMARY KEY, StreetAddress TEXT, City TEXT, State TEXT, ZipCode TEXT, StudentID INTEGER, FOREIGN KEY(StudentID) REFERENCES Students(StudentID));
INSERT INTO "Addresses" VALUES(1,'123 Main St','Anytown','CA','90210',1);
INSERT INTO "Addresses" VALUES(2,'456 Elm St','Othertown','NY','10001',2);
INSERT INTO "Addresses" VALUES(3,'789 Oak St','Anytown','TX','77301',3);
INSERT INTO "Addresses" VALUES(4,'101 Pine St','Townville','IL','60601',4);
INSERT INTO "Addresses" VALUES(5,'111 Maple Ave','Villagetown','NJ','07601',5);
CREATE TABLE EmailAddresses (EmailAddressID INTEGER PRIMARY KEY, Email TEXT, IsPrimary BOOLEAN , StudentID INTEGER, FOREIGN KEY(StudentID) REFERENCES Students(StudentID));
INSERT INTO "EmailAddresses" VALUES(1,'johndoe@example.com',1,1);
INSERT INTO "EmailAddresses" VALUES(2,'janedoe@example.com',0,1);
INSERT INTO "EmailAddresses" VALUES(3,'emilywilliams@example.net',1,4);
INSERT INTO "EmailAddresses" VALUES(4,'davidbrown@example.org',0,5);
INSERT INTO "EmailAddresses" VALUES(5,'michaeljohnson@example.edu',1,3);
CREATE TABLE Enrollments (EnrollmentID INTEGER PRIMARY KEY, CourseID INTEGER, Semester INTERGER, Year INTEGER, Grade CHAR(2), StudentID INTEGER, FOREIGN KEY(StudentID) REFERENCES Students(StudentID));
INSERT INTO "Enrollments" VALUES(1,1,'Fall',2021,'A',1);
INSERT INTO "Enrollments" VALUES(2,2,'Spring',2022,'B+',2);
INSERT INTO "Enrollments" VALUES(3,3,'Summer',2022,'A-',3);
INSERT INTO "Enrollments" VALUES(4,4,'Fall',2021,'B',4);
INSERT INTO "Enrollments" VALUES(5,5,'Winter',2022,'Incomplete',5);
CREATE TABLE "ExamScores" (ScoreID INTEGER PRIMARY KEY, Exam_Date INTEGER, ExamDescription TEXT, Score INTEGER, StudentID INTEGER, FOREIGN KEY(StudentID) REFERENCES Students(StudentID));
INSERT INTO "ExamScores" VALUES(1,10,'Final Exam',95,1);
INSERT INTO "ExamScores" VALUES(2,4,'Midterm',85,2);
INSERT INTO "ExamScores" VALUES(3,6,'Quiz',90,3);
INSERT INTO "ExamScores" VALUES(4,12,'Project',92,4);
INSERT INTO "ExamScores" VALUES(5,3,'Assignment',88,5);
CREATE TABLE PhoneNumbers (PhoneNumberID INTEGER PRIMARY KEY, Number TEXT, Type TEXT, StudentID INTEGER, FOREIGN KEY(StudentID) REFERENCES Students(StudentID));
INSERT INTO "PhoneNumbers" VALUES(1,'(555) 123-4567','Home',1);
INSERT INTO "PhoneNumbers" VALUES(2,'(555) 987-6543','Mobile',2);
INSERT INTO "PhoneNumbers" VALUES(3,'(555) 321-0987','Work',3);
INSERT INTO "PhoneNumbers" VALUES(4,'(555) 765-4321','Home',4);
INSERT INTO "PhoneNumbers" VALUES(5,'(555) 135-7890','Mobile',5);
CREATE TABLE Students (StudentID INTEGER PRIMARY KEY, FirstName TEXT, LastName TEXT);
INSERT INTO "Students" VALUES(1,'John','Doe');
INSERT INTO "Students" VALUES(2,'Jane','Smith');
INSERT INTO "Students" VALUES(3,'Michael','Johnson');
INSERT INTO "Students" VALUES(4,'Emily','Williams');
INSERT INTO "Students" VALUES(5,'David','Brown');
COMMIT;
