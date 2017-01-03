


select distinct ["CountyCode"] from [dbo].[20161108_AllStatePrecincts]
where ["CountyCode"] ='KI'

--truncate table [dbo].[Destination - 20161108_AllStatePrecincts3]
--drop table  [dbo].[20161108_AllStatePrecincts]
select *  from 
[dbo].[Destination - 20161108_AllStatePrecincts3]
where countycode ='KI'
and not (PrecinctName ='Total')

insert into dbo.Precinct (CountyId,PrecinctCode, PrecinctName, Created)
select [CountyId], 9999, [CountyName] +' - Missing',getdate() from [dbo].[County]


select * from [dbo].[Precinct]order by Precinctid desc

where PrecinctCode=100


select c.[CountyName],vo.[Race],vo.[Candidate], SUM(r.Count) 
from [dbo].[Result] r
inner join [dbo].[VoteOption] vo on r.[VoteOptionId] =vo.[VoteOptionId]
INNER JOIN [dbo].[Precinct] pr on pr.PrecinctId= r.PrecinctId
INNER JOIN [dbo].[County] c on c.CountyId = pr.CountyId
group by c.[CountyName],vo.[Race],vo.[Candidate]
order by c.[CountyName],vo.[Race],vo.[Candidate]

select c.County, c.Race,c.[Candidate],c.Votes from [dbo].[RawCounty] as c
order by c.[County],c.[Race],c.[Candidate]

select top 10 * from [dbo].[VoteOption]
where [Race] like '%Senat%'

select c.[CountyName],pr.PrecinctCode, pr.PrecinctName, vo.[Race],vo.[Candidate],r.Count 
from [dbo].[Result] r
inner join [dbo].[VoteOption] vo on r.[VoteOptionId] =vo.[VoteOptionId]  --and vo.race= 'Legislative District 1 State Senator'
INNER JOIN [dbo].[Precinct] pr on pr.PrecinctId= r.PrecinctId
INNER JOIN [dbo].[County] c on c.CountyId = pr.CountyId and c.cOuntyId =36
order by c.[CountyName],pr.PrecinctCode, vo.[Candidate]

select c.COuntyName, vo.[Race],vo.[Candidate],SUM(r.Count) 
from [dbo].[Result] r
inner join [dbo].[VoteOption] vo on r.[VoteOptionId] =vo.[VoteOptionId] and UPPER(vo.race) like '%ROSALIA%'
INNER JOIN [dbo].[Precinct] pr on pr.PrecinctId= r.PrecinctId 
INNER JOIN [dbo].[County] c on c.CountyId = pr.CountyId --and c.cOuntyId =36
group by c.COuntyName,vo.[Race],vo.[Candidate]
order by vo.[Race]


select * from [dbo].[RawCounty] as rc
where ltrim(rtrim(rc.Race)) Not IN (select distinct ltrim(rtrim([Race])) from [dbo].[VoteOption])

select * from [dbo].[VoteOption] as rc
where ltrim(rtrim(rc.Race)) Not IN (select distinct ltrim(rtrim([Race])) from [dbo].[RawCounty])

select vo.[Race], vo.[Candidate], vo.Jurisdiction,vo.party
from dbo.VOteOption vo INNER JOIN  [dbo].[RawCounty]c  on vo.Race = c.Race and vo.Candidate =c.Candidate
and vo.ElectionCycle ='20161108'

update dbo.VOteOption
set party =REPLACE (party,'Socialism &amp; Liberation Party Nominees','Socialism & Liberation Party Nominees')

update  vo set 
 vo.Jurisdiction  = c.Jurisdiction,
 vo.Party= ISNULL(c.party,'N/A')
from dbo.VOteOption vo INNER JOIN  [dbo].[RawCounty]c  on vo.Race = c.Race and vo.Candidate =c.Candidate
and vo.ElectionCycle ='20161108'


select * from [dbo].[County]

select * from [dbo].[VoteOption]
where UPPER(Race) like '%WAITSBURG%'
select * from [dbo].[RawCounty]
where UPPER(Race) like '%WAITSBURG%'

'SD 179 NINE MILE FALLS Nine Mile Falls School District Proposition No. 1 Bonds to Construct a New Lakeside High School'
'NINE MILE FALLS SD 325 Nine Mile Falls School District Proposition No. 1 Bonds to Construct a New Lakeside High School'


