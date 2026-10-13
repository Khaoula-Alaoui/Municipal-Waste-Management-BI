USE WasteManagementOLTP;
GO

------------------------------------------------------
-- DISABLE CONSTRAINTS (SAFETY)
------------------------------------------------------
ALTER TABLE collection_item NOCHECK CONSTRAINT ALL;
ALTER TABLE collection_event NOCHECK CONSTRAINT ALL;
ALTER TABLE route_stop NOCHECK CONSTRAINT ALL;
ALTER TABLE truck_maintenance NOCHECK CONSTRAINT ALL;
ALTER TABLE fuel_log NOCHECK CONSTRAINT ALL;
ALTER TABLE incident_log NOCHECK CONSTRAINT ALL;
ALTER TABLE citizen_feedback NOCHECK CONSTRAINT ALL;
ALTER TABLE waste_bin NOCHECK CONSTRAINT ALL;
ALTER TABLE route NOCHECK CONSTRAINT ALL;
ALTER TABLE depot NOCHECK CONSTRAINT ALL;
ALTER TABLE zone NOCHECK CONSTRAINT ALL;

------------------------------------------------------
-- DELETE DATA IN SAFE ORDER (CHILD → PARENT)
------------------------------------------------------
DELETE FROM collection_item;
DELETE FROM incident_log;
DELETE FROM citizen_feedback;
DELETE FROM fuel_log;
DELETE FROM truck_maintenance;
DELETE FROM waste_bin;
DELETE FROM collection_event;
DELETE FROM route_stop;
DELETE FROM route;
DELETE FROM depot;
DELETE FROM zone;
DELETE FROM truck;
DELETE FROM employee;
DELETE FROM waste_type;
DELETE FROM city;

------------------------------------------------------
-- RESET IDENTITY VALUES
------------------------------------------------------
DBCC CHECKIDENT ('collection_item', RESEED, 0);
DBCC CHECKIDENT ('incident_log', RESEED, 0);
DBCC CHECKIDENT ('citizen_feedback', RESEED, 0);
DBCC CHECKIDENT ('fuel_log', RESEED, 0);
DBCC CHECKIDENT ('truck_maintenance', RESEED, 0);
DBCC CHECKIDENT ('waste_bin', RESEED, 0);
DBCC CHECKIDENT ('collection_event', RESEED, 0);
DBCC CHECKIDENT ('route_stop', RESEED, 0);
DBCC CHECKIDENT ('route', RESEED, 0);
DBCC CHECKIDENT ('depot', RESEED, 0);
DBCC CHECKIDENT ('zone', RESEED, 0);
DBCC CHECKIDENT ('truck', RESEED, 0);
DBCC CHECKIDENT ('employee', RESEED, 0);
DBCC CHECKIDENT ('waste_type', RESEED, 0);
DBCC CHECKIDENT ('city', RESEED, 0);

------------------------------------------------------
-- RE-ENABLE CONSTRAINTS
------------------------------------------------------
ALTER TABLE zone CHECK CONSTRAINT ALL;
ALTER TABLE depot CHECK CONSTRAINT ALL;
ALTER TABLE route CHECK CONSTRAINT ALL;
ALTER TABLE route_stop CHECK CONSTRAINT ALL;
ALTER TABLE collection_event CHECK CONSTRAINT ALL;
ALTER TABLE collection_item CHECK CONSTRAINT ALL;
ALTER TABLE waste_bin CHECK CONSTRAINT ALL;
ALTER TABLE truck_maintenance CHECK CONSTRAINT ALL;
ALTER TABLE fuel_log CHECK CONSTRAINT ALL;
ALTER TABLE incident_log CHECK CONSTRAINT ALL;
ALTER TABLE citizen_feedback CHECK CONSTRAINT ALL;

------------------------------------------------------
-- 1. CITIES
------------------------------------------------------
INSERT INTO city (city_name, region)
VALUES 
 ('Casablanca', 'Casablanca-Settat'),
 ('Rabat', 'Rabat-Salé-Kénitra'),
 ('Marrakech', 'Marrakech-Safi'),
 ('Fes', 'Fès-Meknès'),
 ('Tangier', 'Tanger-Tétouan-Al Hoceïma'),
 ('Agadir', 'Souss-Massa'),
 ('Oujda', 'Oriental'),
 ('Kenitra', 'Rabat-Salé-Kénitra'),
 ('Tetouan', 'Tanger-Tétouan-Al Hoceïma'),
 ('Safi', 'Marrakech-Safi'),
 ('Beni Mellal', 'Beni Mellal-Khenifra'),
 ('Laayoune', 'Laâyoune-Sakia El Hamra');

