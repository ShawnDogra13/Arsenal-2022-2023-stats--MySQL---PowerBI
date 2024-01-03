CREATE DATABASE Arsenal_stats; 

USE stats; 

SELECT *
FROM stats; 

-- ------------------------------------------------- Data Cleaning --------------------------------------------------------------

ALTER TABLE stats
CHANGE COLUMN `Expectec goals` `Expected_goals` DOUBLE NULL DEFAULT NULL ; 

ALTER TABLE stats
CHANGE COLUMN `Goals for` `Goals_for` INT NULL DEFAULT NULL; 

ALTER TABLE stats
CHANGE COLUMN `Goals against` `Goals_against` INT NULL DEFAULT NULL; 

ALTER TABLE stats
CHANGE COLUMN `Shots on target` `Shots_on_target` INT NULL DEFAULT NULL;

ALTER TABLE stats
CHANGE COLUMN `Passes completed` `Passes_completed` INT NULL DEFAULT NULL; 

ALTER TABLE stats
CHANGE COLUMN `Short passes` `Short_passes` INT NULL DEFAULT NULL; 

ALTER TABLE stats
CHANGE COLUMN `Medium passes` `Medium_passes` INT NULL DEFAULT NULL; 

ALTER TABLE stats 
CHANGE COLUMN `Long passes` `Long_passes` INT NULL DEFAULT NULL; 

ALTER TABLE stats 
CHANGE COLUMN `Tackles won` `Tackles_won` INT NULL DEFAULT NULL; 

ALTER TABLE stats
CHANGE COLUMN `Penalties attempted` `Penalties_attempted` INT NULL DEFAULT NULL; 

ALTER TABLE stats 
CHANGE COLUMN `Penalties made` `Penalties_made` INT NULL DEFAULT NULL; 

-- ------------------------------------------------------- Questions ---------------------------------------------------------------

-- 1. What is the goal differential for the entire season? 
SELECT 
    goals_for, 
    goals_against, 
    goals_for - goals_against AS goal_diff
FROM (
	SELECT
		SUM(goals_for) AS goals_for, 
        SUM(goals_against) AS goals_against
        FROM stats) AS subquery; 

-- 2. What is the goal distribution across total shots taken? 

SELECT
	opponent,
    total_shots,
    total_goals, 
    ROUND(total_goals / total_shots, 2) AS goal_rate
FROM (
	SELECT
    opponent,
    SUM(shots) AS total_shots, 
    SUM(goals_for) AS total_goals
    FROM stats
	GROUP BY opponent 
	ORDER BY opponent) AS subquery; 
    
-- 3. What is the avg goal conversion rate based on shots generated? 

SELECT 
	total_shots, 
    total_goals,
    ROUND(total_goals / total_shots, 2) AS goal_conversion_rate
FROM (
	SELECT 
		SUM(shots) AS total_shots, 
        SUM(goals_for) AS total_goals
        FROM stats) AS subquery; 
    
-- 4. What is the goal differential based on opponents? -- 

SELECT 
	opponent, 
    goals,
    goals_against,
    goals - goals_against AS goal_difference
FROM ( 
	SELECT 
		opponent,
		SUM(goals_for) AS goals,
        SUM(goals_against) AS goals_against
        FROM stats
		GROUP BY opponent
		ORDER BY goals DESC) AS subquery; 

-- 5. What is the average possession across opposition?  	
SELECT 
		opponent, 
        possession
	FROM (
		SELECT 
			opponent, 
            AVG(possession) AS possession
            FROM stats
            GROUP BY opponent) AS subquery;

-- 6. What is the average posession? -- 

SELECT 
	ROUND(AVG(possession), 2) AS avg_possession
FROM stats; 

-- 7. What is the win distribution across opposition?  

SELECT 
	opponent, 
    result, 
    COUNT(*) AS result_count
FROM stats
WHERE result = 'w'
GROUP BY opponent 
ORDER BY result_count DESC; 

-- 8. What is the distrubution of losses & draws among opposition? 

SELECT 
	opponent, 
    result, 
    COUNT(*) AS result_count
FROM stats
WHERE result = 'l' OR result = 'd'
GROUP BY opponent, result
ORDER BY result DESC; 

-- 9. What is the distribution of results across venues? 
        
SELECT 
	CASE
		WHEN venue = 'away' AND result = 'w' THEN 'Away Wins'
        WHEN venue = 'away' AND result = 'l' THEN 'Away Losses'
        WHEN venue = 'away' AND result = 'd' THEN 'Away Draws'
        WHEN venue = 'home' AND result = 'w' THEN 'Home Wins'
        WHEN venue = 'home' AND result = 'l' THEN 'Home losses'
        ELSE 'Home Draws'
	END AS venue_group,  
	result,
	COUNT(*) AS result_count
FROM stats
		GROUP BY venue_group, result
		ORDER BY venue_group;
        
-- 10. What is the attendance by matchweek?  

SELECT 
	matchweek, 
    attendance 
FROM stats; 


-- 11. What is the trend between the average possession & total completed passes across opposition?   
	
    SELECT 
		opponent,
        possession, 
        passes, 
        passes_completed, 
        ROUND(passes_completed / passes, 2) AS pass_success_rate
	FROM (
		SELECT 
			opponent, 
            AVG(possession) AS possession, 
            SUM(passes) AS passes, 
            SUM(passes_completed)AS passes_completed
            FROM stats
            GROUP BY opponent
            ORDER BY passes_completed DESC) AS subquery; 

  
-- 12. What is the trend between total passes completed and shots generated? 

SELECT 
	opponent, 
    total_passes_completed, 
    total_shots, 
    ROUND(total_shots / total_passes_completed, 2) AS opportunity_rate
FROM (
	SELECT 
		opponent, 
        SUM(passes_completed) AS total_passes_completed, 
        SUM(shots) AS total_shots
        FROM stats
        GROUP BY opponent
        ORDER BY total_passes_completed DESC) AS subquery; 
    
    
    

    



