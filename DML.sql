--Project On Library Management Using 
--Data manupulation Language(DML)
--Use this Database
--Trainee ID:1285868
--Name:Sonia Khatun
--Batch:CS/SCSL-A/63/01


USE LibraryDB
GO
--------Insert Into Table--------
---------Publisher---------

INSERT INTO Publisher(PublisherId,PublisherName)
VALUES 
(101,'Secker & Warburg'),
(102,'Penguin'),
(103,'Dover Publication'),
(104,'Grove Press')

Select*From Publisher

---------Writer---------
INSERT INTO Writer(WriterId,WriterFName,WriterLName)
VALUES
(201,'Reorge ','Orwell'),
(202,'Ted ','Simon'),
(203,'William ','Shakespeare'),
(204,'Wilfre ','Thesiger'),
(205,'Jane ','Austen'),
(206,'Samuel ','Beckett')

Select * From Writer
--------Genre--------
INSERT INTO Genre(GenreId,GenreTitle)
VALUES
(301,'Fiction'),
(302,'Travel'),
(303,'Drama')

Select * From Genre

--------Book--------
INSERT INTO Book(BookId,BookName,PublisherId,WriterId,GenreId)
VALUES
(1,'Animal Firm',101,201,301),
(2,'Jupiter Travels',102,202,302),
(3,'Hamlet',103,203,303),
(4,'Pride & Prejudice',103,206,301),
(5,'Arabian Sands',102,204,302),
(6,'Waiting for Godot',104,205,303)

Select * From Book
--------LibraryMember--------
INSERT INTO LibraryMember(MemberId,MemberFName,MemberLName,PhoneNumber)
VALUES
(401,'Alex','Wilsion','01903336365'),
(402,'Dennis','Carol','01705633365'),
(403,'Emily','Brown','01515614161'),
(404,'Terry','Kim','01305408798')

Select * From LibraryMember

--------Employee--------
INSERT INTO Employee(EmployeeId,EmployeeFName,EmployeeLName,Salary)
VALUES
(501,'Allen','Smith','15000'),
(502,'Tony','Gilbert','20000'),
(503,'Christopher','Nolan','25000'),
(504,'Jaime','Carrillo','22000')

Select * From Employee
--------Terms--------
INSERT INTO Terms(TermsId,TermsDescription)
VALUES
(601,'Net Due 7 days'),
(602,'Net Due 10 days'),
(603,'Net Due 15 days'),
(604,'Net Due 17 days')

Select *From Terms

--------BookTransaction--------
INSERT INTO BookTransaction(TransactionId,MemberId,BookId,EmployeeId,TermsId,IssueDate,ReturnDate)
VALUES
(701,401,1,501,601,'2024-01-20','2024-02-20'),
(702,401,2,502,601,'2024-02-20','2024-03-20'),
(703,402,3,501,603,'2024-01-21','2024-02-12'),
(704,403,4,502,603,NULL,'2024-11-15'),
(705,403,5,502,602,'2021-10-13','2024-10-13'),
(706,404,6,501,604,Null,'2024-12-11'),
(707,403,3,502,603,'2024-09-12','2024-10-12')

SELECT * FROM BookTransaction

---------------- Database Design End Heare-------------------------
--The basic syntax of the SELECT statement.
USE LibraryDB
GO
SELECT *
FROM Employee
--SELECT statement examples.
SELECT EmployeeId,EmployeeFName,EmployeeLName,Salary
FROM Employee

------------Between/And-------
Select MemberId,ReturnDate From BookTransaction
Where ReturnDate Between '2024-03-20' And '2024-12-11'

SELECT * FROM Employee
WHERE Salary >=15000

--How to code column specifications

SELECT EmployeeId,EmployeeFName+' '+EmployeeLName AS [Employee Full Name]
FROM Employee

SELECT EmployeeId,EmployeeFName,EmployeeLName,GETDATE() AS CurrentDate
FROM Employee
WHERE Salary >=15000