------------------------------------------------------
-- 2. ZONES (REALISTIC – MOROCCAN NEIGHBORHOODS)
------------------------------------------------------
INSERT INTO zone (city_id, zone_code, zone_name, area_km2)
VALUES
-- =========================
-- CASABLANCA (1)
-- =========================
(1, 'CSB-01', 'Hay Hassani', 12.5),
(1, 'CSB-02', 'Maarif', 8.2),
(1, 'CSB-03', 'Sidi Bernoussi', 15.7),
(1, 'CSB-04', 'Ain Sebaa', 14.1),
(1, 'CSB-05', 'Bourgogne', 6.8),
(1, 'CSB-06', 'Roches Noires', 7.4),
(1, 'CSB-07', 'Anfa Place', 5.9),
(1, 'CSB-08', 'Oulfa', 11.2),

-- =========================
-- RABAT (2)
-- =========================
(2, 'RBT-01', 'Agdal', 5.5),
(2, 'RBT-02', 'Yacoub El Mansour', 9.8),
(2, 'RBT-03', 'Hassan', 4.6),
(2, 'RBT-04', 'Souissi', 13.3),
(2, 'RBT-05', 'Hay Riad', 10.1),
(2, 'RBT-06', 'Akkari', 6.4),

-- =========================
-- MARRAKECH (3)
-- =========================
(3, 'MRK-01', 'Gueliz', 6.3),
(3, 'MRK-02', 'Medina', 4.1),
(3, 'MRK-03', 'Sidi Youssef Ben Ali', 9.2),
(3, 'MRK-04', 'Menara', 14.8),
(3, 'MRK-05', 'Daoudiate', 7.5),

-- =========================
-- FES (4)
-- =========================
(4, 'FES-01', 'Narjiss', 7.2),
(4, 'FES-02', 'Zouagha', 10.4),
(4, 'FES-03', 'Saiss', 12.6),
(4, 'FES-04', 'Ben Souda', 8.9),
(4, 'FES-05', 'Ville Nouvelle', 6.7),

-- =========================
-- TANGIER (5)
-- =========================
(5, 'TNG-01', 'Iberia', 6.0),
(5, 'TNG-02', 'Malabata', 11.0),
(5, 'TNG-03', 'Marshan', 5.4),
(5, 'TNG-04', 'Boukhalef', 13.9),
(5, 'TNG-05', 'Achakar', 9.6),

-- =========================
-- AGADIR (6)
-- =========================
(6, 'AGD-01', 'Talborjt', 4.9),
(6, 'AGD-02', 'Dakhla', 11.7),
(6, 'AGD-03', 'Anza', 13.1),

-- =========================
-- OUJDA (7)
-- =========================
(7, 'OUJ-01', 'Al Qods', 8.6),
(7, 'OUJ-02', 'Sidi Yahya', 7.1),
(7, 'OUJ-03', 'Lazaret', 6.8),

-- =========================
-- KENITRA (8)
-- =========================
(8, 'KEN-01', 'Maamora', 10.2),
(8, 'KEN-02', 'Bir Rami', 12.4),
(8, 'KEN-03', 'Saknia', 7.9),

-- =========================
-- TETOUAN (9)
-- =========================
(9, 'TET-01', 'Ensanche', 5.8),
(9, 'TET-02', 'Touilaa', 9.6),
(9, 'TET-03', 'Sania Rmel', 8.3),

-- =========================
-- SAFI (10)
-- =========================
(10, 'SAF-01', 'Plateau', 6.5),
(10, 'SAF-02', 'Sidi Bouzid', 11.9),
(10, 'SAF-03', 'Amouni', 7.4),

-- =========================
-- BENI MELLAL (11)
-- =========================
(11, 'BML-01', 'Hay El Qods', 8.7),
(11, 'BML-02', 'Ouled Mbarek', 12.1),
(11, 'BML-03', 'Tadla', 9.5),

-- =========================
-- LAAYOUNE (12)
-- =========================
(12, 'LAY-01', 'Maatallah', 14.2),
(12, 'LAY-02', 'Al Massira', 11.6),
(12, 'LAY-03', 'Essalam', 9.8);



