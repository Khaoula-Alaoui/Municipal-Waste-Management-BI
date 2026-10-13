# Municipal Waste Management — Business Intelligence System

**End-to-End Data Warehousing & Business Intelligence Project**

An end-to-end Business Intelligence solution designed to support data-driven decision-making in municipal waste management across Moroccan cities.

The project integrates an operational SQL Server database, a dimensional data warehouse, ETL processes, multidimensional analysis, and interactive reporting to monitor waste collection operations, operational costs, and recycling performance.

## Project Overview

Municipal waste management involves coordinating collection routes, vehicles, employees, waste types, and operational expenses. Fragmented operational data can make it difficult to monitor performance and identify opportunities for improvement.

This project demonstrates how an integrated Business Intelligence architecture can transform operational data into meaningful analytical insights.

**Main objectives:**
- Centralize waste management data from multiple operational entities.
- Design a normalized relational database and a star-schema data warehouse.
- Support analytical queries and multidimensional exploration.
- Analyze collection efficiency, fuel consumption, operational costs, and recycling activity.
- Present key performance indicators through dashboards and reports.

## Technology Stack

| Technology | Purpose |
|---|---|
| Microsoft SQL Server | Relational database and data warehouse |
| T-SQL | Database creation, data manipulation, and querying |
| SSIS | Extract, Transform, Load (ETL) workflows |
| SSAS | Multidimensional OLAP analysis |
| MDX | Analytical queries and calculated measures |
| SSRS | Structured operational reports |
| Power BI | Interactive dashboards and data visualization |

## System Architecture

The solution follows a layered Business Intelligence architecture:

**1. Operational Database (OLTP)**

A normalized SQL Server relational database representing municipal waste management operations, including cities, zones, routes, trucks, employees, waste types, and collection activities.

**2. Data Warehouse**

A dimensional data warehouse organized using a star schema to support analytical workloads and reporting.

**3. ETL Layer**

SQL Server Integration Services (SSIS) workflows for extracting, transforming, and loading operational data into the analytical environment.

**4. Analytical Layer**

SQL Server Analysis Services (SSAS) for multidimensional analysis, supported by MDX queries and calculated measures.

**5. Reporting Layer**

SQL Server Reporting Services (SSRS) and Power BI for presenting operational and analytical indicators.

**Data flow:**

OLTP Database → SSIS ETL → Data Warehouse → SSAS / MDX → SSRS & Power BI

## Key Analytical Capabilities

The implemented solution supports:

- **Waste collection monitoring:** Analysis of collection activity across cities, zones, and time periods.
- **Operational cost analysis:** Exploration of fuel consumption, labor costs, disposal costs, and trip expenses.
- **Fleet and route analysis:** Comparison of operational indicators across vehicles and collection routes.
- **Recycling analysis:** Examination of waste volumes and recyclability characteristics.
- **Performance reporting:** Interactive exploration of key metrics through dashboards and structured reports.

The system uses periodic data refreshes rather than real-time monitoring.

## Repository Structure

```text
Municipal-Waste-Management-BI/
├── OLTP_Source/
│   ├── 1.create_table.sql
│   ├── 2.insert_table.sql
│   ├── 3.visualization.sql
│   └── 4.quickChecks.sql
├── DW/
│   ├── create_dw.sql
│   └── MDXQueries.mdx
├── Dashboard/
│   └── WasteManagementReports.pbix
├── Report/
│   └── Waste_Management_Project_Report.pdf
└── README.md
```

The repository includes SQL scripts, MDX queries, a Power BI file, and technical documentation. The full SSIS and SSAS project files are not currently included.

## Project Documentation

The technical report provides additional details about:

- Operational database design and entity relationships
- Dimensional modeling and data warehouse architecture
- ETL workflows and SSAS cube development
- MDX queries and analytical measures
- SSRS reports and Power BI dashboards
- Results, limitations, and future improvements

See the `Report/` directory for the complete project report.

## Project Context & Contributions

**Author / Portfolio Presentation:** Khawla Chrifi Alaoui  
**Institution:** Al Akhawayn University — School of Science and Engineering  
**Course:** CSC 5301 — Advanced Database Systems & Data Warehousing  
**Academic Term:** Fall 2025

This project was developed as collaborative academic coursework. I contributed to all major technical stages, including database design, data warehousing, ETL development, multidimensional analysis, reporting, testing, and documentation.

This repository presents my technical contributions while acknowledging the collaborative context of the original project.

## Future Improvements

Potential extensions include:

- Real-time collection monitoring using GPS and streaming data
- Predictive models for waste generation and collection demand
- Route optimization to reduce fuel consumption and operational costs
- Integration of external environmental and geographic data
- Automated data-quality monitoring

---

*Academic project developed for educational and portfolio purposes.*