--How to code string expressions
SELECT WriterId,WriterFName+' '+WriterLName AS [Writer Full Name]
FROM Writer

--How to code arithmetic expressions

SELECT EmployeeId,EmployeeId + 10 * 5 AS OrderOfPrecedence,
(EmployeeId + 10) * 5 AS AddFirst
FROM Employee
ORDER BY EmployeeId

SELECT WriterId,
WriterId / 10 AS Quotient,
WriterId % 10 AS Remainder
FROM Writer
ORDER BY WriterId

--How to use functions
SELECT WriterFName, WriterLName,
LEFT (WriterFName, 1) +
LEFT (WriterLName, 1) AS Codename
FROM Writer


SELECT IssueDate,
GETDATE() AS 'Today''s Date',
DATEDIFF(DAY,IssueDate,GETDATE()) AS IssueDay
FROM BookTransaction

--How to use the TOP clause

Select Top 5 ReturnDate
From BookTransaction
Where ReturnDate<'2024-12-11'
Order By IssueDate Desc

SELECT TOP 2 PERCENT WriterId, WriterFName
FROM Writer
ORDER BY WriterFName DESC;

SELECT TOP 4 WITH TIES EmployeeId, Salary
FROM Employee
ORDER BY Salary DESC;

--How to code the WHERE clause

SELECT EmployeeId, EmployeeFName,EmployeeLName
FROM Employee
WHERE EmployeeFName ='Allen';


Select TransactionId,EmployeeId,IssueDate From BookTransaction
Where IssueDate>'2021-10-13' And EmployeeId = 502

Select TransactionId,EmployeeId,IssueDate From BookTransaction
Where IssueDate>'2024-10-15'OR EmployeeId = 501

Select MemberId,ReturnDate From BookTransaction
Where ReturnDate Between '2024-03-20' And '2024-12-11'

--How to use the IN operator

SELECT EmployeeId,EmployeeFName,EmployeeLName 
FROM Employee
WHERE EmployeeFName NOT IN ('Ted');

SELECT EmployeeId,EmployeeFName,EmployeeLName 
FROM Employee
WHERE EmployeeFName  IN ('Tony');

Select TermsId,MemberId,IssueDate,ReturnDate From BookTransaction
Where TermsId In
(Select TermsId From Terms
Where TermsDescription = 'Net Due 10 days')


Select B.BookId,B.BookName,BT.MemberId,BT.IssueDate 
From BookTransaction As BT Join Book As B
On BT.BookId=B.BookId
Where B.BookName Not In ('Animal Firm','Hamlet') And IssueDate>'2024-02-20' 

--How to use the LIKE operator

Select BookName From Book
Where BookName Like 'Jupiter%'

Select BookName From Book
Where BookName Like '[abr]%'

Select BookName From Book
Where BookName Like 'A[A-P]%'

Select BookName From Book
Where BookName Like 'A[^A-Q]%'

--How to retrieve a range of selected rows

Select TransactionId,MemberId,BookId,EmployeeId,IssueDate From BookTransaction
Order By TransactionId,MemberId,BookId,EmployeeId,IssueDate
Offset 3 Rows
Fetch Next 3 Rows only

SELECT * 
FROM Writer
ORDER BY WriterId DESC
OFFSET 2 ROWS
FETCH NEXT 3 ROWS ONLY;
--How to code aggregate functions
SELECT 
SUM(Salary)  AS invTotal,
AVG(Salary)  AS invAvg
FROM Employee

----COUNT() Function

SELECT 
	COUNT(Book.BookId) AS NumberOfEmployee
	FROM Employee
 JOIN Book ON Employee.EmployeeId = Employee.EmployeeId
	GROUP BY Employee.EmployeeFName;


------SUM() Function
SELECT SUM(Salary ) AS TotalSalary
FROM Employee;


-----AVG() Function
SELECT AVG(Salary) AS AverageSalary
FROM Employee;


