USE WasteManagementOLTP;
------------------------------------------------------
-- GEOGRAPHIC TABLES
------------------------------------------------------
SELECT * FROM city;
SELECT * FROM zone;
SELECT * FROM depot;

------------------------------------------------------
-- MASTER DATA
------------------------------------------------------
SELECT * FROM waste_type;
SELECT * FROM employee;
SELECT * FROM truck;

------------------------------------------------------
-- ROUTES
------------------------------------------------------
SELECT * FROM route;
SELECT * FROM route_stop;

------------------------------------------------------
-- CORE OPERATIONAL TABLES
------------------------------------------------------
SELECT * FROM collection_event;
SELECT * FROM collection_item;

------------------------------------------------------
-- SUPPORT / LOG TABLES
------------------------------------------------------
SELECT * FROM waste_bin;
SELECT * FROM fuel_log;
SELECT * FROM truck_maintenance;
SELECT * FROM incident_log;
SELECT * FROM citizen_feedback;