update dbo.[RawCounty]
set Race=  REPLACE (Race,'SOUND TRANSIT Proposition No. 1 Light-Rail, Commuter-Rail, and Bus Service Expansion','Regional Transportation Authority Proposition No. 1 Light-Rail, Commuter-Rail, and Bus Service Expansion')


update dbo.[RawCounty]
set Race=  REPLACE (Race,'Waitsburg School District No. 401-100 Proposition 1 Bonds to Improve and Upgrade Waitsburg School Facilities','WAITSBURG SCHOOL DISTRICT 401-100 Proposition 1 Bonds to Improve and Upgrade Waitsburg School Facilities')



select * from

Select * from precinct where COuntyid =36
Select * from county

update [dbo].[VoteOption]
set Race ='City of Everett Proposition No. 3 Adding a new section to the City of Everett Charter, Section 15.10 (Diversity – boards, commissions and committees)'
where VoteOptionId in (71,72)

update dbo.[VoteOption]
--set Race=  REPLACE (Race,'Prescott Joint Park and Recreation District Proposition No. 1 Maintenance &amp; Operation Excess Levy','Prescott Joint Park and Recreation District Proposition No. 1 Maintenance & Operation Excess Levy')
set Race=  REPLACE (Race,'PRESCOTT JOINT PARK AND REC DIST Proposition No. 1 Maintenance &amp; Operation Excess Levy','Prescott Joint Park and Recreation District Proposition No. 1 Maintenance & Operation Excess Levy')
update dbo.[RawCounty]
set Race=  REPLACE (Race,'Prescott Joint Park and Recreation District Proposition No. 1 Maintenance &amp; Operation Excess Levy','Prescott Joint Park and Recreation District Proposition No. 1 Maintenance & Operation Excess Levy')
set Race=  REPLACE (Race,'PRESCOTT JOINT PARK AND REC DIST Proposition No. 1 Maintenance &amp; Operation Excess Levy','Prescott Joint Park and Recreation District Proposition No. 1 Maintenance & Operation Excess Levy')

update dbo.[RawCounty]
--set Race=  REPLACE (Race,'PUD NO 1 Commissioner District 3','Public Utilities District No. 1 Commissioner District 3')
set Race=  REPLACE (Race,'PUBLIC UTILITIES DISTRICT NO 1 Commissioner District 3','Public Utilities District No. 1 Commissioner District 3')

update dbo.VoteOption
set Race=  REPLACE (Race,'PUD NO 1 Commissioner District 3','Public Utilities District No. 1 Commissioner District 3')
set Race=  REPLACE (Race,'PUBLIC UTILITIES DISTRICT NO 1 Commissioner District 3','Public Utilities District No. 1 Commissioner District 3')

update dbo.[RawCounty]
--set Race=  REPLACE (Race,'PUBLIC UTILITY DISTRICT - 001 Commissioner #1','Public Utilities District No. 1 Commissioner #1')
set Race=  REPLACE (Race,'PUD 01 Commissioner #1','Public Utilities District No. 1 Commissioner #1')

update dbo.VoteOption
--set Race=  REPLACE (Race,'PUBLIC UTILITY DISTRICT - 001 Commissioner #1','Public Utilities District No. 1 Commissioner #1')
set Race=  REPLACE (Race,'PUD 01 Commissioner #1','Public Utilities District No. 1 Commissioner #1')

update dbo.[RawCounty]
set Race=  REPLACE (Race,'ROSALIA PARK DISTRICT - 5 Rosalia Park and Recreation District #5 Proposition No.1','Rosalia Park and Recreation District #5 Proposition No.1')

update dbo.VoteOption
--set Race=  REPLACE (Race,'PUBLIC UTILITY DISTRICT - 001 Commissioner #1','Public Utilities District No. 1 Commissioner #1')
set Race=  REPLACE (Race,'PUD 01 Commissioner #1','Public Utilities District No. 1 Commissioner #1')

select * from rawCounty
where Upper(Race) like '%ROSALIA%'
select * from VoteOption
where Upper(Race) like '%ROSALIA%'
'PUBLIC UTILITY DISTRICT - 001 Commissioner #1'
'PUD 01 Commissioner #1'

'PRESCOTT JOINT PARK AND REC DIST Proposition No. 1 Maintenance &amp; Operation Excess Levy'
'Prescott Joint Park and Recreation District Proposition No. 1 Maintenance &amp; Operation Excess Levy'
'FERRY PUD ALL PUBLIC UTILITY COMMISSIONER #1'
'PUD (COUNTYWIDE) PUBLIC UTILITY COMMISSIONER #1'