----- MIN() Function
SELECT MIN(Salary) AS MinSalary
FROM Employee;


-----MAX() Function
SELECT MAX(Salary) AS MaxSalary
FROM Employee;


--How to code the GROUP BY and HAVING clauses


SELECT EmployeeFName+' '+EmployeeLName AS FullName,e.EmployeeFName,e.EmployeeLName,
COUNT(*) AS InvoiceQty,
AVG(e.Salary) AS InvoiceAvg
FROM Employee AS e JOIN Book AS b
ON e.EmployeeId=e.EmployeeId
GROUP BY e.EmployeeFName,e.EmployeeLName
ORDER BY FullName;



SELECT EmployeeId,EmployeeFName,AVG(Salary) AS AvgSalary
FROM Employee
GROUP BY EmployeeId,EmployeeFName
HAVING AVG(Salary)>15000

--How to summarize data using SQL Server extensions

SELECT EmployeeId ,EmployeeFName,EmployeeLName,COUNT(*) AS EmployeeCount
FROM Employee
GROUP BY EmployeeId,EmployeeFName,EmployeeLName  WITH ROLLUP


SELECT WriterFName,WriterLName,COUNT(*) AS WriterCount
FROM Writer
GROUP BY WriterFName,WriterLName  WITH CUBE

Select IssueDate,MemberId,COUNT(*) AS QtyTransaction From BookTransaction
Where IssueDate in ('2024-09-12','2024-11-11')
Group By GROUPING Sets (IssueDate,MemberId)

----------OVER CLAUSE----------

SELECT EmployeeFName,EmployeeLName,Salary,
SUM(Salary) OVER (Partition BY EmployeeFName) AS invTotal,
AVG(Salary) OVER (Partition BY EmployeeFName) AS invAvg
FROM Employee

--How to use subqueries
SELECT WriterFName, WriterLName FROM Writer WHERE WriterId IN
(SELECT WriterId FROM Writer)
ORDER BY WriterFName

--How subqueries compare to joins

SELECT TransactionId, IssueDate 
FROM BookTransaction
WHERE TransactionId IN 
(SELECT TransactionId 
FROM BookTransaction)
ORDER BY IssueDate;

---------ANY---------
SELECT EmployeeId,EmployeeFName,Salary
FROM Employee WHERE Salary>ANY
(SELECT Salary FROM Employee WHERE EmployeeId=502)

----------ALL--------
SELECT EmployeeId,EmployeeFName,Salary
FROM Employee WHERE Salary>ALL
(SELECT Salary FROM Employee WHERE EmployeeId=502)

---------SOME--------
SELECT EmployeeId,EmployeeFName,Salary
FROM Employee WHERE Salary<SOME
(SELECT Salary FROM Employee WHERE EmployeeId=502)
----------Exists--------

Select TermsId From BookTransaction
Where Exists
(Select TermsId From Terms)

--How to code a CTE

WITH BookTran AS
(
SELECT lm.MemberFName,COUNT(TransactionId) As TranCount
FROM BookTransaction AS bt JOIN LibraryMember As lm  ON bt.MemberId=lm.MemberId
GROUP BY lm.MemberFName
),
MINTran AS
(SELECT bt.MemberFName, MIN(TranCount) AS MINTran FROM BookTran AS bt GROUP BY bt.MemberFName)
SELECT bt.MemberFName,bt.TranCount,mt.MINTran
FROM BookTran bt JOIN MINTran  mt ON bt.MemberFName=mt.MemberFName

--How to use the SELECT INSERT statement

Select * From Employee

Insert Into Employee (EmployeeId,EmployeeFName,EmployeeLName,Salary)
Values (510,'Sonia','Akter',15000)

--How to use the SELECT INTO statement

SELECT * INTO GenreArchive FROM Genre
SELECT * INTO GenreCopy FROM Genre

SELECT * INTO TermsDescription
FROM Terms;
--DELETE statement
Select * From Employee

