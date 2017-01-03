



SET NOCOUNT ON;  
  
DECLARE @voteOptionId int
Declare @votes int
Declare @missingvotes int
Declare @missingprecinctid int
Declare @prvotes int
declare @county varchar(12)
declare @race varchar(200)
declare @candidate varchar(200)
declare @message varchar (1000)
---declare @precinctid int =4626	17
PRINT '-------- GetttingVoteOption Id--------';  
  
DECLARE KICVotes CURSOR FOR   
select County, Race,Candidate, Votes
from  [dbo].[RawCounty]


  
OPEN KICVotes  
  
FETCH NEXT FROM KICVotes   
INTO @county, @race, @candidate  , @votes
  
WHILE @@FETCH_STATUS = 0  
BEGIN  
    PRINT ' '  
    SELECT @message = 'County, Race candidates and votes: ' +   
        @county+ @race + @candidate   ;
		 
		
		SELECT  @voteOptionId  =-1;
		SELECT  @voteOptionId =[VoteOptionId] from [dbo].[VoteOption]
		where [ElectionCycle] ='20161108'
			and [Race] = @race
			and [Candidate] = @candidate

		--	IF @voteOptionId!=-1
		--begin		PRINT '';

		--end
		--else
		--begin
		--print '#############################################################################' 
		--PRINT @message;
		----insert into [dbo].[VoteOption]([ElectionCycle],[Race],[Candidate],[Jurisdiction],[Party])
		----VALUES('20161108',@race, @candidate,'','')
		--SELECT @voteOptionId =@@IDENTITY;
		--end


		set @prvotes =-1;

		SELECT  @prvotes =SUM(r.Count) 
from [dbo].[Result] r
inner join [dbo].[VoteOption] vo on r.[VoteOptionId] =vo.[VoteOptionId] and vo.race = @race and vo.Candidate =@candidate
INNER JOIN [dbo].[Precinct] pr on pr.PrecinctId= r.PrecinctId
INNER JOIN [dbo].[County] c on c.CountyId = pr.CountyId
where c.countyname=@county
IF @prvotes =-1
BEGIN
 PRINT 'ERROR NO PRECINCT VOTES INVESTIGATE THIS' +@message
  PRINT @votes
 END
 ELSE IF (@prvotes >@votes)
 BEGIN
  PRINT 'ERROR PRECINCT VOTES GREATER INVESTIGATE THIS' +@message
  PRINT @prvotes
    PRINT @votes
 END
 --ELSE IF (@prvotes = @votes)
 --BEGIN
 --  PRINT 'GOOD' +@message
 --END
 ELSE IF (@prvotes < @votes)
 BEGIN
 PRINT 'Add Missing Precincts' +@message
 
   PRINT @prvotes
    PRINT @votes
 set @missingvotes = @votes - @prvotes

SELECT @missingprecinctid = pr.[PrecinctId]
from [dbo].[Precinct] pr INNER JOIN [dbo].[County] c 
on pr.[CountyId] =c.[CountyId] and c.countyName=@county and pr.[PrecinctCode] =9999
 PRINT @missingprecinctid
  PRINT @missingvotes

INSERT INTO 	[dbo].[Result]([PrecinctId],[VoteOptionId],[Count],[Created],[ResultsUntil],[ResultType])
VALUES (@missingprecinctid,@voteOptionId,@missingvotes,getdate(),'2016-11-29 00:00:00.0000000','FINAL')

 END
		--INSERT INTO 	[dbo].[Result]([PrecinctId],[VoteOptionId],[Count],[Created],[ResultsUntil],[ResultType])
		--VALUES (4626,@voteOptionId,@votes,getdate(),'2016-11-29 00:00:00.0000000','FINAL')
		FETCH NEXT FROM KICVotes   
INTO @county, @race, @candidate  , @votes
 
END
CLOSE KICVotes;  
DEALLOCATE KICVotes; 

--select top 10 * from [dbo].[Result]