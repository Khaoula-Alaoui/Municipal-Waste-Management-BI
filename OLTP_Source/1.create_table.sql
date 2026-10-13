USE master;
GO

------------------------------------------------------
-- FORCE DISCONNECT AND DROP DATABASE SAFELY
------------------------------------------------------
IF DB_ID('WasteManagementOLTP') IS NOT NULL
BEGIN
    ALTER DATABASE WasteManagementOLTP SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE WasteManagementOLTP;
END
GO

------------------------------------------------------
-- RECREATE DATABASE
------------------------------------------------------
CREATE DATABASE WasteManagementOLTP;
GO

USE WasteManagementOLTP;
GO


-- ======= DROP TABLES IN SAFE ORDER =======
IF OBJECT_ID('dbo.collection_item', 'U') IS NOT NULL DROP TABLE dbo.collection_item;
IF OBJECT_ID('dbo.collection_event', 'U') IS NOT NULL DROP TABLE dbo.collection_event;
IF OBJECT_ID('dbo.route_stop', 'U') IS NOT NULL DROP TABLE dbo.route_stop;
IF OBJECT_ID('dbo.route', 'U') IS NOT NULL DROP TABLE dbo.route;
IF OBJECT_ID('dbo.truck_maintenance', 'U') IS NOT NULL DROP TABLE dbo.truck_maintenance;
IF OBJECT_ID('dbo.fuel_log', 'U') IS NOT NULL DROP TABLE dbo.fuel_log;
IF OBJECT_ID('dbo.incident_log', 'U') IS NOT NULL DROP TABLE dbo.incident_log;
IF OBJECT_ID('dbo.citizen_feedback', 'U') IS NOT NULL DROP TABLE dbo.citizen_feedback;
IF OBJECT_ID('dbo.waste_bin', 'U') IS NOT NULL DROP TABLE dbo.waste_bin;
IF OBJECT_ID('dbo.truck', 'U') IS NOT NULL DROP TABLE dbo.truck;
IF OBJECT_ID('dbo.employee', 'U') IS NOT NULL DROP TABLE dbo.employee;
IF OBJECT_ID('dbo.waste_type', 'U') IS NOT NULL DROP TABLE dbo.waste_type;
IF OBJECT_ID('dbo.depot', 'U') IS NOT NULL DROP TABLE dbo.depot;
IF OBJECT_ID('dbo.zone', 'U') IS NOT NULL DROP TABLE dbo.zone;
IF OBJECT_ID('dbo.city', 'U') IS NOT NULL DROP TABLE dbo.city;

-- ====================================================
-- ======= GEOGRAPHIC TABLES (TOP LEVEL = CITY) =======
-- ====================================================

CREATE TABLE dbo.city (
    city_id INT IDENTITY(1,1) PRIMARY KEY,
    city_name NVARCHAR(150) NOT NULL,
    region NVARCHAR(150) NULL,
    created_at DATETIME2(0) DEFAULT SYSUTCDATETIME()
);

CREATE TABLE dbo.zone (
    zone_id INT IDENTITY(1,1) PRIMARY KEY,
    city_id INT NOT NULL,
    zone_code NVARCHAR(50) NULL,
    zone_name NVARCHAR(150) NOT NULL,
    area_km2 DECIMAL(9,3) NULL,
    active BIT DEFAULT 1,
    created_at DATETIME2(0) DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_zone_city FOREIGN KEY (city_id) REFERENCES dbo.city(city_id)
);

CREATE TABLE dbo.depot (
    depot_id INT IDENTITY(1,1) PRIMARY KEY,
    depot_code NVARCHAR(50) NULL,
    depot_name NVARCHAR(200) NOT NULL,
    city_id INT NOT NULL,
    depot_type NVARCHAR(50) NULL, -- landfill / recycling / sorting / transfer
    address NVARCHAR(300) NULL,
    latitude DECIMAL(10,7) NULL,
    longitude DECIMAL(10,7) NULL,
    created_at DATETIME2(0) DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_depot_city FOREIGN KEY (city_id) REFERENCES dbo.city(city_id)
);

-- ============================
-- ======= MASTER DATA ========
-- ============================