Insert Into Employee(EmployeeId,EmployeeFName,EmployeeLName,Salary)Values
 (512,'Sonia','Akter',15000)

Delete From Employee
Where EmployeeId =510

--A MERGE statement that inserts and updates rows

MERGE INTO GenreArchive AS ga
USING GenreCopy AS gc
ON ga.GenreID = gc.GenreID
WHEN MATCHED
THEN UPDATE SET
ga.GenreTitle = gc.GenreTitle
WHEN NOT MATCHED  
THEN INSERT (GenreID,GenreTitle )
VALUES (gc.GenreID, gc.GenreTitle);

--How to convert data using the CAST function

USE LibraryDB
GO
SELECT IssueDate,
CAST(IssueDate AS varchar)AS strIssDate
FROM BookTransaction

SELECT Salary,
CAST(Salary AS varchar)AS strSalPrice
FROM Employee

--CONVERT function

USE LibraryDB
GO
SELECT ReturnDate,
CONVERT(varchar , ReturnDate)AS strInvDate,
CONVERT(varchar,ReturnDate,1)AS strInvDate1,
CONVERT(varchar,ReturnDate,107)AS strInvDate2 
FROM BookTransaction


SELECT Salary,
CONVERT(varchar , Salary)AS strInvPrice,
CONVERT(varchar,Salary,1)AS strInvPrice1,
CONVERT(varchar,Salary,107)AS strInvPrice2  
FROM Employee

--TRY CONVERT function

USE LibraryDB
GO
SELECT ReturnDate,
TRY_CONVERT(varchar , ReturnDate)AS strInvDate,
TRY_CONVERT(varchar,ReturnDate,1)AS strInvDate1,
TRY_CONVERT(varchar,ReturnDate,107)AS strInvDate2 ,
TRY_CONVERT(date, 'Feb 29 2018') AS InvalidDate
FROM BookTransaction


SELECT Salary,
TRY_CONVERT(varchar , Salary)AS strInvPrice,
TRY_CONVERT(varchar,Salary,1)AS strInvPrice1
FROM Employee
--String function examples 

SELECT LEN(WriterFName) AS fNameLEN
FROM Writer

SELECT LEFT(EmployeeFName,3) AS fNameLEFT
FROM Employee

SELECT LOWER(EmployeeFName) AS fNameLowerCas
FROM Employee

SELECT UPPER(EmployeeFName) AS fNameUpperCas
FROM Employee

SELECT EmployeeFName,PATINDEX('%A_n%',EmployeeFName) AS fNamePATINDEX
FROM Employee

SELECT EmployeeFName,CHARINDEX('jo',EmployeeFName) AS fNameCHARINDEX
FROM Employee

SELECT EmployeeFName,EmployeeLName,CONCAT(EmployeeFName,' ',EmployeeLName) AS FullName
FROM Employee

--Examples that use the numeric functions 

SELECT ROUND(200.386,0) AS WriterRound

SELECT ROUND(200.386,1) AS WriterRound

SELECT ROUND(199.386,-1) AS WriterRound

SELECT ROUND(199.386,0,1) AS WriterRound

SELECT ISNUMERIC('Jony') AS NumericTest

SELECT ABS(-256.63) AS ABSTest

SELECT CEILING(-256.63) AS CEILINGTest

SELECT FLOOR(-256.63) AS FLOORTest

SELECT SQUARE(256.63) AS SQUARETest

SELECT SQRT(256.63) AS SQRTTest

--Examples that use date/time functions

SELECT GETDATE () AS CurrentDate;

SELECT SYSDATETIMEOFFSET() AS OffsetDate

SELECT MONTH(IssueDate) AS MonthOfTransaction
FROM BookTransaction;

SELECT DATEPART(MONTH,IssueDate) AS MonthOfTransaction
FROM BookTransaction;

SELECT DATENAME(MONTH,IssueDate) AS MonthOfTransaction
FROM BookTransaction;

