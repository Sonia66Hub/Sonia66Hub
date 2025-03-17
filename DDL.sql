--Project On Library Management 
--Example Of Data Definition Language (DDL)
--Create Database
--Trainee ID:1285868
--Name:Sonia Khatun
--Batch:CS/SCSL-A/63/01


USE master
GO
IF DB_ID('LibraryDB') IS NOT NULL
DROP DATABASE LibraryDB
GO

CREATE DATABASE LibraryDB
ON
(
Name = 'LibraryDB_Data_01',
FileName='C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\LibraryDB_Data_01.mdf',
Size= 25 Mb,
Maxsize= 100 Mb,
FileGrowth = 5%
)
Log ON
(
Name = 'LibraryDB_Log_01',
FileName='C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\LibraryDB_Log_01.ldf',
Size= 2 Mb,
Maxsize= 25 Mb,
FileGrowth = 1%
)
GO
----Use this Database--
USE LibraryDB
GO

------------Table Create------------
------------ Publisher------------

Drop Table If Exists Publisher
CREATE TABLE Publisher
(
PublisherId int not null primary key,
PublisherName varchar(50) not null
)

--------- Create Writer Table -------------
Drop Table If Exists Writer
CREATE TABLE Writer
(
WriterId int not null  primary key,
WriterFName varchar(20) not null,
WriterLName varchar(20) not null
)
--------- Create Genre Table --------
Drop Table If Exists Genre
CREATE TABLE Genre
(
GenreId int not null primary key,
GenreTitle varchar(10) not null
)
--------- Create Book Table ---------
Drop Table If Exists Book
CREATE TABLE Book
(
BookId int not null primary key,
BookName varchar (20),
PublisherId int not null references Publisher(PublisherId),
WriterId int not null references Writer(WriterId),
GenreId int not null references Genre(GenreId),
)
--------- Create LibraryMember Table --------
Drop Table If Exists LibraryMember
CREATE TABLE LibraryMember
(
MemberId int not null primary key,
MemberFName varchar (10) not null,
MemberLName varchar (10) not null,
PhoneNumber varchar (20)not null
)
--------- Create Employee Table --------
Drop Table If Exists Employee
CREATE TABLE Employee
(
EmployeeId int not null primary key,
EmployeeFName varchar (15) not null,
EmployeeLName varchar (15) not null,
Salary money not null
)
--------- Create Terms Table --------
Drop Table If Exists Terms 
CREATE TABLE Terms
(
TermsId int not null primary key,
TermsDescription varchar (35) not null
)
--------- Create BookTransaction Table --------
Drop Table If Exists BookTransaction
CREATE TABLE BookTransaction
(
TransactionId int not null primary key,
MemberId int not null references LibraryMember(MemberId),
BookId int not null references Book(BookId),
EmployeeId int not null references Employee(EmployeeId),
TermsId int not null references Terms(TermsId),
IssueDate date null,
ReturnDate date not null
)

-----How To Create Procedure for LibraryDB-----

USE LibraryDB
GO
CREATE PROC spSelectInsertUpdateDeleteOutputOptionParameReturn
@InvOparation int =0,
@WriterId int,
@WriterFName varchar (40),
@WriterLName varchar (40),
@FullName varchar (30)output,
@ReturnCount int
as
begin
if @InvOparation=1
begin
select WriterId,WriterFName,WriterLName from Writer
end
if @InvOparation =2
BEGIN
BEGIN TRY
BEGIN TRAN
INSERT INTO Writer VALUES(@WriterId,@WriterFName,@WriterLName)
COMMIT TRAN
END TRY
BEGIN CATCH
SELECT ERROR_MESSAGE()ErrMessage,ERROR_NUMBER()ErrNumber
ROLLBACK TRAN
END CATCH
END
IF @InvOparation =3
BEGIN
UPDATE Writer SET WriterFName=@WriterFName,WriterLName=@WriterLName WHERE WriterId=@WriterId
END
IF @InvOparation =4
BEGIN
DELETE FROM Writer WHERE WriterId=@WriterId
END
IF @InvOparation =5
BEGIN
SELECT @FullName=WriterFName+' '+WriterLName FROM Writer WHERE WriterId=@WriterId
END
IF @InvOparation =6
BEGIN
SELECT @ReturnCount=COUNT(*) FROM Writer
RETURN @ReturnCount
END
END

