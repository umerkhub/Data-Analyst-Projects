-- CREATE DATABASE
CREATE DATABASE flight_analysis;
USE flight_analysis;

-- LOAD DATA 
DROP TABLE IF EXISTS flight_data_2024;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/flight_data_2024.csv'
INTO TABLE flight_data_2024
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@year,@month,@day_of_month,@day_of_week,@fl_date,@origin,@origin_city_name,@origin_state_nm,@dep_time,@taxi_out,@wheels_off,@wheels_on,@taxi_in,@cancelled,@air_time,@distance,@weather_delay,@late_aircraft_delay)
SET 
year = NULLIF(@year,''),
month = NULLIF(@month,''),
day_of_month = NULLIF(@day_of_month,''),
day_of_week = NULLIF(@day_of_week,''),
fl_date = @fl_date,
origin = @origin,
origin_city_name = @origin_city_name,
origin_state_nm = @origin_state_nm,
dep_time = NULLIF(@dep_time,''),
taxi_out = NULLIF(@taxi_out,''),
wheels_off = NULLIF(@wheels_off,''),
wheels_on = NULLIF(@wheels_on,''),
taxi_in = NULLIF(@taxi_in,''),
cancelled = NULLIF(@cancelled,''),
air_time = NULLIF(@air_time,''),
distance = NULLIF(@distance,''),
weather_delay = NULLIF(@weather_delay,''),
late_aircraft_delay = NULLIF(@late_aircraft_delay,'');

-- CREATE A NEW TABLE
DROP TABLE IF EXISTS flight_clean;

CREATE TABLE flight_clean AS
SELECT 
    year,
    month,
    STR_TO_DATE(fl_date, '%c/%e/%Y') AS flight_date,
    origin,
    origin_city_name,
    origin_state_nm,
    dep_time,
    taxi_out,
    taxi_in,
    air_time,
    distance,
    weather_delay,
    late_aircraft_delay,
    cancelled
FROM flight_data_2024;

-- DATA VALIDATION

SELECT COUNT(*) FROM flight_clean;

SELECT MIN(flight_date), MAX(flight_date) FROM flight_clean;

SELECT COUNT(*) 
FROM flight_clean
WHERE flight_date IS NULL;

-- FEATURE ENGINEERING
SET SQL_SAFE_UPDATES = 0;

-- Convert dep_time into proper hour
ALTER TABLE flight_clean ADD COLUMN departure_hour INT;

UPDATE flight_clean
SET departure_hour = FLOOR(dep_time / 100);

-- Total Delay
ALTER TABLE flight_clean ADD COLUMN total_delay INT;

UPDATE flight_clean
SET total_delay = IFNULL(weather_delay,0) + IFNULL(late_aircraft_delay,0);

-- Delay Category

ALTER TABLE flight_clean ADD COLUMN delay_status VARCHAR(20);

UPDATE flight_clean
SET delay_status =
CASE
    WHEN total_delay = 0 THEN 'On Time'
    WHEN total_delay <= 30 THEN 'Minor Delay'
    WHEN total_delay <= 90 THEN 'Moderate Delay'
    ELSE 'Severe Delay'
END;

-- OVERVIEW

SELECT COUNT(*) AS total_flights 
FROM flight_clean;

SELECT 
    MIN(flight_date) AS start_date,
    MAX(flight_date) AS end_date
FROM flight_clean;

-- TRAFFIC ANALYSIS
-- Flights per Day

SELECT 
    flight_date,
    COUNT(*) AS total_flights
FROM flight_clean
GROUP BY flight_date
ORDER BY flight_date;

-- Flights by Month

SELECT 
    month,
    COUNT(*) AS total_flights
FROM flight_clean
GROUP BY month
ORDER BY month;

-- AIRPORT ANALYSIS

SELECT 
    origin,
    COUNT(*) AS total_flights
FROM flight_clean
GROUP BY origin
ORDER BY total_flights DESC
LIMIT 10;

