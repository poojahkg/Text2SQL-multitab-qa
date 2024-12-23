BEGIN TRANSACTION;
CREATE TABLE Accounts (AccountNumber INTEGER PRIMARY KEY, CustomerID INTEGER, Balance REAL, FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID));
INSERT INTO "Accounts" VALUES(1,1,2000.0);
INSERT INTO "Accounts" VALUES(2,2,3000.0);
INSERT INTO "Accounts" VALUES(3,3,4000.0);
INSERT INTO "Accounts" VALUES(4,4,5000.0);
INSERT INTO "Accounts" VALUES(5,5,6000.0);
CREATE TABLE Customers (CustomerID INTEGER PRIMARY KEY, FirstName TEXT, LastName TEXT);
INSERT INTO "Customers" VALUES(1,'John','Smith');
INSERT INTO "Customers" VALUES(2,'Jane','Doe');
INSERT INTO "Customers" VALUES(3,'Michael','Johnson');
INSERT INTO "Customers" VALUES(4,'Emily','Williams');
INSERT INTO "Customers" VALUES(5,'David','Brown');
CREATE TABLE "Dividends" (DividendID INTEGER PRIMARY KEY, ShareID INTEGER, DividendAmount REAL, ExpectedPaymentDate DATETIME DEFAULT CURRENT_TIMESTAMP, Dividend_Yield REAL, FOREIGN KEY(ShareID) REFERENCES Shares(ShareID));
INSERT INTO "Dividends" VALUES(1,1,10.0,'2023-06-01',2.0);
INSERT INTO "Dividends" VALUES(2,2,5.0,'2023-06-15',1.0);
INSERT INTO "Dividends" VALUES(3,3,8.0,'2023-07-01',2.0);
INSERT INTO "Dividends" VALUES(4,4,3.0,'2023-07-15',1.0);
INSERT INTO "Dividends" VALUES(5,5,12.0,'2023-08-01',3.0);
CREATE TABLE ShareTransactions (ShareTransactionID INTEGER PRIMARY KEY, BuyOrSell TEXT , CustomerID INTEGER, ShareID INTEGER, Quantity INTEGER, Price REAL, Commission FEATURE REAL, FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID), FOREIGN KEY(ShareID) REFERENCES Shares(ShareID));
INSERT INTO "ShareTransactions" VALUES(1,'BUY',1,1,10,100.0,5.0);
INSERT INTO "ShareTransactions" VALUES(2,'SELL',1,1,5,95.0,4.75);
INSERT INTO "ShareTransactions" VALUES(3,'BUY',2,2,20,80.0,8.0);
INSERT INTO "ShareTransactions" VALUES(4,'SELL',2,2,8,75.0,6.0);
INSERT INTO "ShareTransactions" VALUES(5,'BUY',3,3,15,70.0,7.5);
CREATE TABLE Shares (ShareID INTEGER PRIMARY KEY, Stock TEXT, NumberOfShares INTEGER);
INSERT INTO "Shares" VALUES(1,'ABC Corporation',100);
INSERT INTO "Shares" VALUES(2,'XYZ Inc.',200);
INSERT INTO "Shares" VALUES(3,'PQR Ltd.',300);
INSERT INTO "Shares" VALUES(4,'LMT LLC',400);
INSERT INTO "Shares" VALUES(5,'KLM & Co.',500);
CREATE TABLE Transactions (TransactionID INTEGER PRIMARY KEY, AccountNumber INTEGER, Amount REAL, TransactionDate DATETIME DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY(AccountNumber) REFERENCES Accounts(AccountNumber));
INSERT INTO "Transactions" VALUES(1,1,200.0,'2024-02-19 15:02:11');
INSERT INTO "Transactions" VALUES(2,2,300.0,'2024-02-19 15:02:11');
INSERT INTO "Transactions" VALUES(3,3,400.0,'2024-02-19 15:02:11');
INSERT INTO "Transactions" VALUES(4,4,500.0,'2024-02-19 15:02:11');
INSERT INTO "Transactions" VALUES(5,5,600.0,'2024-02-19 15:02:11');
COMMIT;