SELECT EOMONTH(ReturnDate) AS EndDayOfTransaction
FROM BookTransaction;

SELECT EOMONTH(ReturnDate,2) AS EndDayOfTransaction
FROM BookTransaction;

SELECT ISDATE('2024-12-19') AS EndDayOfTransaction
FROM BookTransaction;

--Examples that use the DATEPART function

SELECT DATEPART(DAY,IssueDate) AS DatepartOfTransaction
FROM BookTransaction;

SELECT DATEPART(MONTH,IssueDate) AS DatepartOfTransaction
FROM BookTransaction;

SELECT DATEPART(YEAR,IssueDate) AS DatepartOfTransaction
FROM BookTransaction;

SELECT DATEPART(quarter,IssueDate) AS DatepartOfTransaction
FROM BookTransaction;

SELECT DATEPART(DAYOFYEAR,IssueDate) AS DatepartOfTransaction
FROM BookTransaction;

SELECT DATEPART(WEEK,IssueDate) AS DatepartOfTransaction
FROM BookTransaction;

--Examples that use the DATENAME function 

SELECT DATENAME(WEEK,IssueDate) AS DatepartOfTransaction
FROM BookTransaction;

SELECT DATENAME(MONTH,IssueDate) AS DatepartOfTransaction
FROM BookTransaction;

SELECT DATENAME(WEEKDAY,IssueDate) AS DatepartOfTransaction
FROM BookTransaction;

--Examples that use the DATEADD function

SELECT DATEADD(DAY,1,IssueDate) AS DatepartOfTransaction
FROM BookTransaction;

SELECT DATEADD(MONTH,1,IssueDate) AS DatepartOfTransaction
FROM BookTransaction;

SELECT DATEADD(YEAR,1,IssueDate) AS DatepartOfTransaction
FROM BookTransaction;

--Examples that use the DATEDIFF function 

SELECT DATEDIFF(DAY,IssueDate,GETDATE()) AS DatepartOfTransaction
FROM BookTransaction;

SELECT DATEDIFF(MONTH,IssueDate,GETDATE()) AS DatepartOfTransaction
FROM BookTransaction;

SELECT DATEDIFF(YEAR,IssueDate,GETDATE()) AS DatepartOfTransaction
FROM BookTransaction;

SELECT DATEDIFF(WEEK,IssueDate,GETDATE()) AS DatepartOfTransaction
FROM BookTransaction;

-- uses a simple CASE function

USE LibraryDB
GO
SELECT WriterFName,WriterId,
CASE WriterId
WHEN 1 THEN '10 days'
WHEN 2 THEN '20 days'
WHEN 3 THEN '30 days'
END tdescription
FROM Writer


SELECT
    Salary,
    CASE
        WHEN Salary < 15000 THEN 'Low'
        WHEN Salary BETWEEN 15000 AND 22000 THEN 'Medium'
        ELSE 'High'
    END AS EmpStatus
FROM
    Employee;

--How to use the IIF and CHOOSE functions

USE LibraryDB
GO
SELECT EmployeeId,SUM(Salary) AS SumTotal,
IIF(SUM(Salary)>15000,'High','Low') AS SlyRange
FROM Employee
GROUP BY EmployeeId
ORDER BY SUM(Salary) DESC

USE LibraryDB
SELECT EmployeeFName,EmployeeLName,EmployeeId ,
CHOOSE(EmployeeId,'10 days','20 days','30 days','60 days','90 days') AS NetDues
FROM Employee

--How to use the COALESCE and ISNULL functions 

USE LibraryDB
GO
SELECT g.GenreTitle,b.PublisherId ,
COALESCE(CAST(b.publisherId AS varchar),'No Genre') GenStatus
FROM Genre g RIGHT JOIN Book b ON g.GenreId=b.GenreId

USE LibraryDB
GO
SELECT TransactionId,IssueDate,ISNULL(IssueDate,'') 
NewIssueDate FROM BookTransaction
WHERE IssueDate IS NULL

