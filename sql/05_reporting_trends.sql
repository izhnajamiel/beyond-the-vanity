
-- =====================================================
-- BEYOND THE VANITY
-- 05 - REPORTING TRENDS
-- =====================================================

USE beyond_the_vanity;


-- =====================================================
-- QUERY A: CHEMICAL REPORTS PER YEAR
-- =====================================================

SELECT
    YEAR(initial_date_reported) AS reporting_year,
    COUNT(*) AS total_reports,
    COUNT(DISTINCT product_id) AS distinct_products,
    COUNT(DISTINCT chemical_id) AS distinct_chemicals
FROM chemical_reports
WHERE initial_date_reported IS NOT NULL
GROUP BY YEAR(initial_date_reported)
ORDER BY reporting_year;


-- =====================================================
-- QUERY B: CHEMICAL REPORTS PER MONTH
-- =====================================================

SELECT
    DATE_FORMAT(initial_date_reported, '%Y-%m')
        AS reporting_period,
    COUNT(*) AS total_reports,
    COUNT(DISTINCT product_id) AS distinct_products
FROM chemical_reports
WHERE initial_date_reported IS NOT NULL
GROUP BY
    DATE_FORMAT(initial_date_reported, '%Y-%m')
ORDER BY reporting_period;


-- =====================================================
-- QUERY C: YEARLY PRODUCT AND CHEMICAL COVERAGE
-- =====================================================

SELECT
    YEAR(initial_date_reported) AS reporting_year,
    COUNT(DISTINCT product_id) AS distinct_products,
    COUNT(DISTINCT chemical_id) AS distinct_chemicals,
    COUNT(*) AS total_reports
FROM chemical_reports
WHERE initial_date_reported IS NOT NULL
GROUP BY YEAR(initial_date_reported)
ORDER BY reporting_year;


-- =====================================================
-- QUERY D: REPORTING DATE RANGE
-- =====================================================

SELECT
    MIN(initial_date_reported) AS earliest_initial_report,
    MAX(initial_date_reported) AS latest_initial_report,
    MIN(most_recent_date_reported) AS earliest_most_recent_date,
    MAX(most_recent_date_reported) AS latest_most_recent_date
FROM chemical_reports;


-- =====================================================
-- QUERY E: REPORTING DATE COMPLETENESS
-- =====================================================

SELECT
    COUNT(*) AS total_records,
    SUM(initial_date_reported IS NULL) AS missing_initial_dates,
    SUM(initial_date_reported IS NOT NULL) AS available_initial_dates,
    ROUND(
        SUM(initial_date_reported IS NOT NULL)
        * 100.0 / COUNT(*),
        2
    ) AS date_completeness_percentage
FROM chemical_reports;


-- =====================================================
-- QUERY F: REPORTS WITH MISSING INITIAL REPORTING DATES
-- =====================================================

SELECT
    COUNT(*) AS missing_initial_date_records
FROM chemical_reports
WHERE initial_date_reported IS NULL;