------Calling for Procedure----

GO
-------SELECT------
EXEC spSelectInsertUpdateDeleteOutputOptionParameReturn '1','','','','',''

-----INSERT-----
EXEC spSelectInsertUpdateDeleteOutputOptionParameReturn '2','','Sonia','yesmin','',''

-----UPDATE-----
EXEC spSelectInsertUpdateDeleteOutputOptionParameReturn '3','206','Sonia yesmin','','',''

-----DELETE----
EXEC spSelectInsertUpdateDeleteOutputOptionParameReturn '4','','','','',''

-----OUTPUT----
declare @name varchar (30)
EXEC spSelectInsertUpdateDeleteOutputOptionParameReturn '5','206','','',@name output,''
print @name

-----RETURN----
declare @count int
EXEC @count=spSelectInsertUpdateDeleteOutputOptionParameReturn '6','','','','',''
SELECT  'Return value '+CONVERT( varchar, @count) AS ReturnValue

----View  schemabinding ----

GO
CREATE VIEW vu_writerandbookSchema
WITH SCHEMABINDING
AS
Select WriterFName+' '+WriterLName  AS FullName
From dbo.Writer w JOIN dbo.Book b
on w.WriterId=b.WriterId
where WriterFName='Ted'

GO
-----justify----

SELECT * From vu_writerandbookSchema
-----justify----
GO
EXEC sp_helptext vu_writerandbookSchema

----VIEW  ENCRYPTION ----
GO
CREATE VIEW vu_writerandbookEncryption
WITH ENCRYPTION
AS
Select WriterFName+' '+WriterLName  AS FullName
From dbo.Writer w JOIN dbo.Book b
on w.WriterId=b.WriterId
where WriterFName='Ted'

GO
-----justify----
SELECT * From vu_writerandbookEncryption
-----justify----
GO
EXEC sp_helptext vu_writerandbookEncryption


----Scalar value function---

Use LibraryDB
Go
Create function FnGetWriterFName (@writerId int)
Returns varchar (30)
AS
BEGIN
RETURN (SELECT WriterFName FROM Writer WHERE WriterId=@writerId)
END
-----Calling---
GO
SELECT dbo.FnGetWriterFName (206)AS WriterFName

----Table Value Function---
USE LibraryDB
GO
CREATE FUNCTION fnWriterNamebyInWriterId(@ID int)
RETURNS TABLE
AS
RETURN
SELECT WriterFName+' '+WriterLName AS WriterName FROM Writer WHERE WriterId=@ID

----Calling----
GO
SELECT * FROM fnWriterNamebyInWriterId(203)

----Multi-statement function----

GO
CREATE FUNCTION fcnMultistatement(@Amount money)
RETURNS @SalaryTable TABLE
(
EmployeeId int not null,
EmployeeFName varchar (15),
EmployeeLName varchar (15),
Salary money not null
)
AS
BEGIN
INSERT INTO @SalaryTable
SELECT EmployeeId,EmployeeFName,EmployeeLName,Salary FROM Employee
WHERE Salary>=@Amount
RETURN
END

----Justify----
GO
SELECT * FROM fcnMultistatement(20000)

-----------INDEX-------
------NONCLUSTERED-------
USE LibraryDB
GO
CREATE NONCLUSTERED INDEX ix_Employee_EmployeeFname
ON Employee (EmployeeFname)

-----------Justify------
sp_helpindex Employee
--------DROP INDEX--
Drop INDEX ix_Employee_EmployeeFname
ON Employee

----------Justify--------
Exec  SP_HELPINDEX Employee

--Alter Table Add--
Alter Table Employee ADD Empoleefacebook Varchar(15)
--Alter Drop Collum--
Alter Table Employee DROP Column Empoleefacebook

------Cursor  for LibraryDB

USE LibraryDB
GO
DECLARE @EmployeeIDVar int,@EmployeeFName varchar(30) ,@SalaryTotalVar money,@UpdateCountVar int 
SET @UpdateCountVar=0;

DECLARE EmployeeDueCursor2 CURSOR
FOR 
SELECT EmployeeId,EmployeeFName,Salary FROM Employee 
WHERE Salary>0