-- Top Cities

SELECT 
    origin_city_name,
    COUNT(*) AS total_flights
FROM flight_clean
GROUP BY origin_city_name
ORDER BY total_flights DESC
LIMIT 10;

-- DELAY/TIME ANALYSIS
-- Avg Taxi Out Time

SELECT 
	AVG(taxi_out) AS avg_taxi_out_time
FROM flight_clean;

-- Taxi Time by Airport

SELECT
	origin,
    AVG(taxi_out) AS avg_taxi_out
FROM flight_clean
GROUP BY origin
ORDER BY avg_taxi_out DESC
LIMIT 10;

-- Peak Departure Hours

SELECT 
    FLOOR(dep_time / 100) AS hour,
    COUNT(*) AS flights
FROM flight_clean
GROUP BY hour
ORDER BY flights DESC;

-- Flights by Day of Week

SELECT 
    day_of_week,
    COUNT(*) AS total_flights
FROM flight_clean
GROUP BY day_of_week
ORDER BY total_flights DESC;

-- Busiest Day

SELECT 
    flight_date,
    COUNT(*) AS flights
FROM flight_clean
GROUP BY flight_date
ORDER BY flights DESC
LIMIT 1;

-- Least Busy Day

SELECT 
    flight_date,
    COUNT(*) AS flights
FROM flight_clean
GROUP BY flight_date
ORDER BY flights ASC
LIMIT 1;

-- On Time %

SELECT 
ROUND(100 * SUM(CASE WHEN total_delay = 0 THEN 1 ELSE 0 END) / COUNT(*),2)
AS on_time_pct
FROM flight_clean;

-- Cancellation rate

SELECT 
ROUND(100 * SUM(cancelled) / COUNT(*),2) AS cancellation_rate
FROM flight_clean;

-- Delay by Hour

SELECT 
    departure_hour,
    AVG(total_delay) AS avg_delay
FROM flight_clean
GROUP BY departure_hour
ORDER BY avg_delay DESC;

-- Worst Airports

SELECT 
    origin,
    AVG(total_delay) AS avg_delay
FROM flight_clean
GROUP BY origin
ORDER BY avg_delay DESC
LIMIT 10;

/*
- Which airports are overloaded?
- Airports like ATL and ORD handle the highest flight volumes, making them major traffic hubs. High volume increases the risk of congestion-related delays, especially during 
  peak hours. This suggests operational strain, which may impact on-time performance. Improving scheduling efficiency or increasing ground resources at these airports could help 
  reduce delays.

- When are peak congestion hours?
- 6 am, 8 am, 10 amFlight volume peaks between 6–10 AM, indicating high morning demand. This is likely driven by business travel schedules and early-day departures. 
  The concentration of flights in this window increases congestion, which can lead to delays and longer taxi times. Airlines and airports could reduce congestion by redistributing 
  some departures to off-peak hours.

- Are weekends busier?
- Flight activity is higher on weekdays compared to weekends, likely due to business travel demand. Increased weekday traffic can lead to higher congestion and operational pressure,
  raising the likelihood of delays. Airlines may need to allocate more resources during weekdays to maintain performance levels.

- Which locations have high taxi times (inefficiency)?
- Certain airports such as BGM show significantly higher average taxi-out times compared to others. This indicates potential inefficiencies in ground operations, such as runway
   congestion or poor traffic management. Prolonged taxi times contribute directly to departure delays and increased fuel costs. Optimizing ground movement and improving 
   coordination could reduce these inefficiencies.

- How do flight delays trend throughout the day, and what does this suggest about the current recovery strategies used by airlines?
- Average delays are higher during evening hours, suggesting cumulative delays throughout the day. As flights get delayed earlier, the impact propagates, leading to worse 
  performance later. This indicates poor delay recovery mechanisms. Airlines could improve turnaround efficiency to prevent delay accumulation.

/*