use ipl;
select * from ipl_bidder_details;
select * from ipl_bidder_points;
select * from ipl_bidding_details;
select * from ipl_match;
select * from ipl_match_schedule;
select * from ipl_player;
select * from ipl_stadium;
select * from ipl_team;
select * from ipl_team_players;
select * from ipl_team_standings;
select * from ipl_tournament;
select * from ipl_user;

#1.	Show the percentage of wins of each bidder in the order of highest to lowest percentage.
SELECT IPL_BIDDER_DETAILS.BIDDER_ID,BIDDER_NAME,NO_OF_BIDS,COUNT(*)/NO_OF_BIDS*100 AS PERCENTAGE
FROM IPL_BIDDER_DETAILS 
LEFT JOIN IPL_BIDDING_DETAILS ON IPL_BIDDER_DETAILS.BIDDER_ID=IPL_BIDDING_DETAILS.BIDDER_ID 
LEFT JOIN IPL_BIDDER_POINTS ON IPL_BIDDING_DETAILS.BIDDER_ID=IPL_BIDDER_POINTS.BIDDER_ID
WHERE BID_STATUS='WON' 
GROUP BY IPL_BIDDER_DETAILS.BIDDER_ID,BIDDER_NAME,NO_OF_BIDS
ORDER BY PERCENTAGE DESC;
#2.	Display the number of matches conducted at each stadium with stadium name, city from the database.
select count(s2.match_id),s1.stadium_id,s1.stadium_name,s1.city from ipl_stadium s1
join ipl_match_schedule s2
on s1.stadium_id=s2.stadium_id
group by city;

#3.	In a given stadium, what is the percentage of wins by a team which has won the toss?
select ist.stadium_name,sum(toss_winner=match_winner)/count(*)*100 as percentage from  ipl_stadium ist
join ipl_match_schedule ms
on ist.stadium_id = ms.stadium_id
JOIN IPL_MATCH IM ON MS.MATCH_ID=IM.MATCH_ID 
 GROUP BY IST.STADIUM_NAME 
 ORDER BY 1;
#4.	Show the total bids along with bid team and team name.
select count(No_of_bids), b2.bid_team,t.team_name from ipl_bidder_points b1
join ipl_bidding_details b2
on b1.bidder_id = b2.bidder_id
join ipl_team t
on t.team_id=b2.bid_team
group by bid_team,team_name;

#5.	Show the team id who won the match as per the win details.
SELECT WIN_DETAILS,MATCH_WINNER FROM IPL_MATCH
GROUP BY WIN_DETAILS;

#6.	Display total matches played, total matches won and total matches lost by team along with its team name.
SELECT T.TEAM_ID,T.TEAM_NAME,SUM(S.MATCHES_PLAYED),SUM(S.MATCHES_WON),SUM(S.MATCHES_LOST) FROM ipl_team_standings S
JOIN ipl_team T 
ON S.TEAM_ID = T.TEAM_ID
GROUP BY T.TEAM_ID;

#7.	Display the bowlers for Mumbai Indians team.
use ipl;
SELECT P.PLAYER_ID,PLAYER_NAME
FROM IPL_TEAM TEAM 
LEFT JOIN IPL_TEAM_PLAYERS TEAMP ON TEAM.TEAM_ID=TEAMP.TEAM_ID 
LEFT JOIN IPL_PLAYER P ON TEAMP.PLAYER_ID=P.PLAYER_ID
WHERE PLAYER_ROLE='BOWLER' AND TEAM_NAME='MUMBAI INDIANS';
#8.	How many all-rounders are there in each team, Display the teams with more than 4 all-rounder in descending order.

SELECT TEAM.TEAM_ID,TEAM_NAME,COUNT(*) ALL_ROUNDERS
FROM IPL_TEAM TEAM JOIN IPL_TEAM_PLAYERS TEAMP ON TEAM.TEAM_ID=TEAMP.TEAM_ID
GROUP BY TEAM_NAME,PLAYER_ROLE
HAVING PLAYER_ROLE='ALL-ROUNDER' AND ALL_ROUNDERS>4
ORDER BY ALL_ROUNDERS DESC;