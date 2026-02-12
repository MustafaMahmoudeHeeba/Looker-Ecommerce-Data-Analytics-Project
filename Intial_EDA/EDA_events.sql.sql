SELECT TOP 50 *
FROM Bronze.unClean_events



EXEC sp_help 'Bronze.unClean_events'
-- Count total number of rows in events table
SELECT 
    COUNT(*) AS TotalRows
FROM Bronze.unClean_events;


-- Get distinct event types
SELECT 
    DISTINCT event_type
FROM Bronze.unClean_events

-- Get distinct traffic sources
SELECT 
    DISTINCT traffic_source
FROM Bronze.unClean_events;


-- Count number of distinct cities
SELECT 
    COUNT(DISTINCT city) AS TotalCities
FROM Bronze.unClean_events;


-- Get distinct sequence numbers ordered
SELECT 
    DISTINCT sequence_number  
FROM Bronze.unClean_events
ORDER BY sequence_number;


--======================================================================

-- Top 5 IP addresses with the highest number of sequence numbers
SELECT 
    TOP 5 ip_address, 
    COUNT(sequence_number) AS SequenceCount
FROM Bronze.unClean_events
GROUP BY ip_address
ORDER BY COUNT(sequence_number) DESC;


-- IP and sequence numbers with missing user_id, appearing more than once
SELECT
    COUNT(*) AS DuplicateCount, 
    ip_address, 
    sequence_number
FROM Bronze.unClean_events
WHERE user_id IS NULL
GROUP BY ip_address, sequence_number
HAVING COUNT(*) > 1
ORDER BY ip_address;


-- IP, sequence, and city combinations that appear more than once
SELECT
    COUNT(*) AS DuplicateCount, 
    ip_address, 
    sequence_number, 
    city
FROM Bronze.unClean_events
GROUP BY ip_address, sequence_number, city
HAVING COUNT(*) > 1;


-- Get all rows for IP addresses that have duplicate sequence numbers
SELECT
    *
FROM Bronze.unClean_events
WHERE ip_address IN (
    SELECT
        DISTINCT ip_address
    FROM Bronze.unClean_events
    GROUP BY ip_address, sequence_number
    HAVING COUNT(*) > 1
)
ORDER BY ip_address;


-- Aggregate sessions by session_id, ip, and location details
WITH SessionAggregates AS (
    SELECT 
        COUNT(*) AS SessionRowCount,
        session_id, 
        ip_address, 
        city, 
        postal_code, 
        traffic_source, 
        state
    FROM Bronze.unClean_events
    GROUP BY session_id, ip_address, city, postal_code, traffic_source, state 
)
-- Sum of all rows from session aggregates
SELECT 
    SUM(SessionRowCount) AS TotalSessionRows
FROM SessionAggregates;
