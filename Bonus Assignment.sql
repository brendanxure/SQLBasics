/*  Brendan Obilo
	100952871
	March 26th, 2024
	INFT  1105 Bonus Assignment
*/

--TAKE HOME QUESTION

--list all players from team 222,218 and 212
--Show all players from 218 first, then 222, then 212
--and within each list, sort the players by lastname then firstname.
--hint: subqueries and set operator, tackle in chunks, 6 selects statements, 3 will be subqueries

SELECT * 
FROM (
	SELECT
		1 as orderid,
		lastname,
		firstname,
		teamid
	FROM rosters r
		INNER JOIN players p ON r.playerid = p.playerid
	WHERE teamid = 218

	UNION

	SELECT
		2 as orderid,
		lastname,
		firstname,
		teamid
	FROM rosters r
		INNER JOIN players p ON r.playerid = p.playerid
	WHERE teamid = 222

	UNION

	SELECT
		3 as orderid,
		lastname,
		firstname,
		teamid
	FROM rosters r
		INNER JOIN players p ON r.playerid = p.playerid
	WHERE teamid = 212
) t
ORDER BY orderid, lastname, firstname
