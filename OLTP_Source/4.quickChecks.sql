USE WasteManagementOLTP;
GO

------------------------------------------------------
-- 1. VERIFY ROUTES HAVE EXPECTED DURATION & DISTANCE
------------------------------------------------------
SELECT 
    route_id,
    route_code,
    route_name,
    city_id,
    expected_duration_minutes,
    expected_distance_km,
    created_at
FROM route
ORDER BY route_id;

------------------------------------------------------
-- 2. VERIFY DEPOTS HAVE ADDRESS + GPS COORDINATES
------------------------------------------------------
SELECT
    depot_id,
    depot_code,
    depot_name,
    city_id,
    depot_type,
    address,
    latitude,
    longitude,
    created_at
FROM depot
ORDER BY depot_id;


------------------------------------------------------
-- 3. VERIFY DRIVERS HAVE LICENSE NUMBERS
------------------------------------------------------
SELECT
    employee_id,
    employee_number,
    full_name,
    role,
    phone,
    license_number,
    status,
    created_at
FROM employee
WHERE role = 'driver'
ORDER BY employee_id;


------------------------------------------------------
-- 4. QUICK DATA QUALITY CHECKS (SHOULD RETURN ZERO ROWS)
------------------------------------------------------
-- Routes missing duration or distance (should be empty)
SELECT * 
FROM route
WHERE expected_duration_minutes IS NULL
   OR expected_distance_km IS NULL;

-- Depots missing address or GPS (should be empty)
SELECT * 
FROM depot
WHERE address IS NULL
   OR latitude IS NULL
   OR longitude IS NULL;

-- Drivers missing license number (should be empty)
SELECT * 
FROM employee
WHERE role = 'driver'
  AND license_number IS NULL;


------------------------------------------------------
-- FINAL VERIFICATION 
------------------------------------------------------
SELECT 'city' AS table_name, COUNT(*) FROM city
UNION ALL SELECT 'zone', COUNT(*) FROM zone
UNION ALL SELECT 'depot', COUNT(*) FROM depot
UNION ALL SELECT 'waste_type', COUNT(*) FROM waste_type
UNION ALL SELECT 'employee', COUNT(*) FROM employee
UNION ALL SELECT 'truck', COUNT(*) FROM truck
UNION ALL SELECT 'route', COUNT(*) FROM route
UNION ALL SELECT 'route_stop', COUNT(*) FROM route_stop
UNION ALL SELECT 'collection_event', COUNT(*) FROM collection_event
UNION ALL SELECT 'collection_item', COUNT(*) FROM collection_item
UNION ALL SELECT 'waste_bin', COUNT(*) FROM waste_bin
UNION ALL SELECT 'citizen_feedback', COUNT(*) FROM citizen_feedback
UNION ALL SELECT 'fuel_log', COUNT(*) FROM fuel_log
UNION ALL SELECT 'incident_log', COUNT(*) FROM incident_log
UNION ALL SELECT 'truck_maintenance', COUNT(*) FROM truck_maintenance;

/*USE WasteManagementOLTP;
GO

SELECT 'Dim_Date' AS DW_Table,
       COUNT(DISTINCT collected_date) AS Estimated_Rows
FROM collection_event

UNION ALL
SELECT 'Dim_Location',
       COUNT(*) 
FROM zone

UNION ALL
SELECT 'Dim_Waste_Type',
       COUNT(*)
FROM waste_type

UNION ALL
SELECT 'Dim_Truck',
       COUNT(*)
FROM truck

UNION ALL
SELECT 'Dim_Driver',
       COUNT(*)
FROM employee
WHERE role = 'driver'

UNION ALL
SELECT 'Fact_Waste_Operations',
       COUNT(*)
FROM collection_item;

*/

