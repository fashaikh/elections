



SET NOCOUNT ON;  
  
DECLARE @voteOptionId int
Declare @votes int
declare @race varchar(200)
declare @candidate varchar(200)
declare @message varchar (1000)
---declare @precinctid int =4626	17
PRINT '-------- GetttingVoteOption Id--------';  
  
DECLARE KICVotes CURSOR FOR   
select Race, Candidate,Votes  from 
[dbo].[Destination - 20161108_AllStatePrecincts3]
where countycode ='KI'

  
OPEN KICVotes  
  
FETCH NEXT FROM KICVotes   
INTO @race, @candidate  , @votes
  
WHILE @@FETCH_STATUS = 0  
BEGIN  
    PRINT ' '  
    SELECT @message = 'Race candidates and votes: ' +   
        @race + @candidate   ;
		 
		
		SELECT  @voteOptionId  =-1;
		SELECT  @voteOptionId =[VoteOptionId] from [dbo].[VoteOption]
		where [ElectionCycle] ='20161108'
			and [Race] = @race
			and [Candidate] = @candidate

			IF @voteOptionId!=-1
		begin		PRINT '';

		end
		else
		begin
		print '#############################################################################' 
		PRINT @message;
		insert into [dbo].[VoteOption]([ElectionCycle],[Race],[Candidate],[Jurisdiction],[Party])
		VALUES('20161108',@race, @candidate,'','')
		SELECT @voteOptionId =@@IDENTITY;
		end

		INSERT INTO 	[dbo].[Result]([PrecinctId],[VoteOptionId],[Count],[Created],[ResultsUntil],[ResultType])
		VALUES (4626,@voteOptionId,@votes,getdate(),'2016-11-29 00:00:00.0000000','FINAL')
		FETCH NEXT FROM KICVotes   
INTO @race, @candidate  , @votes
 
END
CLOSE KICVotes;  
DEALLOCATE KICVotes; 

--select top 10 * from [dbo].[Result]