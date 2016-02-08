Use SergeDB

-- good data 
truncate table dbo.Source
insert into dbo.Source
values (12345, 'asdlfka','dlasfj','asdfgdas')
exec dbo.SafeInsertDemo
select * from dbo.Source
select * from dbo.Destination


-- bad data 
insert into dbo.Source
values (12345, '2sdlfkadlafkjjkldsfj','2lasfj','2asdfgdas')
exec dbo.SafeInsertDemo
select * from dbo.Source
select * from dbo.Destination
