USE master;
GO

------------------------------------------------------
-- FORCE DISCONNECT + DROP DATABASE SAFELY
------------------------------------------------------
IF DB_ID('WasteManagementDW') IS NOT NULL
BEGIN
    ALTER DATABASE WasteManagementDW 
    SET SINGLE_USER 
    WITH ROLLBACK IMMEDIATE;

    DROP DATABASE WasteManagementDW;
END
GO

------------------------------------------------------
-- RECREATE DATABASE
------------------------------------------------------
CREATE DATABASE WasteManagementDW;
GO

USE WasteManagementDW;
GO

/* ======================================================
   DIMENSIONS
====================================================== */

/* -------- dim_date -------- */
CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,      -- YYYYMMDD
    full_date DATE NOT NULL,
    day INT,
    month INT,
    month_name NVARCHAR(20),
    year INT,
    quarter INT,
    day_of_week INT,
    day_name NVARCHAR(20),
    is_weekend BIT
);
GO


/* -------- dim_location -------- */
CREATE TABLE dim_location (
    location_key INT IDENTITY(1,1) PRIMARY KEY,
    zone_id INT NOT NULL,
    zone_name NVARCHAR(150) NOT NULL,
    city_name NVARCHAR(150) NOT NULL,
    region NVARCHAR(150),
    area_km2 DECIMAL(9,3) NULL
);
GO 


/* -------- dim_waste_type -------- */
CREATE TABLE dim_waste_type (
    waste_type_key INT IDENTITY(1,1) PRIMARY KEY,
    waste_type_id INT NOT NULL,
    type_name NVARCHAR(100) NOT NULL,
    is_recyclable BIT,
    description NVARCHAR(400)
);
GO


/* -------- dim_truck -------- */
CREATE TABLE dim_truck (
    truck_key INT IDENTITY(1,1) PRIMARY KEY,
    truck_id INT NOT NULL,
    truck_code NVARCHAR(50),
    plate_number NVARCHAR(50),
    capacity_kg DECIMAL(12,2),
    fuel_type NVARCHAR(50)
);
GO


/* -------- dim_driver -------- */
CREATE TABLE dim_driver (
    driver_key INT IDENTITY(1,1) PRIMARY KEY,
    employee_id INT NOT NULL,
    full_name NVARCHAR(150),
    phone NVARCHAR(50),
    license_number NVARCHAR(100),
    hire_date DATE
);
GO


/* ======================================================
   FACT TABLE
   fact_waste_operations
   Grain = (date, location, waste type, truck, driver, item)
====================================================== */

CREATE TABLE fact_waste_operations (
    date_key INT NOT NULL,
    location_key INT NOT NULL,
    waste_type_key INT NOT NULL,
    truck_key INT NOT NULL,
    driver_key INT NOT NULL,
    collection_item_id INT NOT NULL,

    /* Waste metrics */
    weight_kg DECIMAL(12,2) NOT NULL,
    volume_m3 DECIMAL(10,3),
    item_count INT DEFAULT 1,

    /* Trip metrics */
    collection_event_id INT NOT NULL,
    distance_traveled_km DECIMAL(10,2),
    trip_duration_minutes INT,
    fuel_used_liters DECIMAL(10,2),

    /* Basic counts */
    bins_emptied_count INT,
    missed_collections_count INT,

    /* These 3 come from OLTP or calculated in SSIS */
    estimated_fuel_cost DECIMAL(12,2),
    disposal_cost DECIMAL(12,2),
    labor_cost DECIMAL(12,2),

    recycling_revenue_potential DECIMAL(12,2),

    measured_at DATETIME,

    /* Composite key */
    PRIMARY KEY (
        date_key,
        location_key,
        waste_type_key,
        truck_key,
        driver_key,
        collection_item_id
    ),

    FOREIGN KEY (date_key) REFERENCES dim_date(date_key),
    FOREIGN KEY (location_key) REFERENCES dim_location(location_key),
    FOREIGN KEY (waste_type_key) REFERENCES dim_waste_type(waste_type_key),
    FOREIGN KEY (truck_key) REFERENCES dim_truck(truck_key),
    FOREIGN KEY (driver_key) REFERENCES dim_driver(driver_key)
);
GO


/* ======================================================
   INDEXES
====================================================== */

CREATE INDEX IX_fwo_date ON fact_waste_operations(date_key);
CREATE INDEX IX_fwo_location ON fact_waste_operations(location_key);
CREATE INDEX IX_fwo_waste ON fact_waste_operations(waste_type_key);
CREATE INDEX IX_fwo_truck ON fact_waste_operations(truck_key);
GO


/* ======================================================
   VIEW FOR BI
====================================================== */

CREATE VIEW vw_waste_analytics AS
SELECT 
    dd.full_date,
    dl.city_name,
    dl.zone_name,
    dwt.type_name AS waste_type,
    dwt.is_recyclable,
    dt.plate_number AS truck_plate,
    ddr.full_name AS driver,
    
    fwo.weight_kg,
    fwo.volume_m3,
    fwo.item_count,
    fwo.distance_traveled_km,
    fwo.trip_duration_minutes,
    fwo.fuel_used_liters,

    fwo.labor_cost,
    fwo.disposal_cost,
    fwo.recycling_revenue_potential,

    -- KPIs
    fwo.weight_kg / 1000.0 AS weight_tonnes,
    CASE WHEN fwo.trip_duration_minutes > 0 
        THEN fwo.weight_kg / (fwo.trip_duration_minutes / 60.0)
    END AS efficiency_kg_per_hour,

    CASE WHEN fwo.fuel_used_liters > 0 
        THEN fwo.distance_traveled_km / fwo.fuel_used_liters
    END AS fuel_efficiency_km_per_l

FROM fact_waste_operations fwo
JOIN dim_date dd ON fwo.date_key = dd.date_key
JOIN dim_location dl ON fwo.location_key = dl.location_key
JOIN dim_waste_type dwt ON fwo.waste_type_key = dwt.waste_type_key
JOIN dim_truck dt ON fwo.truck_key = dt.truck_key
JOIN dim_driver ddr ON fwo.driver_key = ddr.driver_key;
GO


PRINT 'DW READY – CLEANED, MATCHING OLTP, WITH ONE FACT TABLE!';
GO
