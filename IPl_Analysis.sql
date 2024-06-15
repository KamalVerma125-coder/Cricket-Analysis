/*create Database*/
use kamaldb;
/*show tables*/
show tables;
/*create tables*/
create table dim_players(PId int not null primary key auto_increment,
name varchar(50),
team varchar(100),
battingStyle varchar(500),
bowlingStyle varchar(500),
playingRole varchar(500));

show tables;
/*show tables data*/
select * from dim_players;

create table fact_bating_summary(BID int primary key auto_increment,
match_id varchar(500),
matchs varchar(500),
teamInnings varchar(500),
battingPos varchar(500),
batsmanName varchar(500) references dim_players(name),
Bat_out_not_out varchar(500),
runs varchar(500),
balls varchar(500),
4s varchar(500),
6s varchar(500),
SR varchar(500));

select* from fact_bating_summary;
/* add a column*/
alter table fact_bating_summary add out_not_out varchar(500) after Bat_out_not_out;
alter table fact_bating_summary
drop column Bat_out_not_out; 


create  table fact_bowling_summary(BOID int not null primary key auto_increment,
match_id varchar(500) references fact_bating_summary(match_id),
matchs varchar(500) references fact_bating_summary(matchs),
bowlingTeam varchar(500),
bowlerName varchar(500),
overs varchar(500),
maiden varchar(500),
runs varchar(500),
wickets varchar(500),
economy varchar(500),
0s varchar(500),
4s varchar(500),
6s varchar(500),
wides varchar(500),
noBalls varchar(500));

select * from fact_bowling_summary;
 
 create table dim_match_summary(MID int not null primary key auto_increment,
 team1 varchar(500),
 team2 varchar(500),
 winner varchar(500),
 margin varchar(500),
 matchDate varchar(500),
 match_id varchar(500) references fact_bowling_summary(match_id));
 
 /* Drop Column*/
 select * from dim_match_summary;
 alter table dim_match_summary
 drop column MID;
 /* show data through order by*/
 select * from fact_bating_summary ;
 select * from fact_bating_summary order by batsmanname;
 /*Top 100 Batsman with most run in last 3 years*/
 select distinct batsmanname from fact_bating_summary;
 select batsmanname, count(matchs),sum(runs) as most_runs from fact_bating_summary group by batsmanname order by sum(runs)  desc limit 100;
/* Sum of balls played by batsman*/
select	batsmanname, sum(balls) from fact_bating_summary group by batsmanname;

select * from fact_bating_summary;

create table new_bating as select * from fact_bating_summary;
select * from new_bating;
update new_bating
set out_not_out = 1
where out_not_out = "out";
alter table new_bating modify column out_not_out int;

/*Top 100 Batsman with best Average in last 3 years minimum 60 balls played and minimum 21 match played*/
select batsmanname,Sum(runs),sum(balls),count(matchs),sum(out_not_out),sum(runs)/sum(out_not_out) as average 
from new_bating group by batsmanname having sum(balls) >= 60 and count(matchs) >= 21 order by average desc limit 100;

/*Top 10 Batsman with batting strike rate in last 3 years minimum 21 matches played*/

select * from new_bating;
/* Best batting strike rate minimum 21 match played*/
select batsmanname,count(matchs),sum(runs),sum(balls),sum(runs)/sum(balls)*100 as Strike_rate 
from new_bating group by batsmanname having sum(balls) >= 60 and count(matchs) >= 21 order by Strike_rate desc limit 100;

select * from fact_bowling_summary;

/*Top 100 Bowler with Most wicket in last 3 years minimum 21 matches played*/
select bowlername, count(matchs),sum(wickets) as Most_Wicket from fact_bowling_summary group by bowlername having count(matchs) >= 21 order by Most_Wicket desc limit 100;

/*Top 100 Bowler with Best bowling average in last 3 years minimum 21 matches played*/
select bowlername, count(matchs),sum(runs),sum(wickets),sum(overs)*6,sum(runs)/sum(wickets) as bowling_average 
from fact_bowling_summary group by bowlername having sum(overs)*6 >= 60 and count(matchs) >= 21 order by bowling_average asc limit 100;

select * from dim_match_summary;

create table new_bowling as select * from fact_bowling_summary;
create table new_match as select * from dim_match_summary;
select * from new_bowling;

alter table new_bowling
rename column match_id to matchs_id;

create table join_table(
match_id varchar(500),
matchs varchar(500),
bowlingTeam varchar(500),
bowlername varchar(500),
overs varchar(500),
maiden int,
runs int,
wickets int,
economy varchar(500),
0s int,
4s int,
6s int,
wides int,
noballs int,
matchdate varchar(500));

select * from join_table ;
update join_table
set matchdate = 2023
where matchdate like '%2023'; 

/*Top 100 Bowler with Best Economy in last 3 years minimum 21 matches played*/
select bowlername, count(matchs),sum(runs),sum(overs),sum(runs)/sum(overs) as economy 
from join_table group by bowlername having sum(overs) >= 10 and count(matchs) >=21 order by economy asc limit 100;

select sum(4s) from new_bating where batsmanname = 'ShubmanGill' ;
/*top 100 batsman with top Boundry percentage*/
select batsmanname,count(matchs),sum(balls),sum(runs),sum(4s),sum(6s),(sum(4s)*4 + Sum(6s)*6)/sum(runs)*100 as boundary_per
from new_bating group by batsmanname   having count(matchs) >= 21 and sum(balls) >= 300 order by boundary_per desc limit 100;
select * from new_bating;

/*top 100 best dot bowling percentage minimum 21 match played*/
select  bowlername,count(matchs),sum(0s),sum(overs),sum(0s)/Sum((overs)*6)*100 as dot_per
from new_bowling group by bowlername having count(matchs) >= 21 order by dot_per desc limit 100;

select * from dim_match_summary;

select team2, count(team1)+count(team2) from dim_match_summary  group by team2 order by team2 ;
select winner,count(winner) from dim_match_summary group by winner order by winner;


select count(winner), winner from dim_match_summary group by winner;

create table team1(Host_team varchar(500), winner varchar(500), margin varchar(500));
select * from team1;
create table team2(Chal_team varchar(500), winner varchar(500), margin varchar(500));
select * from team2;

/* winning with wicket margin*/
select Winner, count(margin) from dim_match_summary where margin like '%wickets' group by winner ;

select * from fact_bating_summary;
select batsmanname,battingpos, count(battingpos),sum(runs) from fact_bating_summary group by batsmanname;
select batsmanname,battingpos, count(battingpos) from fact_bating_summary group by battingpos;