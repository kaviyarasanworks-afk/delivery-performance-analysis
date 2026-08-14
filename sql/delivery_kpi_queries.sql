-- View Dataset
SELECT *
FROM delivery_data.delivery_data_table;


-- Total Row Count
SELECT COUNT(*) AS Row_Count
FROM delivery_data.delivery_data_table;


-- On-Time Delivery Rate
SELECT 
    ROUND(
        AVG(
            CASE 
                WHEN Delivery_Time <= (
                    SELECT AVG(Delivery_Time)
                    FROM delivery_data.delivery_data_table
                )
                THEN 1.0
                ELSE 0
            END
        ) * 100,
        2
    ) AS On_Time_Rate
FROM delivery_data.delivery_data_table;


-- Vehicle-wise Delivery Performance
SELECT 
    Vehicle,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(AVG(Delivery_Time), 2) AS Avg_Delivery_Time,
    ROUND(AVG(Speed_kmph), 2) AS Avg_Speed
FROM delivery_data.delivery_data_table
GROUP BY Vehicle
ORDER BY Avg_Delivery_Time;


-- Traffic-wise Delivery Performance
SELECT 
    Traffic,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(AVG(Delivery_Time), 2) AS Avg_Delivery_Time,
    ROUND(AVG(Speed_kmph), 2) AS Avg_Speed
FROM delivery_data.delivery_data_table
GROUP BY Traffic
ORDER BY Avg_Delivery_Time;


-- Distance Bucket-wise Delivery Performance
SELECT 
    Distance_Bucket,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(AVG(Speed_kmph), 2) AS Avg_Speed
FROM delivery_data.delivery_data_table
GROUP BY Distance_Bucket;