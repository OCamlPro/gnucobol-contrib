connect to testdb user db2local using db2localPW;

-- first delete all books
DELETE FROM BOOK;

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9780345391803
, 'Douglas Adams'
, 'The Hitchhikers Guide to the Galaxy (Book 1)'
, '1995-09-27'
, 224
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9780345391810
, 'Douglas Adams'
, 'The Restaurant at the End of the Universe (Book 2)'
, '1995-09-27'
, 256
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9780345391827
, 'Douglas Adams'
, 'Life, the Universe and Everything (Book 3)'
, '1995-09-27'
, 240
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9780345391834
, 'Douglas Adams'
, 'So Long, and Thanks for All the Fish (Book 4)'
, '1999-03-29'
, 224
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9780345418777
, 'Douglas Adams'
, 'Mostly Harmless (Book 5)'
, '2000-02-01'
, 240
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9780884150879
, 'Ronald W. Doerfler'
, 'Dead Reckoning: Calculating Without Instruments'
, '1993-09-01'
, 182
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9781583473498
, 'Roger E. Sanders'
, 'DB2 10.1 Fundamentals: Certification Study Guide'
, '2014-08-15'
, 536
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9780596007300
, 'Andrew Davison'
, 'Killer Game Programming in Java'
, '2005-05-30'
, 998
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9783446431195
, 'Jonas Freiknecht'
, 'Spiele entwickeln mit Gamestudio'
, '2012-10-04'
, 462
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9781450563444
, 'John Cook'
, 'Getting Started with Conitecs 3D Gamestudio'
, '2010-02-09'
, 74
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9783455503869
, 'Guinness World Records Ltd'
, 'Guinness World Records 2016 Gamers Edition'
, '2015-10-10'
, 216
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9783826609459
, 'Raouf Habib, Uwe Rozanski'
, 'Cobol 2002 de Luxe'
, '2003-01-01'
, 953
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9780672314537
, 'Thane Hubbell'
, 'Sams Teach Yourself COBOL in 24 Hours, w. CD-ROM'
, '1998-12-24'
, 496
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9781890774028
, 'Steve Eckols, Curtis Garvin'
, 'DB2 for the Cobol Programmer'
, '1998-11-01'
, 431
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9780471026297
, 'John B. Crawford'
, 'Getting Started With Micro Focus Personal Cobol 2.0'
, '1994-03-01'
, 88
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9780471183464
, 'E. Reed Doke, Bill C. Hardgrave'
, 'An Introduction to Object COBOL (Computer Science)'
, '1997-10-24'
, 204
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9780435778040
, 'John Watters'
, 'Cobol Programming'
, '1978-05-30'
, 360
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9780956266804
, 'Jane Austen'
, 'Pride and Prejudice'
, '2010-10-28'
, 432
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9780141192475
, 'Jane Austen'
, 'Emma'
, '2009-10-01'
, 512
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9783140224239
, 'Franz Kafka'
, 'Erzaehlungen und Parabeln'
, '2008-08-19'
, 192
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9783140224253
, 'Georg Buechner'
, 'Lenz. Der Hessische Landbote'
, '2010-04-19'
, 130
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9783426514702
, 'Maeve Binchy'
, 'Ein Cottage am Meer'
, '2015-11-02'
, 400
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9783492404716
, 'Andreas Kieling, Sabine Wuensch'
, 'Ein deutscher Wandersommer'
, '2013-02-12'
, 304
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9783596163908
, 'Audrey Niffenegger, Brigitte Jakobeit'
, 'Die Frau des Zeitreisenden'
, '2005-11-01'
, 544
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9783462041491
, 'Katharina Hagena'
, 'Der Geschmack von Apfelkernen'
, '2009-08-18'
, 254
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9783442382170
, 'Mary Simses'
, 'Der Sommer der Blaubeeren'
, '2014-04-21'
, 416
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9783772525278
, 'Ulrike Richter'
, 'Fahrschule Ernaehrung'
, '2011-04-13'
, 225
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9783625136583
, 'Naumann & Goebel Verlag'
, '1000 vegetarische Gerichte'
, '2012-12-11'
, 624
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9780007538416
, 'Cecelia Ahern'
, 'PS, I Love You'
, '2014-01-16'
, 497
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9783426614471
, 'Maeve Binchy'
, 'Jeden Freitagabend'
, '1999-03-01'
, 240
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9780810993136
, 'Jeff Kinney'
, 'Diary of a Wimpy Kid # 1: Greg Heffleys Journal'
, '2007-04-01'
, 224
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9783850520003
, 'Paramhans Swami Maheshwarananda'
, 'Yoga in daily Life - The system'
, '2000-01-01'
, 448
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9783923646425
, 'Gerhard Hross'
, 'Escape to Fear: Der Horror des John Carpenter'
, '2000-01-01'
, 300
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9781783294688
, 'Kim Gottlieb-Walker'
, 'On Set with John Carpenter'
, '2014-10-21'
, 176
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

INSERT INTO BOOK 
(
  ISBN
, AUTHORS
, TITLE
, PUB_DATE
, PAGE_NR
, INSERT_USER
, INSERT_TIMESTAMP
, LUPD_USER
, LUPD_TIMESTAMP
, LUPD_COUNTER
) 
VALUES 
(
  9780062419149
, 'Michael Klastorin, Randal Atamaniuk'
, 'Back to the Future: The Ultimate Visual History'
, '2015-10-20'
, 224
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 'LASZLO.ERDOES'
, CURRENT TIMESTAMP
, 0
);

-- count all books
SELECT COUNT(*) FROM BOOK;
    
connect reset;