OPEN EmployeeDueCursor2 
FETCH NEXT FROM EmployeeDueCursor2 INTO @EmployeeIDVar,@EmployeeFName,@SalaryTotalVar
while @@FETCH_STATUS<>-1
BEGIN
IF @EmployeeIDVar>503
BEGIN
Update Employee SET Salary=Salary+100
WHERE EmployeeId=@EmployeeIdVar
SET @UpdateCountVar=@UpdateCountVar+1
END
FETCH NEXT FROM EmployeeDueCursor2 INTO @EmployeeIdVar,@EmployeeFName,@SalaryTotalVar
END
CLOSE EmployeeDueCursor2
DEALLOCATE EmployeeDueCursor2
print'';
print Convert (varchar,@UpdateCountVar)+' row(s) update'


---- How to Create a Trigger LibraryDB

-----After Insert

Go

Create Trigger trLibraryMemberInsert1
on LibraryMember
After Insert
as 
Select * from inserted

Insert Into LibraryMember values ( '404','Terry','Kim','01305408798')

--Trigger After Deleted

Go

Create Trigger trLibraryMemberAfterDeleted
on LibraryMember
After Delete
as 
Select * from deleted

----------Calling
GO
Delete From LibraryMember where MemberId=402

--------------Instead

Use LibraryDB
Go

Create Trigger  trLibraryMemberInsert
On LibraryMember
Instead Of Insert
As 
Select * From inserted
Insert Into LibraryMember Values ( '402','Dennis','Carol','01705633365')

--Trigger Instead Deleted


Go

Create Trigger trLibraryMemberDelete
On LibraryMember
Instead Of Delete
AS 
Select * From deleted

--Calling

Delete From LibraryMember where MemberId=403


-----------------BulkTrigger
GO
CREATE TRIGGER tr_bulkupdate
ON Book
Instead OF update,DELETE
AS
BEGIN
IF (SELECT COUNT(*) FROM deleted)>1 OR (Select COUNT(*) FROM inserted)>1
BEGIN
RAISERROR('Bulk Update Not Allowed',16,1)
END
END

------------calling-----------

UPDATE Book SET BookId=1 WHERE PublisherId=101

------Trigger Alter-----

GO
INSERT INTO Book VALUES(11,'book8',102,202,302)
GO
CREATE TRIGGER Tr_InsertBooks
ON Book
AFTER Insert
AS
Select * FROM inserted
go
CREATE TRIGGER Tr_DELETEBooks
ON Book
AFTER DELETE
AS
SELECT * FROM deleted
DELETE FROM Book
WHERE BookId=11

---PROCEDURE TRIGGER FUNCTION----

GO
CREATE TRIGGER tr_PreventBulkDataUpdateDelete
ON Writer
Instead of Update,Delete
AS
BEGIN
if(select count(*)from deleted)>1 or (select count(*)from inserted)>1
begin
RAISERROR ('BULK UPDATE OR DELETE IS NOT ALLOWES',16,1)
end
end

GO
DELETE FROM Writer WHERE WriterFName ='Ted'
UPDATE Writer SET WriterLName='Orwell' WHERE WriterFName ='Ted'
SELECT * FROM Writer

---------Triggre
USE LibraryDB
GO
SELECT * INTO TermCopy FROM Terms
select * from TermCopy
GO
CREATE TRIGGER tr_PreventMultipleRecordUpdateDelete
ON TermCopy
INSTEAD OF UPDATE, DELETE
AS
BEGIN
SET NOCOUNT ON
IF(SELECT COUNT(*) FROM inserted)>1 OR (SELECT COUNT(*) FROM deleted)>1
BEGIN
RAISERROR('Cannot update or delete more than one record at a time',16,1)
ROLLBACK TRANSACTION
RETURN
END

IF EXISTS(SELECT * FROM inserted)
BEGIN
UPDATE TermCopy SET TermsDescription=i.TermsDescription
FROM TermCopy t
INNER JOIN inserted i ON t.TermsDescription=i.TermsDescription
END
IF EXISTS (SELECT * FROM deleted)
BEGIN
DELETE FROM TermCopy WHERE  TermsDescription IN(SELECT TermsDescription FROM deleted)
END
END

 --------JUSTIFY
DELETE FROM TermCopy WHERE TermsDescription=601
