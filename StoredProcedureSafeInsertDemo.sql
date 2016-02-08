USE SergeDB

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SafeInsertDemo]') AND type in (N'P', N'PC'))
DROP PROCEDURE dbo.SafeInsertDemo
Go

CREATE PROCEDURE dbo.SafeInsertDemo
AS
Begin
	-- let's assume we are doing it for specific market
	Declare @MarketID as int = 1234
	
	If Object_ID('tempdb..#PreDestination') Is Not Null Drop Table #PreDestination
	
	-- let's create temp table with structure matching destination
	-- if you use "CREATE TABLE" for this, 
	-- then hardcoding fields may cause mistakes on inserting data later..
	select top 0 * into #PreDestination from dbo.Destination
	
	Insert #PreDestination
		(ID, valueA, valueB, valueC)
	Select Distinct 
		@MarketID, field1, field2, field3
	From dbo.Source (NOLOCK)
	
	-- check if data been inserted
	If ((Select COUNT(*) From #PreDestination) > 0)
	Begin
		-- delete old data
		Delete From dbo.Destination Where ID = @MarketID
		
		Insert dbo.Destination
		Select * from #PreDestination (NOLOCK)
	End
	
	
	-- we may also raise error if something wrong
	-- but now we don't have to do urgent fix, because we have old data, and customers are happy
	
	-- Drop temp tables
	If Object_ID('tempdb..#PreDestination') Is Not Null Drop Table #PreDestination
	
End