'Court of Appeals, Division 1, District 1 - Judge PRESCOTT JOINT PARK AND REC DIST Proposition No. 1 Maintenance &amp; Operation Excess Levy 1'
'Court of Appeals, Division 1, District 1 Judge Position 1'

'City of Everett Proposition No. 3 Adding a new section to the City of Everett Charter, Section 15.10 (Diversity – boards, commissions and committees)'
'City of Everett Proposition No. 3 Adding a new section to the City of Everett Charter, Section 15.10 (Diversity � boards, commissions and committees)'
'Proposed Amendments to the Constitution - Senate Joint Resolution No. 8210 concerns the deadline for completing state legislative and congressional redistricting.'
'Proposed Constitutional Amendments Senate Joint Resolution No. 8210 concerns the deadline for completing state legislative and congressional redistricting.'
UPDATE [dbo].RawCounty
set RACE = REPLACE (Race,N'�','-')
UPDATE [dbo].VoteOption
set RACE = REPLACE (Race,N'�','-')

update [Destination - 20161108_AllStatePrecincts3]
set RACE = REPLACE (Race,'�','-')
update [dbo].[VoteOption]
set RACE = REPLACE (Race,'�','-')

set RACE = REPLACE (Race,'Proposed Amendments to the Constitution - ','Proposed Constitutional Amendments ')

set RACE = REPLACE (Race,'Proposed Amendments to the Constitution - ','Proposed Constitutional Amendments ')
update [dbo].[VoteOption]
set RACE = REPLACE (Race,'Proposed Amendments to the Constitution - ','Proposed Constitutional Amendments ')


set Race = REPLACE(Race,'Court - Justice Position ','Court Justice Position')

UPDATE [dbo].[Destination - 20161108_AllStatePrecincts3]
set Race = REPLACE(Race,'Court - Justice Position ','Court Justice Position')
set Race = REPLACE(Race,'Washington State ','')
 

set Race = REPLACE(Race,'United States ','')
set Race = REPLACE(Race,' Court - Judge Position',' Court Judge Position')
set Race = REPLACE(Race,' Court -Judge Position',' Court Judge Position')
set Race = REPLACE(Race,' Court  Judge Position',' Court Judge Position')

set Race = REPLACE(Race,' - State Senator',' State Senator')
set Race = REPLACE(Race,' - State Represent',' State Represent')
set Race = REPLACE(Race,' Court  Judge Position',' Court Judge Position')
set Race = REPLACE(Race,' - U.S. Representative',' U.S. Representative')

Update [dbo].[VOteOption]
set Race = REPLACE(Race,'Court - Justice Position ','Court Justice Position')

set Race = REPLACE(Race,' - U.S. Representative',' U.S. Representative')

set Race = REPLACE(Race,' - State Represent',' State Represent')

set Race = REPLACE(Race,' - State Senator',' State Senator')

set Race = REPLACE(Race,' Court  Judge Position',' Court Judge Position')

set Race = REPLACE(Race,' Court -Judge Position',' Court Judge Position')

Update [dbo].[VOteOption]
set Race = REPLACE(Race,N' Court  - Judge Position',' Court Judge Position')

Adams Superior Court  - Judge Position 1
set Race = REPLACE(Race,'Supreme Court Justice Position','Supreme Court - Justice Position')

set Race = REPLACE(Race,'Superior Court Judge Position','Superior Court - Judge Position')

set Race = REPLACE(Race,'Supreme Court - Justice Position','Supreme Court Justice Position')

set Race = REPLACE(Race,'United States ','')

set Race = REPLACE(Race,'United States President/Vice President','President/Vice President')

set Race = REPLACE(Race,'Washington State ','')

--Adams Superior Court  Judge Position 1
--Advisory Votes Advisory Vote No. 14 House Bill 2768
--Advisory Votes Advisory Vote No. 15 Second Engrossed Substitute House Bill 2778
--Asotin, Columbia, Garfield Superior Court Judge Position 1
--Benton, Franklin Superior Court Judge Position 1
--Chelan Superior Court Judge Position 1
--City Of Bellevue Proposition No. 1, Levy for Fire Facilities
--City Of Duvall Advisory Vote No. 1, Sale, Possession, and Discharge of Consumer Fireworks Within the City of Duvall