------------------------------------------------------
-- 3. WASTE TYPES (FIXED)
------------------------------------------------------
INSERT INTO waste_type (code, type_name, is_recyclable, description)
VALUES
 ('ORG', 'Organic Waste', 1, 'Food, garden waste'),
 ('PLS', 'Plastic', 1, 'Plastic bottles, packaging'),
 ('GLS', 'Glass', 1, 'Glass bottles, jars'),
 ('PPR', 'Paper', 1, 'Newspapers, cartons'),
 ('MET', 'Metal', 1, 'Cans and metal objects');

------------------------------------------------------
-- 4. EMPLOYEES (SCALED)
------------------------------------------------------
INSERT INTO employee (employee_number, full_name, role, phone, license_number, hire_date)
VALUES
-- DRIVERS
('DRV001', 'Ahmed Benali', 'driver', '0612345678', 'LIC-DRV001', '2016-03-01'),
('DRV002', 'Omar El Idrissi', 'driver', '0623456789', 'LIC-DRV002', '2017-05-10'),
('DRV003', 'Youssef Moutaki', 'driver', '0634567891', 'LIC-DRV003', '2018-07-22'),
('DRV004', 'Khalid Fassi', 'driver', '0645678912', 'LIC-DRV004', '2019-11-15'),
('DRV005', 'Abdelhak Naim', 'driver', '0656789123', 'LIC-DRV005', '2020-09-05'),
('DRV006', 'Rachid Amrani', 'driver', '0611111111', 'LIC-DRV006', '2021-01-12'),
('DRV007', 'Hamza Cherkaoui', 'driver', '0622222222', 'LIC-DRV007', '2021-06-18'),
('DRV008', 'Said El Khatib', 'driver', '0633333333', 'LIC-DRV008', '2022-03-09'),
('DRV009', 'Nabil Zahiri', 'driver', '0644444444', 'LIC-DRV009', '2022-10-01'),
('DRV010', 'Anas Berrada', 'driver', '0655555555', 'LIC-DRV010', '2023-04-15'),

-- TECHNICIANS
('EMP201', 'Othman El Hadi', 'technician', '0661122334', 'LIC-TECH201', '2019-02-14'),
('EMP202', 'Yassine Ait Lahcen', 'technician', '0662233445', 'LIC-TECH202', '2020-08-21'),

-- SUPERVISORS
('EMP301', 'Samira Lahlou', 'supervisor', '0672233445', 'LIC-SUP301', '2018-01-08'),
('EMP302', 'Mohamed Skalli', 'supervisor', '0673344556', 'LIC-SUP302', '2021-09-30');

------------------------------------------------------
-- 5. TRUCKS
------------------------------------------------------
INSERT INTO truck (truck_code, plate_number, capacity_kg, fuel_type, purchase_year)
VALUES
('TRK01', '1234-A-1', 10000, 'Diesel', 2018),
('TRK02', '5678-B-2', 9500, 'Diesel', 2019),
('TRK03', '9101-C-3', 11000, 'Diesel', 2020),
('TRK04', '2233-D-4', 12000, 'Diesel', 2021),
('TRK05', '4455-E-5', 9000, 'Diesel', 2017),
('TRK06', '7788-F-6', 10500, 'Diesel', 2019),
('TRK07', '8899-G-7', 11500, 'Diesel', 2020),
('TRK08', '9900-H-8', 9800, 'Diesel', 2021),
('TRK09', '1122-I-9', 10200, 'Diesel', 2022),
('TRK10', '3344-J-0', 12000, 'Diesel', 2023);

 ------------------------------------------------------
-- 6. DEPOTS (MULTI-CITY)
------------------------------------------------------
INSERT INTO depot (depot_code, depot_name, city_id, depot_type, address, latitude, longitude)
VALUES
('DEP-CSB-1', 'Mediouna Landfill', 1, 'landfill', 'Mediouna Industrial Zone', 33.4529, -7.5044),
('DEP-CSB-2', 'Casablanca Recycling Hub', 1, 'recycling', 'Ain Sebaa', 33.6050, -7.5320),

('DEP-RBT-1', 'Oum Azza Center', 2, 'recycling', 'Oum Azza Road', 33.9692, -6.8451),

('DEP-MRK-1', 'Marrakech Landfill', 3, 'landfill', 'Route dAgadir', 31.5700, -8.0215),

('DEP-FES-1', 'Fes Landfill', 4, 'landfill', 'Route Sefrou', 34.0433, -4.9998),

('DEP-TNG-1', 'Tangier Sorting Center', 5, 'sorting', 'Malabata Zone', 35.7767, -5.7982),