CREATE TABLE dbo.waste_type (
    waste_type_id INT IDENTITY(1,1) PRIMARY KEY,
    code NVARCHAR(20) NULL,
    type_name NVARCHAR(100) NOT NULL,
    is_recyclable BIT DEFAULT 0,
    description NVARCHAR(400) NULL,
    created_at DATETIME2(0) DEFAULT SYSUTCDATETIME()
);

CREATE TABLE dbo.employee (
    employee_id INT IDENTITY(1,1) PRIMARY KEY,
    employee_number NVARCHAR(50) NULL,
    full_name NVARCHAR(200) NOT NULL,
    role NVARCHAR(50) NOT NULL, -- driver, technician, supervisor...
    phone NVARCHAR(50) NULL,
    license_number NVARCHAR(100) NULL,
    hire_date DATE NULL,
    status NVARCHAR(30) DEFAULT 'active',
    created_at DATETIME2(0) DEFAULT SYSUTCDATETIME()
);

CREATE TABLE dbo.truck (
    truck_id INT IDENTITY(1,1) PRIMARY KEY,
    truck_code NVARCHAR(50) NULL,
    plate_number NVARCHAR(50) NULL,
    capacity_kg DECIMAL(10,2) NULL,
    fuel_type NVARCHAR(50) NULL,
    purchase_year INT NULL,
    status NVARCHAR(30) DEFAULT 'active',
    created_at DATETIME2(0) DEFAULT SYSUTCDATETIME()
);

-- =======================
-- ======= ROUTES ========
-- =======================

CREATE TABLE dbo.route (
    route_id INT IDENTITY(1,1) PRIMARY KEY,
    route_code NVARCHAR(50) NULL,
    route_name NVARCHAR(200) NOT NULL,
    city_id INT NOT NULL,
    expected_duration_minutes INT NULL,
    expected_distance_km DECIMAL(9,2) NULL,
    created_at DATETIME2(0) DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_route_city FOREIGN KEY (city_id) REFERENCES dbo.city(city_id)
);

CREATE TABLE dbo.route_stop (
    route_stop_id INT IDENTITY(1,1) PRIMARY KEY,
    route_id INT NOT NULL,
    zone_id INT NOT NULL,
    stop_order INT NOT NULL,
    notes NVARCHAR(400) NULL,
    CONSTRAINT FK_routestop_route FOREIGN KEY (route_id) REFERENCES dbo.route(route_id),
    CONSTRAINT FK_routestop_zone FOREIGN KEY (zone_id) REFERENCES dbo.zone(zone_id)
);

-- ===================================
-- ======= COLLECTION EVENTS =========
-- ===================================

CREATE TABLE dbo.collection_event (
    collection_event_id INT IDENTITY(1,1) PRIMARY KEY,
    collected_date DATE NOT NULL,
    planned_start DATETIME2(0) NULL,
    actual_start DATETIME2(0) NULL,
    actual_end DATETIME2(0) NULL,
    truck_id INT NOT NULL,
    driver_employee_id INT NOT NULL,
    route_id INT NULL,
    depot_id INT NULL,
    total_weight_kg DECIMAL(12,2) NULL,
    trip_duration_minutes INT NULL,
    fuel_used_liters DECIMAL(10,2) NULL,
    odometer_start_km DECIMAL(12,2) NULL,
    odometer_end_km DECIMAL(12,2) NULL,
    notes NVARCHAR(1000) NULL,
    created_at DATETIME2(0) DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_collection_truck FOREIGN KEY (truck_id) REFERENCES dbo.truck(truck_id),
    CONSTRAINT FK_collection_driver FOREIGN KEY (driver_employee_id) REFERENCES dbo.employee(employee_id),
    CONSTRAINT FK_collection_route FOREIGN KEY (route_id) REFERENCES dbo.route(route_id),
    CONSTRAINT FK_collection_depot FOREIGN KEY (depot_id) REFERENCES dbo.depot(depot_id)
);

