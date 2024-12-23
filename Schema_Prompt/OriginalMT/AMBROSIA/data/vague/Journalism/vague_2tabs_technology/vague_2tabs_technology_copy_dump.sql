BEGIN TRANSACTION;
CREATE TABLE Article (
    id INTEGER PRIMARY KEY,
    title TEXT,
    content TEXT,
    author_id INTEGER,
    category_id INTEGER,
    FOREIGN KEY(author_id) REFERENCES Author(id),
    FOREIGN KEY(category_id) REFERENCES Category(id)
);
INSERT INTO "Article" VALUES(1,'New Political Laws','An article discussing new political laws.',1,1);
INSERT INTO "Article" VALUES(2,'AI Advancements','A piece covering recent AI advancements.',2,2);
INSERT INTO "Article" VALUES(3,'Vaccine Breakthrough','Discussing a major breakthrough in vaccine development.',3,3);
INSERT INTO "Article" VALUES(4,'Online Learning Growth','Exploring the growth of online education during the pandemic.',4,4);
INSERT INTO "Article" VALUES(5,'Blockbuster Movie Release','Coverage of an upcoming blockbuster movie release.',5,5);
CREATE TABLE Author (
    id INTEGER PRIMARY KEY,
    name TEXT,
    email TEXT UNIQUE
);
INSERT INTO "Author" VALUES(1,'John Doe','john.doe@example.com');
INSERT INTO "Author" VALUES(2,'Jane Smith','jane.smith@example.com');
INSERT INTO "Author" VALUES(3,'Michael Johnson','michael.johnson@example.com');
INSERT INTO "Author" VALUES(4,'Emily Davis','emily.davis@example.com');
INSERT INTO "Author" VALUES(5,'David Brown','david.brown@example.com');
CREATE TABLE Category (
    id INTEGER PRIMARY KEY,
    name TEXT
);
INSERT INTO "Category" VALUES(1,'Politics');
INSERT INTO "Category" VALUES(2,'Technology');
INSERT INTO "Category" VALUES(3,'Health');
INSERT INTO "Category" VALUES(4,'Education');
INSERT INTO "Category" VALUES(5,'Entertainment');
CREATE TABLE "Online_News_Platform" (
    id INTEGER PRIMARY KEY,
    platform_name TEXT,
    url TEXT,
    cms_id INTEGER,
    FOREIGN KEY(cms_id) REFERENCES "Technology"(id));
INSERT INTO "Online_News_Platform" VALUES(1,'The Daily News','https://www.thedailynews.com',1);
INSERT INTO "Online_News_Platform" VALUES(2,'Tech Today','https://techtoday.net',2);
INSERT INTO "Online_News_Platform" VALUES(3,'Health Insider','https://healthinsider.org',3);
INSERT INTO "Online_News_Platform" VALUES(4,'Edu World','https://eduworld.info',4);
INSERT INTO "Online_News_Platform" VALUES(5,'Fun Times','https://funtimesmagazine.com',5);
CREATE TABLE "Technology" (
    id INTEGER PRIMARY KEY,
    system_name TEXT,
    description TEXT
);
INSERT INTO "Technology" VALUES(1,'WordPress','The most popular CMS for creating websites.');
INSERT INTO "Technology" VALUES(2,'Drupal','A powerful open-source CMS known for its flexibility and security features.');
INSERT INTO "Technology" VALUES(3,'Joomla!','A user-friendly CMS with numerous extensions and templates.');
INSERT INTO "Technology" VALUES(4,'Typo3','A widely used enterprise CMS for large projects.');
INSERT INTO "Technology" VALUES(5,'Joomla!','A versatile CMS that can be customized to fit various needs.');
COMMIT;