('DEP-AGD-1', 'Agadir Recycling Center', 6, 'recycling', 'Anza Industrial Zone', 30.4278, -9.5981);

------------------------------------------------------
-- 7. ROUTES 
------------------------------------------------------
INSERT INTO route (route_code, route_name, city_id, expected_duration_minutes, expected_distance_km)
VALUES
-- CASABLANCA
('R-CSB-A', 'Casablanca Morning Route A', 1, 180, 42.5),
('R-CSB-B', 'Casablanca Evening Route B', 1, 160, 36.0),
('R-CSB-C', 'Casablanca Industrial Route', 1, 200, 48.2),

-- RABAT
('R-RBT-A', 'Rabat Route A', 2, 140, 29.8),
('R-RBT-B', 'Rabat Coastal Route', 2, 155, 33.1),

-- MARRAKECH
('R-MRK-A', 'Marrakech Route A', 3, 170, 38.4),
('R-MRK-B', 'Marrakech Medina Route', 3, 150, 30.6),

-- FES
('R-FES-A', 'Fes Route A', 4, 160, 34.2),

-- TANGIER
('R-TNG-A', 'Tangier Port Route', 5, 145, 31.7);


------------------------------------------------------
-- 8. ROUTE STOPS (REALISTIC)
------------------------------------------------------
INSERT INTO route_stop (route_id, zone_id, stop_order)
VALUES
-- Casablanca routes
(1, 1, 1), (1, 2, 2), (1, 3, 3), (1, 4, 4),
(2, 5, 1), (2, 6, 2), (2, 7, 3),
(3, 8, 1), (3, 1, 2), (3, 4, 3),

-- Rabat routes
(4, 9, 1), (4, 10, 2), (4, 11, 3),
(5, 12, 1), (5, 13, 2),

-- Marrakech routes
(6, 14, 1), (6, 15, 2), (6, 16, 3),
(7, 17, 1), (7, 18, 2),

-- Fes route
(8, 19, 1), (8, 20, 2),

-- Tangier route
(9, 21, 1), (9, 22, 2), (9, 23, 3);


-- CREATE NUMBERS TABLE (KEY SPEED BOOST)
IF OBJECT_ID('tempdb..#Numbers') IS NOT NULL DROP TABLE #Numbers;
CREATE TABLE #Numbers (n INT PRIMARY KEY);

;WITH cte AS (
    SELECT 1 n
    UNION ALL
    SELECT n + 1 FROM cte WHERE n < 2500000
)
INSERT INTO #Numbers
SELECT n FROM cte
OPTION (MAXRECURSION 0);


-------------------------------------------------------
-- 9. COLLECTION EVENTS (FIXED)
-------------------------------------------------------
INSERT INTO collection_event
(
 collected_date, planned_start, actual_start, actual_end,
 truck_id, driver_employee_id, route_id, depot_id,
 total_weight_kg, trip_duration_minutes, fuel_used_liters,
 odometer_start_km, odometer_end_km
)
SELECT
 DATEADD(DAY, n % 2191, '2020-01-01'),
 DATEADD(HOUR, 6, CAST(DATEADD(DAY, n % 2191,'2020-01-01') AS DATETIME)),
 DATEADD(HOUR, 7, CAST(DATEADD(DAY, n % 2191,'2020-01-01') AS DATETIME)),
 DATEADD(HOUR, 9, CAST(DATEADD(DAY, n % 2191,'2020-01-01') AS DATETIME)),
 (n % 10) + 1,
 (n % 10) + 1,
 (n % 9) + 1,
 (n % 6) + 1,
 (n % 5000) + 2000,
 (n % 180) + 60,
 (n % 50) + 10,
 100000 + (n % 100000),
 100000 + (n % 100000) + (n % 200)
FROM #Numbers;

-------------------------------------------------------
-- 10. COLLECTION ITEMS (DATE-CONSISTENT, FIXED)
-------------------------------------------------------
INSERT INTO collection_item
(
 collection_event_id, zone_id, waste_type_id,
 measured_at, weight_kg, volume_m3, item_count, is_estimated
)
SELECT
 ce.collection_event_id,
 rs.zone_id,
 (ce.collection_event_id % 5) + 1,
 DATEADD(HOUR, ce.collection_event_id % 10, CAST(ce.collected_date AS DATETIME)),
 (ce.collection_event_id % 500) + 50,
 (ce.collection_event_id % 4) + 1,
 (ce.collection_event_id % 10) + 1,
 0