CREATE TABLE dbo.collection_item (
    collection_item_id INT IDENTITY(1,1) PRIMARY KEY,
    collection_event_id INT NOT NULL,
    zone_id INT NOT NULL,
    waste_type_id INT NOT NULL,
    measured_at DATETIME2(0) NULL,
    weight_kg DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    volume_m3 DECIMAL(10,3) NULL,
    item_count INT NULL,
    is_estimated BIT DEFAULT 0,
    notes NVARCHAR(500) NULL,
    created_at DATETIME2(0) DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_item_event FOREIGN KEY (collection_event_id) REFERENCES dbo.collection_event(collection_event_id),
    CONSTRAINT FK_item_zone FOREIGN KEY (zone_id) REFERENCES dbo.zone(zone_id),
    CONSTRAINT FK_item_waste FOREIGN KEY (waste_type_id) REFERENCES dbo.waste_type(waste_type_id)
);

-- ======================================
-- ======= SUPPORT / LOG TABLES =========
-- ======================================

CREATE TABLE dbo.truck_maintenance (
    maintenance_id INT IDENTITY(1,1) PRIMARY KEY,
    truck_id INT NOT NULL,
    performed_by_employee_id INT NULL,
    maintenance_date DATE NOT NULL,
    maintenance_type NVARCHAR(150) NULL,
    cost DECIMAL(12,2) NULL,
    notes NVARCHAR(1000) NULL,
    created_at DATETIME2(0) DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_maint_truck FOREIGN KEY (truck_id) REFERENCES dbo.truck(truck_id),
    CONSTRAINT FK_maint_employee FOREIGN KEY (performed_by_employee_id) REFERENCES dbo.employee(employee_id)
);

CREATE TABLE dbo.fuel_log (
    fuel_log_id INT IDENTITY(1,1) PRIMARY KEY,
    truck_id INT NOT NULL,
    log_date DATE NOT NULL,
    liters DECIMAL(12,2) NOT NULL,
    cost DECIMAL(12,2) NULL,
    odometer_km DECIMAL(12,2) NULL,
    station NVARCHAR(200) NULL,
    created_at DATETIME2(0) DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_fuel_truck FOREIGN KEY (truck_id) REFERENCES dbo.truck(truck_id)
);

CREATE TABLE dbo.incident_log (
    incident_id INT IDENTITY(1,1) PRIMARY KEY,
    collection_event_id INT NULL,
    incident_date DATETIME2(0) NOT NULL,
    severity NVARCHAR(30) NULL,
    description NVARCHAR(1000) NULL,
    resolved BIT DEFAULT 0,
    resolved_date DATETIME2(0) NULL,
    created_at DATETIME2(0) DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_incident_event FOREIGN KEY (collection_event_id) REFERENCES dbo.collection_event(collection_event_id)
);

CREATE TABLE dbo.citizen_feedback (
    feedback_id INT IDENTITY(1,1) PRIMARY KEY,
    zone_id INT NULL,
    collection_event_id INT NULL,
    submission_date DATETIME2(0) DEFAULT SYSUTCDATETIME(),
    citizen_name NVARCHAR(200) NULL,
    contact NVARCHAR(200) NULL,
    issue_type NVARCHAR(100) NULL,
    description NVARCHAR(1000) NULL,
    status NVARCHAR(50) DEFAULT 'open',
    resolved_date DATETIME2(0) NULL,
    CONSTRAINT FK_feedback_zone FOREIGN KEY (zone_id) REFERENCES dbo.zone(zone_id),
    CONSTRAINT FK_feedback_event FOREIGN KEY (collection_event_id) REFERENCES dbo.collection_event(collection_event_id)
);

CREATE TABLE dbo.waste_bin (
    bin_id INT IDENTITY(1,1) PRIMARY KEY,
    zone_id INT NOT NULL,
    bin_code NVARCHAR(100) NULL,
    waste_type_id INT NULL,
    capacity_liters DECIMAL(10,2) NULL,
    installation_date DATE NULL,
    condition NVARCHAR(50) DEFAULT 'good',
    created_at DATETIME2(0) DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_bin_zone FOREIGN KEY (zone_id) REFERENCES dbo.zone(zone_id),
    CONSTRAINT FK_bin_waste FOREIGN KEY (waste_type_id) REFERENCES dbo.waste_type(waste_type_id)
);

-- Optional indexes
CREATE INDEX IX_collection_event_date ON dbo.collection_event(collected_date);
CREATE INDEX IX_item_zone ON dbo.collection_item(zone_id);
CREATE INDEX IX_item_waste ON dbo.collection_item(waste_type_id);
GO