----grouping-------
SELECT EmployeeFName, EmployeeLName, COUNT(*) AS QtyEmployee
FROM Employee
WHERE EmployeeFName IN (' Allen', 'Tony')
GROUP BY EmployeeFName, EmployeeLName
ORDER BY EmployeeFName DESC,EmployeeLName DESC;

--How to use the ranking functions

USE LibraryDB
GO
SELECT GenreId,ROW_NUMBER() OVER(ORDER BY GenreId) 
AS RowNumber,GenreTitle FROM Genre

SELECT EmployeeId,ROW_NUMBER()OVER(ORDER BY EmployeeId)
AS RowNumber,EmployeeFName FROM Employee

SELECT TermsId,ROW_NUMBER()OVER(ORDER BY TermsId)
AS RowNumber,TermsDescription FROM Terms

SELECT EmployeeId,EmployeeFName,EmployeeLName,Salary,
RANK() OVER ( ORDER BY Salary  DESC) AS RankNo FROM Employee

SELECT EmployeeId,EmployeeFName,EmployeeLName,Salary,
DENSE_RANK() OVER ( ORDER BY Salary) AS DenseRankNo FROM Employee

USE LibraryDB
GO
SELECT TermsDescription,
NTILE(2) OVER (ORDER BY TermsID) AS Tile2,
NTILE(3) OVER (ORDER BY TermsID) AS Tile3,
NTILE(4) OVER (ORDER BY TermsID) AS Tile4,
NTILE(5) OVER (ORDER BY TermsID) AS Tile5
FROM Terms

SELECT GenreTitle, 
NTILE(2) OVER (ORDER BY GenreId ) AS Tile2,
NTILE(3) OVER (ORDER BY GenreId) AS Tile3,
NTILE(4) OVER (ORDER BY GenreId) AS Tile4,
NTILE(5) OVER (ORDER BY GenreId) AS Tile5
FROM Genre

----FIRST_VALUE------
Use LibraryDB
Go
SELECT TransactionId,MemberId,BookId,EmployeeId,TermsId,IssueDate,ReturnDate,
FIRST_VALUE(TermsId) OVER (PARTITION BY EmployeeId ORDER BY IssueDate)
AS FirstValue FROM BookTransaction

---LAST_VALUE---
Use LibraryDB
Go
SELECT TransactionId,MemberId,BookId,EmployeeId,TermsId,IssueDate,ReturnDate,
LAST_VALUE(TermsId) OVER (PARTITION BY EmployeeId ORDER BY IssueDate)
AS LastValue FROM BookTransaction

---LEAD----
SELECT EmployeeId,EmployeeFName,EmployeeLName,Salary,
LEAD(Salary) OVER (PARTITION BY EmployeeId  ORDER BY EmployeeFName ) 
AS LeadSalary FROM Employee
---LEG---
SELECT EmployeeId,EmployeeFName,EmployeeLName,Salary,
LAG(Salary) OVER (PARTITION BY EmployeeId  ORDER BY EmployeeFName ) 
AS LeadSalary FROM Employee

--CUME_DIST()---
SELECT EmployeeId,EmployeeFName,EmployeeLName,Salary,
CUME_DIST() OVER (PARTITION BY EmployeeId ORDER BY Salary) 
Cumulative_Distribution FROM Employee

---------PERCENT_RANK----

Select Salary,
ROUND(Percent_Rank() Over (Order By Salary),2) As Percent_Rank 
From Employee;


---------PERCENTILE_DISC------

Select EmployeeId,PERCENTILE_DISC(0.75)
Within Group (Order By Salary)
Over (Partition By Salary) As Pcnt_75_Disc
From Employee;

--------PERCENTILE_CONT--------

Select EmployeeId,PERCENTILE_CONT(0.75)
Within Group (Order By Salary)
Over (Partition By EmployeeId) As Percentile_75_Cont
From Employee;


