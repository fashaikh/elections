/****** Script for SelectTopNRows command from SSMS  ******/
SELECT * from [dbo].[Precinct] where precinctid =1279
--where PrecinctName like 'Mclane%'

select * from [dbo].[VoteOption]
--where Race like 'Initiative Measure No. 1464 concerns campaign finance laws and lobbyists.%'



--truncate table [dbo].[Precinct]
--truncate table [dbo].[Result]
select count(1) from   [dbo].[Result] with (nolock)

select * from [dbo].[County]