FROM collection_event ce
JOIN route_stop rs ON rs.route_id = ce.route_id;

------------------------------------------------------
-- 11. WASTE BINS
------------------------------------------------------
DECLARE @b INT = 1;
WHILE @b <= 30
BEGIN
    INSERT INTO waste_bin (zone_id, bin_code, waste_type_id, capacity_liters, installation_date, condition)
    SELECT 
        (SELECT TOP 1 zone_id FROM zone ORDER BY NEWID()),
        CONCAT('BIN-', FORMAT(@b, '000')),
        (SELECT TOP 1 waste_type_id FROM waste_type ORDER BY NEWID()),
        (ABS(CHECKSUM(NEWID())) % 800) + 200,
        DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 1200), GETDATE()),
        CASE WHEN @b % 10 = 0 THEN 'damaged' ELSE 'good' END;

    SET @b += 1;
END;

------------------------------------------------------
-- 12. CITIZEN FEEDBACK
------------------------------------------------------
DECLARE @k INT = 1;
WHILE @k <= 300
BEGIN
    INSERT INTO citizen_feedback
    (zone_id, collection_event_id, submission_date, citizen_name, contact,
     issue_type, description, status, resolved_date)
    SELECT 
        (SELECT TOP 1 zone_id FROM zone ORDER BY NEWID()),
        (SELECT TOP 1 collection_event_id FROM collection_event ORDER BY NEWID()),
        DATEADD(DAY,ABS(CHECKSUM(NEWID())) % 2191,'2020-01-01'),
        CONCAT('Citizen ', @k),
        CONCAT('06', (ABS(CHECKSUM(NEWID())) % 90000000) + 10000000),
        CASE (ABS(CHECKSUM(NEWID())) % 4)
            WHEN 0 THEN 'missed_collection'
            WHEN 1 THEN 'overflow_bin'
            WHEN 2 THEN 'noise'
            ELSE 'other'
        END,
        'Auto-generated feedback record.',
        CASE WHEN @k % 5 = 0 THEN 'resolved' ELSE 'open' END,
        CASE WHEN @k % 5 = 0 THEN DATEADD(DAY, 1, GETDATE()) ELSE NULL END;

    SET @k += 1;
END;

------------------------------------------------------
-- 13. FUEL LOG
------------------------------------------------------
INSERT INTO fuel_log
(truck_id, log_date, liters, cost, odometer_km, station)
SELECT
    ((n - 1) % (SELECT COUNT(*) FROM truck)) + 1,
    DATEADD(DAY, n % 2191, '2020-01-01'),
    20 + (n % 50),
    100 + (n % 700),
    50000 + n,
    CASE n % 3
        WHEN 0 THEN 'Afriquia'
        WHEN 1 THEN 'Shell'
        ELSE 'TotalEnergies'
    END
FROM #Numbers
WHERE n <= 50000;


------------------------------------------------------
-- 14. INCIDENT LOG
------------------------------------------------------
INSERT INTO incident_log
(collection_event_id, incident_date, severity, description, resolved, resolved_date)
SELECT
    n,
    DATEADD(DAY, n % 2191, '2020-01-01'),
    CASE n % 3
        WHEN 0 THEN 'low'
        WHEN 1 THEN 'medium'
        ELSE 'high'
    END,
    'Auto-generated incident',
    CASE WHEN n % 4 = 0 THEN 1 ELSE 0 END,
    CASE WHEN n % 4 = 0 THEN GETDATE() ELSE NULL END
FROM #Numbers
WHERE n <= 20000;;

------------------------------------------------------
-- 15. TRUCK MAINTENANCE
------------------------------------------------------
INSERT INTO truck_maintenance
(truck_id, performed_by_employee_id, maintenance_date, maintenance_type, cost, notes)
SELECT
    ((n - 1) % (SELECT COUNT(*) FROM truck)) + 1,
    ((n - 1) % (SELECT COUNT(*) FROM employee WHERE role = 'technician')) + 1,
    DATEADD(DAY, n % 2191, '2020-01-01'),
    CASE n % 4
        WHEN 0 THEN 'Oil Change'
        WHEN 1 THEN 'Tire Replacement'
        WHEN 2 THEN 'Brake Inspection'
        ELSE 'Engine Repair'
    END,
    200 + (n % 3000),
    'Auto-generated maintenance'
FROM #Numbers
WHERE n <= 30000;

